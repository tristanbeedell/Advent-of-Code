{lib, input ? "", my-lib, ...}@pkgs: rec {
  inherit pkgs;
  inherit lib;
  inherit my-lib;
  inherit (builtins) elemAt genList elem concatStringsSep length;
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

  inherit (my-lib.dijkstra {}) key;

  mkSolution = {size, bytes, input}: rec {
    inherit size bytes input;
    walls = init input;
    part1result = p1Dijkstra.toGoal.steps;
    p1Dijkstra = searchAfterBytes 12;

    searchAfterBytes = bytes: let
      walls = lib.sublist 0 bytes (init input);
      chart = genChart size walls;
    in my-lib.dijkstra {
      pos = {x = 0; y = 0;};
      goal = {x = size - 1; y = size - 1;};
      chart = chart;
      width = size;
      height = size;
    };

    findFirst = bytes: prevPath: let
      dijkstra = lib.traceSeq "retracing after ${toString bytes} with ${key wall}" (searchAfterBytes bytes);
      wall = elemAt walls (bytes - 1);
      wallCollides = elem (key wall) (map ({pos,...}: pos) prevPath);
    in if !wallCollides
    then findFirst (bytes + 1) prevPath
    else
      if dijkstra.isImpossible
    then key wall
    else
      findFirst (bytes + 1) dijkstra.path;

    part2result = findFirst bytes p1Dijkstra.path;

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
