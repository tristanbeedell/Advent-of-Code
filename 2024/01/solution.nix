{lib, ...}: input: rec {
  content = lib.strings.removeSuffix "\n" input;
  lines = lib.strings.splitString "\n" content;
  getLeftAndRight = s: s
    |> lib.strings.splitString "   "
    |> map lib.strings.toInt
  ;
  splitLists = s: s
    |> map getLeftAndRight
    |> builtins.foldl'
      (prev: next: {
        left = prev.left ++ [(builtins.elemAt next 0)];
        right = prev.right ++ [ ( builtins.elemAt next 1 ) ];})
      {left = []; right = [];}
  ;
  sortLists = l: {
    left = lib.lists.sort (a: b: a < b) l.left;
    right = lib.lists.sort (a: b: a < b) l.right;
  };
  distance = l: l
    |> sortLists
    |> ({left, right}: lib.zipListsWith (ln: rn: abs (ln - rn)) left right)
  ;
  total = l: builtins.foldl' (x: y: x+y) 0 l;
  abs = n: if n > 0 then n else -n;
  getDiff = s: s
    |> splitLists
    |> distance
    |> total
  ;
  similarity = l: l
    |> ({left, right}: map (ln: ln * lib.count (rn: ln == rn) right) left)
  ;
  getSimilarity = s: s
    |> splitLists
    |> similarity
    |> total
  ;
  part1result = getDiff lines;
  part2result = getSimilarity lines;
}
