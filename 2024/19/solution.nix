{input ? "", lib, ...}: let
  inherit (builtins) elemAt filter length;

  exampleIn = lib.readFile ./example.txt;
  
  mkSolution = {text}: let
    parts = text |> lib.trim |> lib.splitString "\n\n";
    towels = elemAt parts 0 |> lib.splitString ", ";
    regex = ''(${builtins.concatStringsSep "|" towels})+'';
    desired = elemAt parts 1 |> lib.splitString "\n";
    matches = desired |> map (lib.match regex);
  in {
    inherit towels regex desired matches;
    count = matches
      |> filter (m: !isNull m)
      |> length;
  };

in {
  example = mkSolution {
    text = exampleIn;
  };
  real = mkSolution {
    text = input;
  };
}
