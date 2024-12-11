pkgs: input: let
  inherit (pkgs) lib;
  nix-solution = import ./bad.solution.nix pkgs input;
  input-file = pkgs.writeText "input.txt" input;
  bun-run = js-file: pkgs.runCommand "2024day9" {} ''
    ${lib.getExe pkgs.bun} ${js-file} ${input-file} > $out
  '' |> builtins.readFile |> lib.trim;
in nix-solution // {
  javascript = {
    part1result = bun-run ./solution.js;
    part2result = bun-run ./solution2.js;
  };
}
