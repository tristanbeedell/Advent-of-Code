{lib, ...}: {file}: rec {
  rawContent = builtins.readFile file;
  content = lib.strings.removeSuffix "\n" rawContent;

  toLines = lib.strings.splitString "\n";
  toLevels = map ( line: line
      |> lib.strings.splitString " "
      |> map lib.strings.toInt
    )
  ;
  isSafe = builtins.foldl'
    ({prev ? null, inc ? null, safe}: next:
      if !safe then {inherit safe;} else
      if prev == null then {prev = next; inherit safe;} else
      let
        diff = next - prev;
        safeDiff = abs diff > 0 && abs diff <= 3;
        isInc = next > prev;
      in {
        prev = next;
        safe = safeDiff && ( isInc == inc || isNull inc );
        inc = isInc;
      }
    )
    {safe = true;};
  abs = n: if n > 0 then n else -n;

  countSafety = lib.lists.count (level: level.safe);

  getPart1Result = input: input
    |> toLines
    |> toLevels
    |> map isSafe
    |> countSafety
  ;

  part1result = getPart1Result content;
}
