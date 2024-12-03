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
]
