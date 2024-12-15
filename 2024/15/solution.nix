{lib, ...}: input: rec {
  inherit lib;
  inherit (lib) splitString mod;
  inherit (lib.lists) findFirstIndex imap0;
  inherit (lib.strings) stringToCharacters;
  inherit (builtins) elemAt concatStringsSep length elem filter foldl' concatLists floor;

  index = i: list: elemAt list i;
  index2d = {x, y}: m: m |> index y |> index x;

  init = let
    parts = splitString "\n\n" input;
    chart = elemAt parts 0 |> splitString "\n" |> map stringToCharacters;
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

  addVec = a: b: {x = a.x or 0 + b.x or 0; y = a.y or 0 + b.y or 0;};

  objects = {
    wall = "#";
    moveable = "O";
    leftedge = "[";
    rightedge = "]";
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

  init2 = {
    chart = init.chart
      |> map (map (c: if c == objects.moveable then ["[" "]"]
      else if c == "@" then ["@" "."] else [c c]))
      |> map concatLists
    ;
    pos = {
      inherit (init.pos) y;
      x = init.pos.x * 2;
    };
  };

  move2 = dir: {chart, pos, ...}:
  let
    nextPos = addVec pos dir;
    char = chart |> index2d pos;
    switch = state: state // {chart = state.chart |> replace2d pos objects.empty |> replace2d nextPos char;};
    moved = move2 dir {inherit chart; pos = nextPos;} |> switch;
    moved2 = if dir.y == 0 || !moved.moved then moved else if char == objects.leftedge then
        move2 dir {inherit (moved) chart; pos = addVec pos {x = 1;};}
      else if char == objects.rightedge then
        move2 dir {inherit (moved) chart; pos = addVec pos {x = -1;};}
      else
        moved;
  in if char == objects.wall
  then {
    inherit chart pos;
    moved = false;
  } else if char == objects.empty
  then {
    inherit chart pos;
    moved = true;
  } else if !moved2.moved
  then {inherit chart pos; moved = false;}
  else {
    moved = true;
    pos = nextPos;
    inherit (moved2) chart;
  }
  ;

  applyIns2 = foldl' (c: ins: let
    dir = strToDir ins;
  in move2 dir c);

  applyInsList2 = foldl' (chart: ins:
    # evaluate each line of instructions one at a time, to avoid stack overflow.
    let res = applyIns2 chart ins; in builtins.deepSeq res
    res
  );

  result2 = applyInsList2 init2 init.ins;

  getScore2 = chart: chart
    |> imap0 (y: row: row
      |> imap0 (x: obj:
        if obj == objects.leftedge then x + y * 100 else 0
      )
    )
    |> concatLists
    |> foldl' builtins.add 0
  ;

  part2result = getScore2 result2.chart;

}
