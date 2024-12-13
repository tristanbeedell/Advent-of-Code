{it, describe}: let
  pkgs = import <nixpkgs> {};
  solution = import ./solution.nix pkgs;
  exampleIn = builtins.readFile ./example.txt;
in [
  (describe "part 1" [

    (it "parses buttons" {
      actual = (solution "").buttonToVec "Button A: X+94, Y+34";
      expected = {
        x = 94;
        y = 34;
      };
    })

    (it "parses prize" {
      actual = (solution "").prizeToVec "Prize: X=8400, Y=5400";
      expected = {
        x = 8400;
        y = 5400;
      };
    })

    (it "gets the machines" {
      actual = (solution ''
        Button A: X+94, Y+34
        Button B: X+22, Y+67
        Prize: X=8400, Y=5400
      '').machines;
      expected = [{
        a = {x = 94; y = 34;};
        b = {x = 22; y = 67;};
        prize = {x = 8400; y = 5400;};
      }];
    })

    (it "gets the answer for a machine" {
      actual = (solution "").getPresses {
        a = {x = 94; y = 34;};
        b = {x = 22; y = 67;};
        prize = {x = 8400; y = 5400;};
      };
      expected = {a = 80; b = 40;};
    })

    (it "gets the cost" {
      actual = (solution exampleIn).part1result;
      expected = 480;
    })

  ])
]
