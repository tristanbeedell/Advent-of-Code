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
    p1Dijkstra = searchAfterBytes bytes;

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

    findFirst =  {
      index ? bytes,
      max ? length walls - 1
    }: let
      calcAt = i: rec {
        index = i;
        wall = elemAt walls (i - 1);
        dijkstra = lib.traceSeq "retracing after ${toString index} with ${key wall}" (searchAfterBytes i);
        possible = !dijkstra.isImpossible;
      };

      thisByte = calcAt index;
      maxByte = calcAt max;
      midByte = calcAt (index + (max - index) / 2);

      isEnd = index == maxByte.index;

      rightHalf = lib.traceSeq
        "going right to ${toString (midByte.index + 1)}-${toString max}"
        (findFirst {index = midByte.index + 1; inherit max;});

      leftHalf = lib.traceSeq
        "going left to ${toString index}-${toString (midByte.index - 1)}"
        (findFirst {index = index + 1; max = midByte.index;});
    in 
    if isEnd then key thisByte.wall else
    if !thisByte.possible then "oof" else
    if midByte.possible then
      rightHalf
    else 
      leftHalf
    ;

    part2result = findFirst {};

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
