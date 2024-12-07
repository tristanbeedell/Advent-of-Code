{describe, it, ...}:
let
  pkgs = import <nixpkgs> {};
  solution = import ./solution.nix pkgs;
  exampleInput = pkgs.lib.readFile ./example.txt;
  example = solution exampleInput;
  parsedExample = [
        {target = 190; vals = [10 19];}
        {target = 3267; vals = [ 81 40 27 ];}
        {target = 83; vals = [ 17 5 ];}
        {target = 156; vals = [ 15 6 ];}
        {target = 7290; vals = [ 6 8 6 15 ];}
        {target = 161011; vals = [ 16 10 13 ];}
        {target = 192; vals = [ 17 8 14 ];}
        {target = 21037; vals = [ 9 7 18 13 ];}
        {target = 292; vals = [ 11 6 16 20 ];}
      ];
in [
  (describe "part 1" [
    (it "get's lines" {
      actual = example.data;
      expected = parsedExample;
    })
    (it "calculates sum of a list" {
      actual = map example.total [
        [1 1 1 1]
        [1 2 3 4]
      ];
      expected = [
        4
        10
      ];
    })
    (it "calculates mult of a list" {
      actual = map example.multiply [
        [1 1 1 1]
        [1 2 3 4]
      ];
      expected = [
        1
        24
      ];
    })
    (it "checks if a list is possible" {
      actual = map example.isPossible parsedExample;
      expected = [
        true true false false false false false false true
      ];
    })
    (it "gets the correct result" {
      actual = example.part1result;
      expected = 3749;
    })
  ])
  (describe "part 2" [
    (it "concats numbers" {
      actual = example.concat 12 34;
      expected = 1234;
    })
    (it "checks if a list is possible" {
      actual = map example.isPossible2 parsedExample;
      expected = [
        true true false true true false true false true
      ];
    })
  ])

  (describe "faster" [
    (it "checks number ends with" {
      actual = example.endsWith 6 486 ;
      expected = true;
    })
    (it "cuts end off number" {
      actual = example.truncate 7515 2;
      expected = 75;
    })
    (it "checks if a list is possible with add and mult" {
      actual = map (example.isPossibleFast example.part1ops) parsedExample;
      expected = [
        true true false false false false false false true
      ];
    })
    (it "checks if a list is possible with concat" {
      actual = map (example.isPossibleFast example.part2ops) parsedExample;
      expected = [
        true true false true true false true false true
      ];
    })
  ])

]
