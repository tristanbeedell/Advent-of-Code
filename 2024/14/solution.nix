{lib, ...}: input: let
  inherit (lib.strings) trim splitString toIntBase10;
  inherit (builtins) match elemAt filter length;
  # real
  width = 101;
  height = 103;

  # example
  # width = 11;
  # height = 7;

  getQuadrants = {width, height}: robots: let
    mid.x = width / 2;
    mid.y = height / 2;
    tl = robots |> filter ({pos, ...}: pos.x < mid.x && pos.y < mid.y);
    tr = robots |> filter ({pos, ...}: pos.x > mid.x && pos.y < mid.y);
    dl = robots |> filter ({pos, ...}: pos.x < mid.x && pos.y > mid.y);
    dr = robots |> filter ({pos, ...}: pos.x > mid.x && pos.y > mid.y);
  in {inherit tl tr dl dr;}
  ;

  robots = input
    |> trim
    |> splitString "\n"
    |> map (line: line
      |> match ''p=([0-9]+),([0-9]+) v=(-?[0-9]+),(-?[0-9]+)''
      |> (nums: {
        pos = {
          x = elemAt nums 0 |> toIntBase10;
          y = elemAt nums 1 |> toIntBase10;
        };
        vel = {
          x = elemAt nums 2 |> toIntBase10;
          y = elemAt nums 3 |> toIntBase10;
        };
      })
    )
  ;

  pass = time: {pos, vel}: let
    x = lib.mod (pos.x + (vel.x * time)) width;
    y = lib.mod (pos.y + (vel.y * time)) height;
  in {
    pos = {
      x = if x < 0 then width + x else x;
      y = if y < 0 then height + y else y;
    };
    # inherit vel;
  };

in {

  inherit width height pass getQuadrants robots;

  part1result = robots 
    |> map (pass 100)
    |> getQuadrants {inherit width height;}
    |> ({tl, tr, dr, dl}: (length tl) * (length tr) * (length dr) * (length dl))
  ;

}
