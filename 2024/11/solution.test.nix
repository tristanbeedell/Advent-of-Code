{it, describe, ...}: let
  pkgs = import <nixpkgs> {};
  lib = pkgs.lib;
  solution = import ./solution.nix pkgs;
in [
  (describe "part 1" [
    (it "gets the stones" {
      actual = (solution "125 17").initStones;
      expected = [125 17];
    })

    (it "blinks a 0 to a 1" {
      actual = (solution "").blinkStone 0;
      expected = 1;
    })

    (it "blinks a even len num to two nums" {
      actual = (solution "").blinkStone 1000;
      expected = [10 0];
    })

    (it "blinks a other nums to 2024" {
      actual = (solution "").blinkStone 125;
      expected = 253000;
    })

    (it "blinks stones once" {
      actual = (solution "").blinkStones [125 17];
      # |> builtins.concatLists;
      expected = [253000 [1 7]];
    })

    (it "blinks stones list of lists" {
      actual = (solution "").blinkStones [253000 [1 7]];
      expected = [[253 0] [2024 14168]];
    })

    (it "blinks stones 2 times" {
      actual = (solution "").blinkTimes 2 [125 17];
      expected = [[253 0] [2024 14168]];
    })

    (it "counts 1 stone" {
      actual = (solution "").flattenStones {stones = 17;};
      expected = 1;
    })

    (it "counts 2 stones" {
      actual = (solution "").flattenStones {stones = [1 2];};
      expected = 2;
    })

    (it "flattens stones" {
      actual = (solution "").flattenStones {stones = [[125 1 [1 2 3]] 17];};
      expected = builtins.length [125 1 1 2 3 17];
    })

    (it "gets the result" {
      actual = (solution "125 17").part1result;
      expected = 55312;
    })

  ])
]
