{lib, ...}: input: rec {

  content = lib.trim input;

  parts = let 
      sects = lib.splitString "\n\n" content;
    in {
      rules = builtins.elemAt sects 0
        |> lib.splitString "\n"
        |> map (lib.splitString "|")
        |> builtins.foldl' (acc: el:
          let
          b = builtins.elemAt el 0;
          a = builtins.elemAt el 1;
          in
        acc // {
          ${b} = acc.${b} or [] ++ [a];
        }) {};
      updates = builtins.elemAt sects 1
        |> lib.splitString "\n"
        |> map (lib.splitString ",");
    }
  ;

  check = {rules, update}: builtins.attrNames rules
    |> map
      (ruleName: let
          i = lib.lists.findFirstIndex (x: x == ruleName) null update;
          before = if isNull i then [] else lib.sublist (0) (i) update;
        in {
          inherit before;
          rules = rules.${ruleName};
        })
    |> builtins.foldl'
      (valid: {rules, before}: valid && builtins.all (e: !builtins.any (r: r == e) rules) before)
      true
  ;

  getValid = {rules, updates}:
    builtins.filter (update: check {inherit rules update;}) updates;
  
  getMiddles = list: list
    |> map (row: builtins.elemAt row ((builtins.length row) / 2))
    |> map lib.strings.toInt
  ;

  sum = builtins.foldl' (a: n: a + n) 0;

  part1result = parts
    |> getValid
    |> getMiddles
    |> sum
  ;

  sortUpdate = rules: update:
    builtins.sort (fst: snd: builtins.any (rule: rule == fst) (rules.${snd} or [])) update
  ;

  getInvalid = {rules, updates}:
    builtins.filter (update: !check {inherit rules update;}) updates;

  part2result = parts
    |> getInvalid
    |> map (sortUpdate parts.rules)
    |> getMiddles
    |> sum
  ;
  
}
