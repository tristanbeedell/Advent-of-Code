{lib, ...}: input: let
  inherit (lib.strings) trim splitString toIntBase10;
  inherit (builtins) match elemAt filter length genList concatStringsSep;
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
  };

  printMap = robots: genList (y:
    genList (x:
      robots
        |> filter ({pos,...}: pos == {inherit x y;})
        |> length
        |> (amt: if amt == 0 then "." else toString amt)
    ) width
    |> concatStringsSep ""
  ) height
  |> concatStringsSep "\n";

  anim = {start, period}: 100 |> genList (i: let
    seconds = (i * period) + start;
  in robots |> map (pass (seconds)) |>
  (room: ''
    seconds: ${toString seconds}
    ${printMap room}
  '')
  ) |> concatStringsSep "\n";

in {

  inherit width height pass getQuadrants robots printMap;

  part1result = robots 
    |> map (pass 100)
    |> getQuadrants {inherit width height;}
    |> ({tl, tr, dr, dl}: (length tl) * (length tr) * (length dr) * (length dl))
  ;

  part2result = # figured these settings out after observing the first 500 seconds:
    anim {start = 14; period = 101;}
  |> builtins.toFile "robots-anim";

}
