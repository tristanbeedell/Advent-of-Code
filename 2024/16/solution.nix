{lib, pkgs, ...}: input: rec {
  inherit lib;
  inherit (lib) splitString mod range;
  inherit (lib.lists) findFirstIndex imap0;
  inherit (lib.strings) stringToCharacters;
  inherit (builtins) elemAt concatStringsSep length elem filter foldl' concatLists floor deepSeq listToAttrs attrValues attrNames mapAttrs hasAttr;

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
    then null
  else
  if (isNode fwd || fwd == init.goal || fwd == init.pos)
    then {
      name = (key fwd);
      value = score + 1;
    }
  else
    search {pos = fwd; inherit dir; score = score + 1;}
  ;

  isNode = pos: index2d pos init.chart == "." &&
    (dirs
    |> mapAttrs (name: dir: let n = addVec pos dir; in index2d n init.chart == ".")
    |> ({north, east, south, west}:
      north && east || east && south || south && west || west && north))
  ;

  key = {x, y}: "${toString (y + 1)},${toString (x + 1)}";

  nodes = range 1 (init.width - 3) |> map (x:
    range 1 (init.height - 3) |> map (y: {inherit x y;})
  )
  |> concatLists
  |> filter isNode
  |> (nodes: nodes ++ [init.pos init.goal])
  |> map (pos: {
    name = key pos;
    value = {
      north = search {inherit pos; dir = dirs.north;};
      east = search {inherit pos; dir = dirs.east;};
      south = search {inherit pos; dir = dirs.south;};
      west = search {inherit pos; dir = dirs.west;};
    } |> lib.filterAttrs (n: v: !isNull v);
  })
  |> listToAttrs;

  graph = pkgs.runCommand "graph" {} ''
    mkdir -p $out
    echo 'digraph {
      ${nodes |> mapAttrs (from: tos:
        tos |> mapAttrs (dir: edge: if isNull edge then "" else ''
          "${from}" -> "${edge.name}" [label="${dir} ${toString edge.value}"]
        '') |> attrValues |> concatStringsSep "\n"
      ) |> attrValues |> concatStringsSep "\n"}
    }' > $out/graph.dot
    cat $out/graph.dot | ${pkgs.graphviz}/bin/dot -Tsvg > $out/graph.svg
  '';

  getPath = {
    pos ? key init.pos
  , goal
  , dir ? "east"
  , score ? 0
  , hist ? []
  , acc ? {}
  }: let
    node = nodes.${pos};
  in attrNames node |> foldl' (best: edgedir:
  lib.traceSeq acc 
  (let
    newHist = hist ++ [edge.name value];
    edge = node.${edgedir};
    turnCost = if edgedir == dir then 0 else 1000;
    value = edge.value + turnCost;
    newScore = score + value;
  in
    if isNull edge || elem edge.name hist || (hasAttr "score" best && newScore > best.score) then best else
    if edge.name == goal && (hasAttr "score" best -> newScore < best.score) then
      ({score = newScore;})
    else
      getPath {
        pos = edge.name;
        dir = edgedir;
        score = newScore;
        hist = newHist;
        acc = best;
        inherit goal;
      }
  )) acc;

  initScores = {
    scores = mapAttrs (n: v:
      if n == key init.pos then {dir = "east"; score = 0; pos = n;}
      else {dir = null; score = null; pos = n;}
    ) nodes;
    done = [];
  };

  getScores = state: let
    unvisited = removeAttrs state.scores state.done;
    top = attrValues unvisited |> foldl' (acc: node:
      if isNull acc.score then node else
        if isNull node.score then acc else
        if acc.score < node.score then acc else node
    ) {score = null;};
  in
    nodes.${top.pos}
    |> mapAttrs (dir: {name, value}: let
      turnCost = if top.dir == dir then 0 else 1000;
      existing = state.scores.${name};
      score = top.score + value + turnCost;
      isBetter = isNull existing.score || existing.score > score;
    in {
      inherit name;
      value = if elem name state.done || !isBetter then existing else {
        inherit dir score;
        pos = name;
      };
    })
    |> attrValues
    |> listToAttrs
    |> (newScores: {
      scores = state.scores // newScores;
      done = state.done ++ [top.pos];
    })
  ;

  getPriority = {scores, done}: scores
    |> lib.attrsToList
    |> filter ({name, ...}: !elem name done)
    |> filter ({value, ...}: !isNull value.score)
    |> sortQueue
  ;

  lessThan = a: b: isNull a || isNull b || a < b;

  sortQueue = q: q
    |> builtins.sort (a: b: lessThan a.value.score b.value.score)
    # |> (q: lib.traceSeq (map (v: v.value.score) q) q)
    |> map ({name, value}: {
      pos = name;
      inherit (value) dir score;
    })
  ;

  fastest = s: let
    next = getScores s;
  in if elem (key init.goal) next.done then next else fastest next;

  part1result = (fastest initScores).scores.${key init.goal};

}
