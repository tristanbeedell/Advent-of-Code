{lib, ...}: input: rec {

  content = lib.trim input;

  emptyLines = lines: lines
    |> builtins.length
    |> genStrList ""
  ;

  genStrList = str: builtins.genList (_: str);

  rotated = input: input
    |> lib.strings.splitString "\n"
    |> map (lib.stringToCharacters)
    |> (lines: builtins.foldl'
      (lib.zipListsWith (a: b: a + b))
      (emptyLines lines)
      lines)
    |> lib.concatStringsSep "\n"
  ;

  len = builtins.length (lib.strings.splitString "\n" content);

  diagonal = input: input
    |> lib.strings.splitString "\n"
    |> map (lib.stringToCharacters)
    |> (lines: builtins.foldl'
      ({acc, i}: line: {
        acc = lib.zipListsWith (a: b: a + b) acc
          ((genStrList " " i) ++ line ++ (genStrList " " (len - i)));
        i = i + 1;
      })
      {
        acc = (emptyLines lines) ++ emptyLines (builtins.elemAt lines 0);
        i = 0;
      }
      lines)
    |> ({acc, ...}: acc)
    |> map lib.trim
    |> lib.concatStringsSep "\n"
  ;

  reversed = input: input
    |> lib.strings.splitString "\n"
    |> map reverseString
    |> lib.concatStringsSep "\n"
  ;

  reverseString = s: s
    |> lib.stringToCharacters
    |> lib.reverseList
    |> lib.concatStringsSep ""
  ;

  search = term: input: input
    |> builtins.split term
    |> builtins.filter lib.isList
    |> builtins.length
  ;

  searchForwardAndBack = term: input:
    search term input +
    search (reverseString term) input;

  findXMAS = searchForwardAndBack "XMAS";
  
  part1result = findXMAS content
    + findXMAS (diagonal content)
    + findXMAS (rotated content)
    + findXMAS (diagonal (reversed content))
  ;

  xmasMatcher = let
    xmas = ''
      M.S
      .A.
      M.S'';
  in 
    "${xmas}|${rotated xmas}|${reversed xmas}|${rotated (reversed xmas)}";

  isX-MAS = s: s
    |> builtins.match xmasMatcher
    |> lib.isList
  ;

  break3s = s: let
    len = builtins.length s - 2;
  in
    builtins.genList (i: lib.sublist i 3 s) len
  ;

  break3lines = s: s
    |> lib.splitString "\n"
    |> map lib.stringToCharacters
    |> break3s
  ;

  break3x3s = l: l
    |> map break3s
    |> (groups:
      let empty = builtins.elemAt groups 0 
        |> builtins.length
        |> genStrList [];
      in builtins.foldl'
      (lib.zipListsWith (a: b: a ++ ["\n"] ++ b))
      empty groups)
    |> map lib.concatStrings
    |> map lib.trim
  ;

  break3x3 = s: s
    |> break3lines
    |> map break3x3s
    |> builtins.concatLists
  ;

  part2result = content
    |> break3x3
    |> lib.count isX-MAS
  ;

}
