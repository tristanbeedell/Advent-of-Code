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
    } |> lib.filterAttrs (n: v: !isNull v.pos));
  })
  |> listToAttrs;

  notNull = value: !isNull value;

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
  };

  initScores = {
    ${key init.pos} = {
      dir = "east";
      steps = 0;
      dist = 0;
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
      # can't evaluate same turns
      # because we don't know where we will turn next.
      sameSteps = notNull existing
        && existing.steps == steps
      ;
      isBetter = isNull existing ||
        (existing.steps > steps);
      newScore = {
        inherit steps dir turns;
        inherit (edge) pos dist;
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
  # if point has alt,
  # TODO: and the alt turns add up to the correct path.
  # find points on that path.
  # add length of filtered alt, (-1 for the overlap at end?).
  # add alt to visited.
  pathToList = scores: {pos ? key init.goal, visited ? []}:
  let
    res = scores.${pos};
    prevPath = if res ? prev
      then pathToList scores {pos = res.prev; visited = visited;}
      else {path = []; visited = [pos];};
    a = pathToList scores {pos = res.alt.prev; visited = visited ++ prevPath.visited;};
    altPath = if res ? alt
      then {path = [thisAltSpot] ++ a.path; inherit (a) visited;}
      else {path = []; visited = [];}
    ;

    thisSpot = {inherit (res) pos steps turns dir dist;
      alt = altPath.path;
    };
    thisAltSpot = {inherit (res.alt) pos steps turns dir dist;
      alt = [];
    };

  in {
    visited = [pos] ++ prevPath.visited ++ altPath.visited;
    path =
      if elem pos visited then [] else
      [thisSpot]
      ++
      prevPath.path
    ;
  };

  cornerScores = fastest init.goal {};

  addDist = foldl' (acc: {dist,alt,dir,...}:
    acc + dist + (if addDist alt == 1 then 0 else (addDist alt) - 2)
  ) 1;

  part1path = (pathToList cornerScores.scores {});

# not 520, too high
  part2resultWrong = addDist part1path.path;


}
