{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    tix.url = "git+https://git.tristans.cloud/tristan/tix";
    /*
     * sharing your puzzle inputs is discouraged:
     * https://adventofcode.com/about#faq_copying
     * 
     * so on a new day, paste the input into
     * /tmp/aoc-inputs/${day number}
     * 
     * and run
     * nix flake update aoc-inputs
     */
    aoc-inputs = {
      url = "path:/tmp/aoc-inputs";
      flake = false;
    };
  };

  outputs = { aoc-inputs, nixpkgs, tix, ... }: let
    pkgs = import nixpkgs {system = "x86_64-linux";};
    inherit (pkgs) lib;


  in (lib.range 1 14
  |> map (i: let id = lib.fixedWidthNumber 2 i; in {
    name = "day-${id}";
    value = let
      solution = import ./${id}/solution.nix pkgs;
      example = (pkgs.lib.readFile ./${id}/example.txt);
      input = (pkgs.lib.readFile "${aoc-inputs}/${id}");
    in {
      example = solution example;
      real = solution input;
      test = tix.run [
        ./${id}/solution.test.nix
      ];
    };
  })
  |> builtins.listToAttrs
  );
}
