{describe, it, ...}:
let
  pkgs = import <nixpkgs> {};
  lib = pkgs.lib;
  solution = import ./solution.nix pkgs;
  sample1 = "2333133121414131402";
  sample2 = "12345";

in [
  (describe "part 1" [
  ])
]
