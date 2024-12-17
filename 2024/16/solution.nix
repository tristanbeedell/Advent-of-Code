{lib, pkgs, ...}: input: rec {
  inherit lib;
  inherit (lib) splitString mod range;
  inherit (lib.lists) findFirstIndex imap0;
  inherit (lib.strings) stringToCharacters;
  inherit (builtins) elemAt concatStringsSep length elem filter foldl' concatLists floor deepSeq listToAttrs attrValues attrNames mapAttrs hasAttr sort;

  index = i: list: elemAt list i;
  index2d = {x, y}: m: m |> index y |> index x;

  init = let
    chart = input |> splitString "\n" |> map stringToCharacters;
    width = (elemAt chart 0 |> length) + 1;
    height = length chart;
    startIndex = input |> stringToCharacters |> findFirstIndex (char: char == "S") null;
    endIndex = input |> stringToCharacters |> findFirstIndex (char: char == "E") null;
  in {
    inherit chart width height;
    pos = {
      x = mod startIndex width;
      y = startIndex / width;
    };
    goal = {
      x = mod endIndex width;
      y = endIndex / width;
    };
  }
  ;

  chartToStr = chart: chart |> (map (concatStringsSep "")) |> concatStringsSep "\n";

  rotate' = {x, y}: {y = -x; x = y;};
  rotate = {x, y}: {y = x; x = -y;};

  addVec = a: b: {x = a.x or 0 + b.x or 0; y = a.y or 0 + b.y or 0;};
  multVec = a: m: {x = a.x or 0 * m; y = a.y or 0 * m;};


  dirs = {
    north = {x = 0; y = -1;};
    east = {x = 1; y = 0;};
    south = {x = 0; y = 1;};
    west = {x = -1; y = 0;};
  };

  search = {
    pos,
    dir,
    score ? 0,
  }: let
    fwd = addVec pos dir;
  in
  if
    index2d fwd init.chart == "#"
    then {pos = null; dist = null;}
  else
  if (isCorner fwd || fwd == init.goal || fwd == init.pos)
    then {
      pos = (key fwd);
      dist = score + 1;
    }
  else
    search {pos = fwd; inherit dir; score = score + 1;}
  ;

  isCorner = pos: index2d pos init.chart == "." &&
    (dirs
    |> mapAttrs (name: dir: let n = addVec pos dir; in index2d n init.chart == ".")
    |> ({north, east, south, west}:
      north && east || east && south || south && west || west && north))
  ;

  key = {x, y}: "${toString (y + 1)},${toString (x + 1)}";

  corners = range 1 (init.width - 3) |> map (x:
    range 1 (init.height - 3) |> map (y: {inherit x y;})
  )
  |> concatLists
  |> filter isCorner
  |> (nodes: nodes ++ [init.pos init.goal])
  |> map (pos: {
    name = key pos;
    value = ({
      north = search {inherit pos; dir = dirs.north;};
      east = search {inherit pos; dir = dirs.east;};
      south = search {inherit pos; dir = dirs.south;};
      west = search {inherit pos; dir = dirs.west;};
    } |> lib.filterAttrs (n: v: !isNull v.pos)) // {
      # pos = key pos;
    };
  })
  |> listToAttrs;

  notNull = value: !isNull value;

###### collecting continuous corners, doesn't work.
  countDirs = {north ? null, south ? null, east ? null, west ? null, ...}:
    [north south east west]
      |> filter (dir: notNull dir && notNull dir.pos)
      |> length
  ;

  continue = prev: {dirs, dist ? 0}: let
    dir = if prev == "north" then "south" else
      if prev == "south" then "north" else
      if prev == "west" then "east" else
      if prev == "east" then "west" else
        throw "${toString prev} is not a direction!";
    prevEdge = dirs.${dir};
  in
    dirs |> lib.attrsToList |> lib.findFirst (
      {name, value}: !(name == dir) && !(isDead value)
    ) null
    |> (res: res.value // {dir = res.name;})
    |> (next: let
      nextCorner = corners.${next.pos};
    in
    if isDead nextCorner || isDeadend nextCorner then null else
    if isNode nextCorner
      then next // {dist = next.dist + dist + prevEdge.dist + 1000;}
      else continue next.dir {
        dirs = nextCorner;
        dist = dist + prevEdge.dist + 1000;
      }
    )
  ;

  isDead = corner: corner.pos or null == null;

  isNode = corner: let c = countDirs corner; in isTerminal corner || c > 2 || c == 1;
  isTerminal = corner: corner.pos == key init.goal || corner.pos == key init.pos;
  isDeadend = corner: let c = countDirs corner; in c == 1;

  nodes = corners |> mapAttrs (start: corner:
    joinNodes corner
  );

  joinNodes = corner:
    corner |> mapAttrs (dir: next:
      if isDead next || isDeadend next
        then null
      else if !isNode corners.${next.pos}
        then continue dir {dirs = corners.${next.pos};}
      else
        next // {inherit dir;})
    |> lib.filterAttrs (n: v: notNull v)
  ;
########

  nodeGraph = graph: pkgs.runCommand "graph" {} ''
    mkdir -p $out
    echo 'digraph {
      ${graph |> mapAttrs (from: edges:
        edges |> mapAttrs (dir: edge: if isNull edge.pos or null then "" else ''
          "${from}" -> "${edge.pos}" [label="${dir} ${toString edge.dist}"]
        '') |> attrValues |> concatStringsSep "\n"
      ) |> attrValues |> concatStringsSep "\n"}
    }' > $out/graph.dot
    cat $out/graph.dot | ${pkgs.graphviz}/bin/dot -Tsvg > $out/graph.svg
  '';

  graphs = {
    corners = nodeGraph corners;
    nodes = nodeGraph nodes;
  };

  initScores = {
    ${key init.pos} = {
      dir = "east";
      steps = 0;
      turns = 0;
      pos = key init.pos;
    };
  };

  getLowest = state: let
    unvisited = removeAttrs state.scores state.done;
  in
    attrValues unvisited |> foldl' (acc: node:
      if isNull acc.turns then node else
        if isNull node.turns then acc else
        if acc.turns < node.turns then acc else node
    ) {turns = null; steps = null;}
  ;

  getScores = {done ? [], scores ? initScores}: let
    prev = getLowest {inherit done scores;};
  in
    corners.${prev.pos}
    |> mapAttrs (dir: edge: let
      turns = if prev.dir == dir then prev.turns else prev.turns + 1;

      existing = scores.${edge.pos} or null;
      steps = prev.steps + edge.dist;
      sameSteps = notNull existing
        && existing.steps == steps
        # && turns == existing.turns
      ;
      isBetter = isNull existing ||
        (existing.steps > steps);
      newScore = {
        inherit steps dir turns;
        inherit (edge) pos;
        prev = prev.pos;
      };
    in {
      name = edge.pos;
      value = if sameSteps then
        existing // {alt = newScore;}
      else if isBetter
      then newScore
      else existing
      ;
    })
    |> attrValues
    |> listToAttrs
    |> (newScores: {
      scores = scores // newScores;
      done = done ++ [prev.pos];
    })
  ;

  fastest = goal: s: let
    next = getScores s;
  in if elem (key goal) (next.done) then next else fastest goal next;

  pathScore = steps: turns: steps + turns * 1000;

  toGoal = (fastest init.goal {}).scores.${key init.goal};

  part1result = pathScore toGoal.steps toGoal.turns;

# PART 2

  # WIP:
  # go through the path, add each pos to visited
  # if point has alt, find points on that path not visited yet.
  # add length of filtered alt, (-1 for the overlap at end?).
  # add alt to visited.
  pathToList = scores: pos:
  let
    res = scores.${pos};
    prevPath = if res ? prev then pathToList scores res.prev else [];
    fullaltPath = pathToList scores res.alt.prev;
    joinIndex = findFirstIndex ({pos,...}: !elem pos (map ({pos, ...}: pos) prevPath)) null fullaltPath;
    altPath = lib.sublist (joinIndex - 1) (length fullaltPath) fullaltPath;

    thisSpot = {inherit (res) pos steps turns dir; };

  in
  prevPath
  ++
  [(thisSpot // {
    alt = if res ? alt then altPath ++ [thisSpot] else null;
  })]
  ;

  cornerScores = fastest init.goal {};

  part1path = (pathToList cornerScores.scores (key init.goal));


}
