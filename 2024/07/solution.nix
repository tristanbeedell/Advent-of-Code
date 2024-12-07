{lib, ...}: input: rec {

  index = i: arr: lib.elemAt arr i;

  data = input
    |> lib.trim
    |> lib.splitString "\n"
    |> map (line: line
      |> lib.splitString ": "
      |> (parts: {
        target = index 0 parts |> lib.strings.toInt;
        vals = parts
          |> index 1
          |> lib.splitString " "
          |> map lib.strings.toInt;
      })
    )
  ;

/*


obvious answer:
try every combination of + and * between each number.
that is O(2^n)
I expect part 2 will introduce more operators, making this very slow.

slight optimisation idea:

all numbers in the input are positive integers.

if you multiply all numbers, and the result is less than the target,
it's not possible.

if the sum of all numbers is greater than the target, it's not possible.

but won't work where there are 1's in the list!

we could try going right to left and dividing and subtracting,
the complexity is the same though

*/

  total = builtins.foldl' builtins.add 0;
  multiply = builtins.foldl' builtins.mul 1;

  isPossible = {target, vals, running ? null}:
  let 
    nextVals = (lib.sublist 1 (builtins.length vals) vals);
  in
  if isNull running then isPossible {
    inherit target;
    running = (index 0 vals);
    vals = nextVals;
  } else  let
    val = index 0 vals;
    sum = running + val;
    multiple = running * val;
    isEnd = builtins.length vals == 0;
  in if isEnd then false else
  if sum == target || multiple == target then true else
    isPossible {
      inherit target;
      vals = nextVals;
      running = sum;
    } || isPossible {
      inherit target;
      vals = nextVals;
      running = multiple;
    }
  ;

  part1result = data
    # |> builtins.filter isInRange
    |> builtins.filter isPossible
    |> map (l: l.target)
    |> total
  ;

  /* Part 2

  i had a feeling part 2 would introduce new operations.
  this increases the complexity to O(3^n)

  Really wish I went right to left now!
  going right to left, we could check if the target ends in the running value

  concat will always increase the value of a number.
  concat will always increase the value more than multiplying.

  */

  concat = a: b: lib.strings.toInt (toString a + toString b);

  isPossible2 = {target, vals, running ? null}:
  let 
    try = v: isPossible2 {
      inherit target;
      vals = (lib.sublist 1 (builtins.length vals) vals);
      running = v;
    };
    val = index 0 vals;
  in
  if isNull running then try val else
  if builtins.length vals == 0 then target == running else
  if running > target then false else
  let
    sum = running + val;
    multiple = running * val;
    concatination = concat running val;
  in 
    try sum || try multiple || try concatination;

  part2result = data
    |> builtins.filter isPossible2
    |> map (l: l.target)
    |> total
  ;

  /*
  lets try right to left
  */

  isPossibleFast = ops: {target, vals, running ? target}:
  (let 
    try = v: isPossibleFast ops {
      inherit target;
      running = v;
      vals = (lib.sublist 0 (builtins.length vals - 1) vals);
    };
    val = index (builtins.length vals - 1) vals;
    isFinal = builtins.length vals == 1;
  in
    builtins.any ({op, fin, check}: (
    let vars = {inherit target running val isFinal; result = op vars;}; in (
      if isFinal then fin vars else check vars && try vars.result
    ))) ops
  );

  isWhole = a: a == builtins.floor a;
  toFloat = a: a * 1.0;
  floatDiv = a: b: (toFloat a) / (toFloat b);

  part1ops = [
    {
      op = {running, val, ...}: running - val;
      check = {result, ...}: result > 0;
      fin = {result, ...}: result == 0;
    }
    {
      op = {running, val, ...}: floatDiv running val;
      check = {result, ...}: isWhole result;
      fin = {result, ...}: result == 1;
    }
  ];

  part1resultFast = data
    |> builtins.filter (isPossibleFast part1ops)
    |> map (l: l.target)
    |> total
  ;

  endsWith = a: b: let 
    full = intToString b;
    end = intToString a;
    endLen = builtins.stringLength end;
    fullLen = builtins.stringLength full;
  in endLen < fullLen && builtins.substring (fullLen - endLen) endLen full == end;

  intToString = a: a |> builtins.floor |> toString;
  intLength = a: a |> intToString |> builtins.stringLength;

  truncate = a: amt: let
    full = intToString a;
    remLen = builtins.stringLength full - amt;
  in if remLen <= 0 then 0 else builtins.substring 0 remLen full
  |> lib.strings.toInt;

  part2ops = part1ops ++ [
    {
      op = {running, val, ...}: truncate running (intLength val);
      check = {running, val, ...}: endsWith val running;
      fin = {target, val, result, ...}: (toString result) + (toString val) == toString target;
    }
  ];

  part2resultFast = data
    |> builtins.filter (isPossibleFast part2ops)
    |> map (l: l.target)
    |> total
  ;

}
