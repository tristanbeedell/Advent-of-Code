{describe, it, ...}:
let
  pkgs = import <nixpkgs> {};
  solution = import ./solution.nix pkgs;
  exampleInput = pkgs.lib.readFile ./example;
  sample1Input = pkgs.lib.readFile ./sample1;
in [
  (describe "part 1" [
    (it "get's the answer with example input" {
      actual = solution.part1result exampleInput;
      expected = 14;
    })
    (it "get's the answer with other sample" {
      actual = solution.part1result sample1Input;
      expected = 4;
    })
    (it "adds vectors" {
      actual = solution.addVec {x = 1; y = 2;} {x = 3; y = 4;};
      expected = {x = 4; y = 6;};
    })
    (it "subtracts vectors" {
      actual = solution.subVec {x = 4; y = 3;} {x = 1; y = 2;};
      expected = {x = 3; y = 1;};
    })
  ])
]
