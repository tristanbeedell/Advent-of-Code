{lib, ...}: input: rec {
  inherit lib;
  inherit (lib) splitString mod;
  inherit (lib.lists) findFirstIndex imap0;
  inherit (lib.strings) stringToCharacters;
  inherit (builtins) elemAt concatStringsSep length elem filter foldl' concatLists;

  index = i: list: elemAt list i;
  index2d = {x, y}: m: m |> index y |> index x;

  init = let
    parts = splitString "\n\n" input;
    chart = elemAt parts 0 |> splitString "\n" |> map stringToCharacters;
    # ins = elemAt parts 1 |> stringToCharacters |> filter (char: elem char (stringToCharacters "^><v"));
    ins = elemAt parts 1 |> splitString "\n" |> map stringToCharacters;
    width = (elemAt chart 0 |> length) + 1;
    startIndex = elemAt parts 0 |> stringToCharacters |> findFirstIndex (char: char == "@") null;
  in {
    inherit chart ins;
    pos = {
      x = mod startIndex width;
      y = startIndex / width;
    };
  }
  ;

  addVec = a: b: {x = a.x + b.x; y = a.y + b.y;};

  objects = {
    wall = "#";
    moveable = "O";
    empty = ".";
  };

  replace2d = {x, y}: updated: chart: let
    newRow = chart |> index y |> replace x updated;
  in
    replace y newRow chart;

  replace = i: updated: list: 
  let before = lib.sublist 0 i list;
    after = lib.sublist (i + 1) (builtins.length list - i) list;
  in
    if i < 0 || i > builtins.length list then list else
    before ++ [updated] ++ after;

  strToDir = strDir: {
    x = if strDir == "<" then -1 else if strDir == ">" then 1 else 0;
    y = if strDir == "^" then -1 else if strDir == "v" then 1 else 0;
  };
  
  move = {chart, pos, ...}: dir: let
    nextPos = addVec pos dir;
    atPos = chart |> index2d pos;
    moved = move {inherit chart; pos = nextPos;} dir;
  in if atPos == objects.wall
  then {
    inherit chart pos;
    moved = false;
  } else if atPos == objects.empty
  then {
    inherit chart pos;
    moved = true;
  } else if !moved.moved
  then {inherit chart pos; moved = false;}
  else {
    moved = true;
    pos = nextPos;
    chart = moved.chart |> replace2d pos objects.empty |> replace2d nextPos atPos;
  };

  chartToStr = chart: chart |> (map (concatStringsSep "")) |> concatStringsSep "\n";

  applyIns = foldl' (c: ins: let
    dir = strToDir ins;
  in move c dir);

  applyInsList = foldl' (chart: ins:
    # evaluate each line of instructions one at a time, to avoid stack overflow.
    let res = applyIns chart ins; in builtins.deepSeq res
    (res)
  );

  result = applyInsList init init.ins;

  getScore = chart: chart
    |> imap0 (y: row: row
      |> imap0 (x: obj:
        if obj == objects.moveable then x + y * 100 else 0
      )
    )
    |> concatLists
    |> foldl' builtins.add 0
  ;

  part1result = getScore result.chart;
}
