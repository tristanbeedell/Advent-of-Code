{lib, ...}: input: let

  abs = n: if n > 0 then n else -n;

  addVec = a: b: {x = a.x + b.x; y = a.y + b.y;};
  subVec = a: b: {x = a.x - b.x; y = a.y - b.y;};
  multVec = m: vec: {x = vec.x * m; y = vec.y * m;};
  modVec = m: vec: {x = lib.mod vec.x m; y = lib.mod vec.y m;};

  toCharList = builtins.foldl'
    ({y, x, chars}: char:
      if char == "." || char == "#" then {inherit y; x = x + 1; inherit chars;}
      else if char == "\n" then {y = y + 1; x = 0; inherit chars;}
      else {inherit y; x = x + 1; chars = chars ++ [{inherit x y char;}];}
    )
    {y = 0; x = 0; chars = [];}
  ;

  toNodes = {chars, ...}@amap: amap // {
    nodes = map (antenna:
      builtins.foldl' (acc: antenna2:
        if antenna == antenna2 then acc
        else if antenna.char != antenna2.char then acc
        else let
          delta = subVec antenna antenna2;
        in acc ++ [(addVec antenna delta)]
      ) [] chars
    ) chars;
  };

  getUniqueNodes = amap: let
    # assumes width == height ¯\_(ツ)_/¯
    size = assert amap.x == amap.y + 1; amap.x;
  in amap.nodes
      |> lib.concatLists
      |> builtins.filter ({x, y}: x >= 0 && y >= 0 && x < size && y < size)
      |> lib.unique
  ;

  cut = i: list: lib.sublist i (builtins.length list) list;

  toDeltas = {chars, ...}@amap: amap // {
    deltas = chars |> lib.imap0 (i: antenna: {
      pos = {inherit (antenna) x y;};
      deltas = chars |> cut i |> builtins.foldl' (acc: antenna2:
        if antenna == antenna2 then acc
        else if antenna.char != antenna2.char then acc
        else let
          delta = subVec antenna antenna2;
        in acc ++ [delta]
      ) [];
    });
  };

  deltaToNodes = size: {pos, delta}:
    builtins.genList
      (i: delta |> multVec i |> subVec (minNode size pos delta))
      (size / (lib.max (abs delta.x) (abs delta.y)) + 1)
    |> builtins.filter ({x, y}: x >= 0 && y >= 0 && x < size && y < size)
  ;

  minNode = size: pos: delta: let sub = addVec pos delta; in
    if sub.x < 0 || sub.y < 0 || sub.x >= size || sub.y >= size then pos
    else minNode size sub delta;

in {
  inherit addVec subVec toCharList toNodes toDeltas multVec modVec deltaToNodes minNode;

  part1result = input
    |> lib.trim
    |> lib.stringToCharacters
    |> toCharList
    |> toNodes
    |> getUniqueNodes
    |> builtins.length
  ;

  part2result = input
    |> lib.trim
    |> lib.stringToCharacters
    |> toCharList
    |> toDeltas
    |> ({deltas,x,...}: deltas |> map (antenna:
      antenna.deltas |> map (delta: deltaToNodes x {
        inherit delta;
        inherit (antenna) pos;
      }
    )))
    |> lib.concatLists
    |> lib.concatLists
    |> lib.unique
    |> builtins.length
  ;

}
