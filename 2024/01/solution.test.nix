{describe, it, ...}:
let
  pkgs = import <nixpkgs> {};
  solution = import ./solution.nix pkgs;
  example = (solution {file = ./example.txt;});
in [
  (describe "part1" [
    (it "gets file content" {
      expected = ''
        3   4
        4   3
        2   5
        1   3
        3   9
        3   3'';
      actual = example.content;
    })
    (it "splits lines" {
      expected = [
        "3   4"
        "4   3"
        "2   5"
        "1   3"
        "3   9"
        "3   3"
      ];
      actual = example.lines;
    })
    (it "splits left and right" {
      expected = [
        3 4
      ];
      actual = example.getLeftAndRight "3   4";
    })
    (it "splits list into left and right" {
     expected = {
       left = [ 3 4 2 1 3 3 ];
       right = [ 4 3 5 3 9 3 ];
     };
     actual = example.splitLists [
        "3   4"
        "4   3"
        "2   5"
        "1   3"
        "3   9"
        "3   3"
      ];
    })
    (it "splits list into left and right" {
     expected = {
       left = [ 1 2 3 3 3 4 ];
       right = [ 3 3 3 4 5 9 ];
     };
     actual = example.sortLists {
       left = [ 3 4 2 1 3 3 ];
       right = [ 4 3 5 3 9 3 ];
     };
    })
    (it "calculates the distance between each item" {
     expected = [2 1 0 1 2 5];
     actual = example.distance {
       left = [ 3 4 2 1 3 3 ];
       right = [ 4 3 5 3 9 3 ];
     };
    })
    (it "calculates the total" {
     expected = 11;
     actual = example.total [2 1 0 1 2 5];
    })
    (it "gets diff of list of strings" {
     expected = 11;
     actual = example.getDiff [
        "3   4"
        "4   3"
        "2   5"
        "1   3"
        "3   9"
        "3   3"
      ];
    })
    (it "gets similarity" {
     expected = [9 4 0 0 9 9];
     actual = example.similarity {
       left = [ 3 4 2 1 3 3 ];
       right = [ 4 3 5 3 9 3 ];
     };
    })
    (it "gets similarity of list of strings" {
     expected = 31;
     actual = example.getSimilarity [
        "3   4"
        "4   3"
        "2   5"
        "1   3"
        "3   9"
        "3   3"
      ];
    })
  ])
]
