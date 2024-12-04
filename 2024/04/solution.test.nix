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
      actual = example.content;
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
  (describe "part 2" [
    (it "checks if string is X-MAS" {
      actual = map example.isX-MAS [
      ''
        M.S
        .A.
        M.S''
      ''
        S.S
        .A.
        M.M''
      ''
        M.M
        .A.
        S.S''
      ''
        S.M
        .A.
        S.M''
      ''
        S.M
        .A.
        M.M''
      ];
      expected = [true true true true false];
    })
    (it "breaks list into 3s" {
      actual = example.break3s [1 2 3 4 5];
      expected = [[1 2 3] [2 3 4] [3 4 5]];
    })
    (it "breaks list into 3x3s" {
      actual = example.break3x3s [
        ["1" "2" "3" "4"]
        ["5" "6" "7" "8"]
        ["9" "A" "B" "C"]
      ];
      expected = [
        ''
        123
        567
        9AB''
        ''
        234
        678
        ABC''
      ];
    })
    (it "breaks string into 3 lines" {
      actual = example.break3lines ''
        1234
        5678
        9ABC
        DEFG'';
      expected = [[
        ["1" "2" "3" "4"]
        ["5" "6" "7" "8"]
        ["9" "A" "B" "C"]
      ]
      [
        ["5" "6" "7" "8"]
        ["9" "A" "B" "C"]
        ["D" "E" "F" "G"]
      ]];
    })
    (it "breaks string into 3x3 blocks" {
      actual = example.break3x3 ''
        1234
        5678
        9ABC
        DEFG'';
      expected = [
        "123\n567\n9AB" "234\n678\nABC"
        "567\n9AB\nDEF" "678\nABC\nEFG"
      ];
    })
    (it "gets the result" {
      actual = example.part2result;
      expected = 9;
    })
  ])
]
