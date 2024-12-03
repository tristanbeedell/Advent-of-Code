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

}
