{describe, it, ...}:
let
  pkgs = import <nixpkgs> {};
  lib = pkgs.lib;
  solution = import ./solution.nix pkgs;
  sample1 = "2333133121414131402";
/*
0099811188827773336446555566
*/
  sample1defraged = [
    { id = 0; size = 2; start = 0; }
    { id = 9; size = 2; start = 2; }
    { id = 8; size = 1; start = 4; }
    { id = 1; size = 3; start = 5; }
    { id = 8; size = 3; start = 8; }
    { id = 2; size = 1; start = 11; }
    { id = 7; size = 3; start = 12; }
    { id = 3; size = 3; start = 15; }
    { id = 6; size = 1; start = 18; }
    { id = 4; size = 2; start = 19; }
    { id = 6; size = 1; start = 21; }
    { id = 5; size = 4; start = 22; }
    { id = 6; size = 1; start = 26; }
    { id = 6; size = 1; start = 27; }
  ];
  sample2 = "12345";
  sample2disk = [
        {id = 0;    size = 1; start = 0;}
        {id = null; size = 2; start = 1;}
        {id = 1;    size = 3; start = 3;}
        {id = null; size = 4; start = 6;}
        {id = 2;    size = 5; start = 10;}
  ];

in [
  (describe "part 1" [

    (it "gets list of disk chunks" {
      actual = (solution sample2).disk;
      expected = sample2disk;
    })

    (it "gets list of disk chunks with bigger sample" {
      actual = (solution sample1).disk;
      expected = [
          { id = 0; size = 2; start = 0; }
          { id = null; size = 3; start = 2; }
          { id = 1; size = 3; start = 5; }
          { id = null; size = 3; start = 8; }
          { id = 2; size = 1; start = 11; }
          { id = null; size = 3; start = 12; }
          { id = 3; size = 3; start = 15; }
          { id = null; size = 1; start = 18; }
          { id = 4; size = 2; start = 19; }
          { id = null; size = 1; start = 21; }
          { id = 5; size = 4; start = 22; }
          { id = null; size = 1; start = 26; }
          { id = 6; size = 4; start = 27; }
          { id = null; size = 1; start = 31; }
          { id = 7; size = 3; start = 32; }
          { id = null; size = 1; start = 35; }
          { id = 8; size = 4; start = 36; }
          { id = null; size = 0; start = 40; }
          { id = 9; size = 2; start = 40; }
      ];
    })

    (it "defrags files" {
      actual = (solution sample1).defragged.files
        |> builtins.filter ({size,...}: size > 0)
        |> lib.sort (a: b: a.start < b.start);
      expected = sample1defraged;
    })

    # (it "defrags a file" {
    #   actual = (solution sample1).defrag
    #     [
    #       {id = null; size = 1; start = 10;}
    #       {id = null; size = 5; start = 15;}
    #       {id = null; size = 10; start = 50;}
    #       {id = 1; size = 100; start = 100;}
    #     ]
    #     {id = 1; size = 100; start = 100;};
    #   expected = {
    #     file = [
    #       { id = 1; size = 1; start = 10; }
    #       { id = 1; size = 5; start = 15; }
    #       { id = 1; size = 10; start = 50;}
    #       { id = 1; size = 100 - 10 - 5 - 1; start = 100;}
    #     ];
    #     free = [
    #       {id = null; start = 100 + 100 - 10 - 5 - 1; size = 1 + 5 + 10;}
    #     ];
    #   };
    # })
    #
    # (it "doesn't defrag a file to the left of free space" {
    #   actual = (solution sample1).defrag
    #     [
    #       {id = 1; size = 100; start = 0;}
    #       {id = null; size = 1; start = 101;}
    #     ]
    #     {id = 1; size = 100; start = 0;};
    #   expected = {
    #     file = [
    #       { id = 1; size = 100; start = 0;}
    #     ];
    #     free = [
    #       { id = null; size = 1; start = 101;}
    #     ];
    #   };
    # })
    #
    (it "gets checksum" {
      actual = (solution sample1).checksum {files = sample1defraged;};
      expected = 1928;
    })

    (it "gets the correct result" {
      actual = (solution sample1).part1result;
      expected = 1928;
    })

    (it "makes the disk" {
      actual = (solution sample1).fullDisk;
      expected = 5;
    })

  ])
]
