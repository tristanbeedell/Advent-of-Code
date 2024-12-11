{lib, ...}: input: let
  inherit (builtins) stringLength concatLists substring foldl';

  initStones = input
    |> lib.trim
    |> lib.splitString " "
    |> map lib.strings.toIntBase10
  ;

  blinkStone = stone:
    if stone == 0 then 1
    else let
      strStone = toString stone;
      len = stringLength strStone;
    in
      if lib.mod len 2 == 0 then [
      (substring 0 (len / 2) strStone |> lib.strings.toIntBase10)
      (substring (len / 2) (len / 2) strStone |> lib.strings.toIntBase10)
    ]
    else stone * 2024
  ;

  blinkStones = stones:
   if !builtins.isList stones then blinkStone stones
   else map blinkStones stones
  ;

  blinkTimes = count: stones: lib.range 1 count |>
    foldl' (stones: i: blinkStones stones) stones
  ;

  flattenStones = {count ? 0, stones}: if builtins.isList stones then
    map (stone: flattenStones {stones = stone;}) stones |> foldl' (a: b: a + b) 0
  else 1;

in {

  inherit initStones blinkStone blinkTimes blinkStones flattenStones;

  part1result = blinkTimes 25 initStones
    |> (stones: flattenStones {inherit stones;})
  ;

  part2result = blinkTimes 75 initStones
    |> (stones: flattenStones {inherit stones;})
  ;

}
