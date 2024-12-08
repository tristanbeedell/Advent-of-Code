{lib, ...}: let

  addVec = a: b: {x = a.x + b.x; y = a.y + b.y;};
  subVec = a: b: {x = a.x - b.x; y = a.y - b.y;};

  toCharList = builtins.foldl'
    ({y, x, chars}: char:
      if char == "." || char == "#" then {inherit y; x = x + 1; inherit chars;}
      else if char == "\n" then {y = y + 1; x = 1; inherit chars;}
      else {inherit y; x = x + 1; chars = chars ++ [{inherit x y char;}];}
    )
    {y = 1; x = 1; chars = [];} # yeah starting at 1,1 what you gonna do about it
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
    size = amap.x;
  in amap.nodes
      |> lib.concatLists
      |> builtins.filter ({x, y}: x > 0 && y > 0 && x < size && y < size)
      |> lib.unique
  ;

in {
  inherit addVec subVec toCharList toNodes;

  part1result = s: s
    |> lib.trim
    |> lib.stringToCharacters
    |> toCharList
    |> toNodes
    |> getUniqueNodes
    |> builtins.length
  ;


}
