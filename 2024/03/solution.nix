{lib, ...}: {file}: rec {
  content = builtins.readFile file;

  muls = memory: memory
    |> builtins.split ''mul\(([0-9]{0,3}),([0-9]{0,3})\)''
    |> builtins.filter builtins.isList
  ;

  mul = builtins.foldl'
    (acc: n: let
      nums = map lib.strings.toInt n;
    in acc + ( builtins.elemAt nums 0 ) * ( builtins.elemAt nums 1 ))
    0
  ;

  part1result = content |> muls |> mul;

  conditionsAndMuls = memory: let
    mulMatcher = ''mul\(([0-9]{0,3}),([0-9]{0,3})\)'';
    conditionMatcher = ''(do|don't)\(\)'';
  in memory
    |> builtins.split "${mulMatcher}|${conditionMatcher}"
    |> builtins.filter builtins.isList
    |> map toInstruction
  ;

  toInstruction = matches: let
    elem = builtins.elemAt matches;
    numOrZero = v: if isNull v
      then 0
      else lib.strings.toInt v;
  in {
    cmd = let todo = elem 2; in
      if isNull todo then "mul" else todo;
    a = numOrZero (elem 0);
    b = numOrZero (elem 1);
  };

  conditionalMul = builtins.foldl'
    ({mul, acc}: n: {
      acc = acc + mul * n.a * n.b;
      mul = if n.cmd == "do" then 1
        else if n.cmd == "don't" then 0
        else mul;
    })
    {
      mul = 1;
      acc = 0;
    }
  ;

  part2result = content
    |> conditionsAndMuls
    |> conditionalMul
    |> (r: r.acc)
  ;

}
