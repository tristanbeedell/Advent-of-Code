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
}
