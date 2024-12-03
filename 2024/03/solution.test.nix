{describe, it, ...}:
let
  pkgs = import <nixpkgs> {};
  solution = import ./solution.nix pkgs;
  example = (solution {file = ./example.txt;});
  td = ''
    xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
  '';
  tm = [
        ["2"  "4"]
        ["5"  "5"]
        ["11" "8"]
        ["8"  "5"]
      ];
  td2 = ''
    xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
  '';
  ti2 = [
    { a = 2; b = 4; cmd = "mul"; }
    { a = 0; b = 0; cmd = "don't"; }
    { a = 5; b = 5; cmd = "mul"; }
    { a = 11; b = 8; cmd = "mul"; }
    { a = 0; b = 0; cmd = "do"; }
    { a = 8; b = 5; cmd = "mul"; }
  ];
in [
  (describe "part 1" [
    (it "gets content" {
      actual = example.content;
      expected = td;
    })
    (it "finds muls" {
      actual = example.muls td;
      expected = tm;
    })
    (it "multiplies" {
      actual = example.mul tm;
      expected = 161;
    })
    (it "gets result" {
      actual = example.part1result;
      expected = 161;
    })
  ])
  (describe "part 2" [
    (it "gets all instructions" {
      actual = example.conditionsAndMuls td2;
      expected = ti2;
    })
    (it "conditional multiplies" {
      actual = (example.conditionalMul ti2).acc;
      expected = 48;
    })
  ])
]
