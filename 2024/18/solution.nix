{lib, input ? "", my-lib, ...}@pkgs: rec {
  inherit pkgs;
  inherit lib;
  inherit (builtins) elemAt genList elem concatStringsSep;
  inherit (lib) splitString;
  inherit (lib.strings) toIntBase10;

  init = input: input |> lib.trim
    |> splitString "\n"
    |> map (line: let c = splitString "," line; in {
      x = elemAt c 0 |> toIntBase10;
      y = elemAt c 1 |> toIntBase10;
    })
  ;

  genChart = size: coords: genList (y: genList (x:
    if x == 0 && y == 0 then "S" else
    if x == size - 1 && y == size - 1 then "E" else
    if elem {inherit x y;} coords then "#" else "."
  ) size) size;

  chartToStr = chart: chart |> (map (concatStringsSep "")) |> concatStringsSep "\n";

  mkSolution = {size, bytes, input}: rec {
    inherit size bytes input;
    walls = lib.sublist 0 bytes (init input);
    chart = genChart size walls;
    part1result = dijkstra.toGoal.steps;
    dijkstra = my-lib.dijkstra {
      pos = {x = 0; y = 0;};
      goal = {x = size - 1; y = size - 1;};
      chart = chart;
      width = size;
      height = size;
    };
  };

  example = mkSolution {
    size = 7;
    bytes = 12;
    input = lib.readFile ./example.txt;
  };

  real = mkSolution {
    size = 71;
    bytes = 1024;
    input = input;
  };

  # not 272, too high

}
