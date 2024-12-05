{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    tix.url = "git+https://git.tristans.cloud/tristan/tix";
  };

  outputs = { self, nixpkgs, tix }: let
    pkgs = import nixpkgs {system = "x86_64-linux";};
    solution = import ./solution.nix pkgs;
  in {

    part1example = (solution (pkgs.lib.readFile ./example.txt)).part1result;
    part1 = (solution (pkgs.lib.readFile ./input.txt)).part1result;

    part2example = (solution (pkgs.lib.readFile ./example.txt)).part2result;
    part2 = (solution (pkgs.lib.readFile ./input.txt)).part2result;

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
