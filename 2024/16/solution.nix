{lib, ...}: input: rec {
  inherit lib;
  inherit (lib) splitString mod;
  inherit (lib.lists) findFirstIndex imap0;
  inherit (lib.strings) stringToCharacters;
  inherit (builtins) elemAt concatStringsSep length elem filter foldl' concatLists floor deepSeq;

  index = i: list: elemAt list i;
  index2d = {x, y}: m: m |> index y |> index x;

  init = let
    chart = input |> splitString "\n" |> map stringToCharacters;
    width = (elemAt chart 0 |> length) + 1;
    height = length chart;
    startIndex = input |> stringToCharacters |> findFirstIndex (char: char == "S") null;
    endIndex = input |> stringToCharacters |> findFirstIndex (char: char == "E") null;
  in {
    inherit chart width height;
    pos = {
      x = mod startIndex width;
      y = startIndex / width;
    };
    goal = {
      x = mod endIndex width;
      y = endIndex / width;
    };
  }
  ;

  chartToStr = chart: chart |> (map (concatStringsSep "")) |> concatStringsSep "\n";

  rotate' = {x, y}: {y = -x; x = y;};
  rotate = {x, y}: {y = x; x = -y;};

  addVec = a: b: {x = a.x or 0 + b.x or 0; y = a.y or 0 + b.y or 0;};
  multVec = a: m: {x = a.x or 0 * m; y = a.y or 0 * m;};

  minl = foldl' (a: e: if isNull a then e else if isNull e then a else if a < e then a else e) null;

  search = {pos ? init.pos, dir ? {x = 1; y = 0;}, hist ? [], max ? null}:
  let
    fwd = search {pos = addVec pos dir; inherit dir; hist = hist ++ [{inherit pos dir;}];} |> add 1;
    rot = search {inherit pos; dir = rotate dir; hist = hist ++ [{inherit pos dir;}]; max = fwd;} |> add 1000;
    rot' = search {inherit pos; dir = rotate' dir; hist = hist ++ [{inherit pos dir;}]; max = fwd;} |> add 1000;
    add = n: a: if isNull a then null else n + a;
  in
  if pos == init.goal then 0 else
  if
    elem {inherit pos dir;} hist ||
    elem {inherit pos; dir = multVec dir (-1);} hist ||
    index2d pos init.chart == "#" then null else
  minl [fwd rot rot']
  ;


}
