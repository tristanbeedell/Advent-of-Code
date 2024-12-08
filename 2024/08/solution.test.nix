{describe, it, ...}:
let
  pkgs = import <nixpkgs> {};
  lib = pkgs.lib;
  solution = import ./solution.nix pkgs;
  exampleInput = pkgs.lib.readFile ./example;
  sample1Input = pkgs.lib.readFile ./sample1;

  charmap = {
    chars = [
      { char = "0"; x = 8; y = 1; }
      { char = "0"; x = 5; y = 2; }
      { char = "0"; x = 7; y = 3; }
      { char = "0"; x = 4; y = 4; }
      { char = "A"; x = 6; y = 5; }
      { char = "A"; x = 8; y = 8; }
      { char = "A"; x = 9; y = 9; }
    ];
    x = 12;
    y = 11;
  };

  deltamap = [
    { deltas = [ { x = 3; y = -1; } { x = 1; y = -2; } { x = 4; y = -3; } ]; pos = { x = 8; y = 1; }; }
    { deltas = [ { x = -2; y = -1; } { x = 1; y = -2; } ]; pos = { x = 5; y = 2; }; }
    { deltas = [ { x = 3; y = -1; } ]; pos = { x = 7; y = 3; }; }
    { deltas = []; pos = { x = 4; y = 4; }; }
    { deltas = [ { x = -2; y = -3; } { x = -3; y = -4; } ]; pos = { x = 6; y = 5; }; }
    { deltas = [ { x = -1; y = -1; } ]; pos = { x = 8; y = 8; }; }
    { deltas = []; pos = { x = 9; y = 9; }; }
  ];
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
  (describe "part 2" [
    (it "get's char list" {
      actual = exampleInput |> lib.trim |> lib.stringToCharacters
        |> solution.toCharList;
      expected = charmap;
    })
    (it "gets deltas" {
      actual = (charmap |> solution.toDeltas).deltas;
      expected = deltamap;
    })
    (it "gets nodes" {
      /*
        .#...
        .....
        ..A..
        .....
        ...#.
      */
      actual = solution.deltaToNodes 5 {pos = {x=2;y=2;}; delta = {x=-1;y=-2;};};
      expected = [
        {x = 1; y = 0;}
        {x = 2; y = 2;}
        {x = 3; y = 4;}
      ];
    })
    (it "gets min node" {
      # .....
      # #....
      # .#...
      # ..A..
      # ...#.
      actual = solution.minNode 5 {x = 2; y = 3;} {x = -1; y = -1;};
      expected = {x = 0; y = 1;};
    })
    (it "gets result" {
      actual = solution.part2result exampleInput;
      expected = 34;
    })
  ])
]
