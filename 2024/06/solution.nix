{lib, ...}: input: rec {

  content = lib.trim input;

  chart = content
    |> lib.strings.splitString "\n"
    |> map (lib.strings.splitString "")
    |> map (line: lib.sublist 1 (builtins.length line - 2) line)
  ;

  startingPos = let
    xs = map (lib.lists.findFirstIndex (char: char == "^") null) chart;
    y = lib.lists.findFirstIndex (x: !isNull x) null xs;
    x = builtins.elemAt xs y;
  in
    {inherit x y;}
  ;

  posToString = {x, y}: "${toString x},${toString y}";

  addVec = a: b: {x = a.x + b.x; y = a.y + b.y;};

  index = i: list: builtins.elemAt list i;

  getChar = {x, y}: chart
    |> index y
    |> index x
  ;

  height = builtins.length chart;
  width = chart |> index 0 |> builtins.length;

  progress = {visited ? {}, pos, dir, ...}: let
    nextChar = getChar (addVec pos dir);
    newDir = if nextChar == "#"  then rotate dir else dir;
    newPos = addVec pos newDir;
    fwd = addVec pos dir;
  in
  {
    visited = visited // {${posToString pos} = true;};
    exited = fwd.y >= height || fwd.x >= width || fwd.y < 0 || fwd.x < 0;
    pos = newPos;
    dir = newDir;
  };

  rotate = {x, y}: {x = -y; y = x;};

  startingDir = {x = 0; y = -1;};

  getVisits = {pos ? startingPos, dir ? startingDir, visited ? {}, ...}:
    let
      nextStep = progress {inherit pos dir visited;};
    in if nextStep.exited then visited else getVisits nextStep;

  part1result = getVisits {}
    |> builtins.attrNames
    |> builtins.length
    # the last position
    |> (v: v + 1)
  ;

}
