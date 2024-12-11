{pkgs ? import <nixpkgs> {}, aoc-inputs ? "/tmp/aoc-inputs"}:
let
  inherit (pkgs) lib;
in
(lib.range 1 11
  |> map (i: let id = lib.fixedWidthNumber 2 i; in {
    name = "day-${id}";
    value = let
      solution = import ./${id}/solution.nix pkgs;
      example = (pkgs.lib.readFile ./${id}/example.txt);
      input = (pkgs.lib.readFile "${aoc-inputs}/${id}");
    in {
      example = solution example;
      real = solution input;
    };
  })
  |> builtins.listToAttrs
  )
