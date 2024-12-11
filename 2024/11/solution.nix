{lib, ...}: let
  inherit (builtins) stringLength concatLists substring foldl' add attrValues;
  inherit (lib.strings) toIntBase10;
in input: rec {

  blinkStone = stone: count:
    if toIntBase10 stone == 0 then [{ "1" = count; }]
    else let
      strStone = toString (toIntBase10 stone);
      len = stringLength strStone;
      left = (substring 0 (len / 2) strStone );
      right = (substring (len / 2) (len / 2) strStone);
    in
    if lib.mod len 2 == 0 then
      if left == right then [{${left} = count * 2;}] else [
        { ${left} = count; ${right} = count; }
      ]
    else [{
      ${toString ((toIntBase10 stone) * 2024)} = count;
    }]
  ;

  bfast = stones: stones
    |> (builtins.mapAttrs (stone: blinkStone stone))
    |> attrValues
    |> concatLists
    |> addStones
  ;

  bfastt = times: stones:
    if times == 0 then stones |> attrValues |> foldl' add 0
    else bfastt (times - 1) (bfast stones)
  ;

  addStones = builtins.zipAttrsWith (stone: foldl' add 0);

  initialStones = input
    |> lib.trim
    |> lib.splitString " "
    |> map toIntBase10
    |> toStones
  ;

  toStones = numbers: numbers
    |> map (number: {name = toString number; value = 1;})
    |> builtins.listToAttrs
  ;

  part1result = bfastt 25 initialStones;
  part2result = bfastt 75 initialStones;

}
