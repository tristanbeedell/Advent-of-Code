{input ? "", lib, pkgs, ...}: let
  inherit (builtins) elemAt filter length;

  exampleIn = lib.readFile ./example.txt;
  
  mkSolution = {text}: let
    parts = text |> lib.trim |> lib.splitString "\n\n";
    towels = elemAt parts 0 |> lib.splitString ", ";
    regex = ''(${builtins.concatStringsSep "|" towels})+'';
    desired = elemAt parts 1 |> lib.splitString "\n";
    matches = desired |> map (e: lib.traceSeq e (lib.match regex e));
  in {
    inherit towels regex desired matches;
    count = matches
      |> filter (m: !isNull m)
      |> length;
  };

  input-file = pkgs.writeText "input.txt" input;
  bun-run = js-file: pkgs.runCommand "2024day9" {} ''
    ${lib.getExe pkgs.bun} ${js-file} ${input-file} > $out
  '' |> builtins.readFile |> lib.trim;

in {
  example = mkSolution {
    text = exampleIn;
  };
  real = throw "lol this solution is wayy too slow for the real input";
  javascript = {
    part1result = lib.trace "this is a dumb and slow solution" (bun-run ./solution.js);
  };
}
