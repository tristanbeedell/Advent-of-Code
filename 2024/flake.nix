{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    tix.url = "git+https://git.tristans.cloud/tristan/tix";
  };

  outputs = { self, nixpkgs, tix }: let
    pkgs = import nixpkgs {system = "x86_64-linux";};
  in {

    day06 = let
      solution = import ./06/solution.nix pkgs;
      example = (pkgs.lib.readFile ./06/example.txt);
      input = (pkgs.lib.readFile ./06/input.txt);
    in {
      example = (solution example);
      sample1 = (solution ''
.#..
.^#.
.#..'');
      sample2 = (solution ''
.#......
........
.....#..
#.......
..#.#...
...^....'');
      real = (solution input);
    };

    packages.x86_64-linux.watch = tix.watch {
      cmd = ''
        nix run .\#test --impure --extra-experimental-features pipe-operators
      '';
    };

    packages.x86_64-linux.test = tix.run [
      ./solution.test.nix
    ];

  };
}
