{describe, it, ...}:
let
  pkgs = import <nixpkgs> {};
  solution = import ./solution.nix pkgs;
  content = ''
    MMMSXXMASM
    MSAMXMSMSA
    AMXSXMAAMM
    MSAMASMSMX
    XMASAMXAMM
    XXAMMXXAMA
    SMSMSASXSS
    SAXAMASAAA
    MAMMMXMMMM
    MXMXAXMASX'';
  rotated = ''
    MMAMXXSSMM
    MSMSMXMAAX
    MAXAAASXMM
    SMSMSMMAMX
    XXXAAMSMMA
    XMMSMXAAXX
    MSAMXXSSMM
    AMASAAXAMA
    SSMMMMSAMS
    MAMXMASAMX'';
  diagonal = ''
    M
    MM
    MSA
    SAMM
    XMXSX
    XXSAMX
    MMXMAXS
    ASMASAMS
    SMASAMSAM
    MSAMMMMXAM
    AMSXXSAMX
    MMAXAMMM
    XMASAMX
    MMXSXA
    ASAMX
    SAMM
    AMA
    MS
    X
  '';
  example = solution content;
in [
  (describe "part 1" [
    (it "gets content forward" {
      actual = example.forward;
      expected = content;
    })
    (it "gets content rotated" {
      actual = example.rotated content;
      expected = rotated;
    })
    (it "gets content diagonal" {
      actual = example.diagonal content;
      expected = diagonal;
    })
    (it "reverses string" {
      actual = example.reverseString "XMAS";
      expected = "SAMX";
    })
    (it "searches for term" {
      actual = example.search "XMAS" content;
      expected = 3;
    })
    (it "searches for term in reverse" {
      actual = example.searchForwardAndBack "XMAS" content;
      expected = 5;
    })
    (it "gets the result" {
      actual = example.part1result;
      expected = 18;
    })
  ])
]
