{it, describe, ...}: let
  pkgs = import <nixpkgs> {};
  solution = import ./solution.nix pkgs;
in [
  (it "splits the stupid thing into quadrants" {
    actual = (solution "").getQuadrants {width = 7; height = 5;} [
      { pos.x = 2; pos.y = 1; }
      { pos.x = 4; pos.y = 1; }
      { pos.x = 2; pos.y = 3; }
      { pos.x = 4; pos.y = 3; }
      { pos.x = 0; pos.y = 2; }
      { pos.x = 1; pos.y = 2; }
      { pos.x = 2; pos.y = 2; }
      { pos.x = 3; pos.y = 2; }
      { pos.x = 4; pos.y = 2; }
      { pos.x = 3; pos.y = 0; }
      { pos.x = 3; pos.y = 1; }
      { pos.x = 3; pos.y = 2; }
      { pos.x = 3; pos.y = 3; }
      { pos.x = 3; pos.y = 4; }
    ];
    expected = {
      dl = [
        { pos.x = 2; pos.y = 3; }
      ];
      dr = [
        { pos.x = 4; pos.y = 3; }
      ];
      tr = [
        { pos.x = 4; pos.y = 1; }
      ];
      tl = [
        { pos.x = 2; pos.y = 1; }
      ];
    };
  })
]
