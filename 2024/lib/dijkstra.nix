{lib, pkgs, ...}: init: rec {
  inherit lib;
  inherit (lib) splitString mod range;
  inherit (lib.lists) findFirstIndex imap0;
  inherit (lib.strings) stringToCharacters;
  inherit (builtins) elemAt concatStringsSep length elem filter foldl' concatLists floor deepSeq listToAttrs attrValues attrNames mapAttrs hasAttr sort genList;

  index = i: list: if isNull list || i < 0 || i >= length list then null else elemAt list i;
  index2d = {x, y}: m: m |> index y |> index x;

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
    elem (index2d fwd init.chart) [null "#"]
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

  isCorner = pos: index2d pos init.chart == "." # &&
    # (dirs
    # |> mapAttrs (name: dir: let n = addVec pos dir; in index2d n init.chart == ".")
    # |> ({north, east, south, west}:
    #   north && east || east && south || south && west || west && north))
  ;

  key = {x, y}:
   "${toString x},${toString y}";
# gives locations like vim cursor indicator
#"${toString (y + 1)},${toString (x + 1)}";

  corners = range 0 (init.width - 1) |> map (x:
    range 0 (init.height - 1) |> map (y: {inherit x y;})
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
      if isNull acc.steps then node else
        if isNull node.steps then acc else
        if acc.steps < node.steps then acc else node
    ) {turns = null; steps = null; pos = null;}
  ;

  getScores = {done ? [], scores ? initScores}: let
    prev = getLowest {inherit done scores;};
  in
    if isNull prev.pos then {inherit done scores; impossible = true;}
    else
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

  getFastest = goal: s: let
    next = getScores s;
  in if next.impossible or false || elem (key goal) (next.done)
    then next
    else getFastest goal next;

  pathScore = steps: turns: steps + turns * 1000;

  isImpossible = (getFastest init.goal {}).impossible or false;
  fastestTo = (getFastest init.goal {}).scores;

  toGoal = fastestTo.${key init.goal};

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
      # alt = altPath.path;
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

  cornerScores = getFastest init.goal {};

  path = (pathToList cornerScores.scores {}).path;

  pathChart = genList (y: genList (x:
    if index2d {inherit x y;} init.chart == "#" then "#"
    else if elem (key {inherit x y;}) (map ({pos,...}: pos) path) then "O"
    else "."
  ) init.width) init.height;
}
