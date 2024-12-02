{describe, it, ...}:
let
  pkgs = import <nixpkgs> {};
  solution = import ./solution.nix pkgs;
  example = (solution {file = ./example.txt;});
in [
  (describe "part1" [
    (it "gets file content" {
      expected = ''
        7 6 4 2 1
        1 2 7 8 9
        9 7 6 2 1
        1 3 2 4 5
        8 6 4 4 1
        1 3 6 7 9'';
      actual = example.content;
    })
    (it "splits lines" {
      expected = [
        "7 6 4 2 1"
        "1 2 7 8 9"
      ];
      actual = example.toLines ''
        7 6 4 2 1
        1 2 7 8 9'';
    })
    (it "turns to numbers" {
      expected = [
        [1 2 3 4]
        [5 6 7 8]
      ];
      actual = example.toLevels ["1 2 3 4" "5 6 7 8"];
    })
    (it "gets safety" {
      expected = [
        true
        false
        false
        false
        false
        true
      ];
      actual = [
        [7 6 4 2 1]
        [1 2 7 8 9]
        [9 7 6 2 1]
        [1 3 2 4 5]
        [8 6 4 4 1]
        [1 3 6 7 9]
      ] |> map example.isSafe
        |> map (v: v.safe);
    })
    (it "counts total safety" {
      expected = 3;
      actual = example.countSafety [
        {safe = true;}
        {safe = false;}
        {safe = true;}
        {safe = false;}
        {safe = false;}
        {safe = true;}
      ];
    })
    (it "gets the right result" {
      expected = 2;
      actual = example.getPart1Result ''
        7 6 4 2 1
        1 2 7 8 9
        9 7 6 2 1
        1 3 2 4 5
        8 6 4 4 1
        1 3 6 7 9'';
    })
  ])
]
