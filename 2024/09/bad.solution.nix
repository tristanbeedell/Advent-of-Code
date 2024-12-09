{lib, ...}: input: let
  inherit (builtins) length foldl' filter tail head genList elemAt;
  inherit (lib) stringToCharacters toInt mod last reverseList min;

  data = input
    |> lib.trim
    |> stringToCharacters
    |> map toInt;

  disk = data
    |> foldl' (acc: size: 
      let
        index = length acc;
        id = index / 2;
        prev = last acc;
      in
        acc ++ [{
          inherit size;
          id = if index == 0 || mod index 2 == 0 then id else null;
          start = if length acc == 0 then 0 else prev.start + prev.size;
        }]
      ) []
  ;

  # works, but max-call-depth exceeded on real input... ugh
  defragRec = {free, files}: if free == [] then files else
  let
    file = last files;
    space = head free;
    size = min (space.size) (file.size);
  in
    if file.start + file.size < space.start then files else
    defragRec {
      files = (if size == 0 then [] else [{
            inherit (file) id;
            inherit (space) start;
            inherit size;
          }])
        ++ (lib.sublist 0 (length files - 1) files)
        ++ (if file.size == size then [] else [{
            inherit (file) id start;
            size = file.size - size;
          }]);
      free = (if size == 0 then [] else [{
          start = space.start + size;
          size = space.size - size;
        }])
        ++ tail free;
    }
  ;

  defrag = free: file:
  free |> foldl' (acc: space: let
    amt = min acc.rem space.size;
  in if (isNull space.id || space.id == file.id) -> acc.rem == 0
  then acc // {free = acc.free ++ [space];}
  else {
    file = acc.file ++ [{
      inherit (file) id;
      inherit (space) start;
      size = amt;
    }];
    free = acc.free ++ (if space.size - amt == 0 then [] else [{
      id = space.id;
      start = space.start + amt;
      size = space.size - amt;
    }]);
    rem = acc.rem - amt;
  })
  {free = []; file = []; rem = file.size;}
  |> (result: { inherit (result) free file; })
  ;

  defragged = let
    files = disk
      |> filter ({id, ...}: !isNull id)
      |> reverseList
    ;
  in files |> foldl' (acc: file: let
    res = builtins.trace "defraging with file ${toString file.id}" (defrag acc.free file);
  in
    {
      inherit (res) free;
      files = acc.files ++ res.file;
    })
  {free = disk; files = [];}
  ;


  checksum = disk: disk.files
    |> foldl' (acc: {id, size, start}: acc + (id * size * (start + ((size - 1) / 2.0)))) 0
  ;

  fullDisk = disk |> map (sect: genList (i: sect.id) sect.size) |> lib.concatLists;

  defragFullDisk = d: let
    notEmptyDisk = d |> filter (s: !isNull s);
  in d |> foldl' ({i, j, acc}: id: let
    idFromEnd = elemAt notEmptyDisk i;
  in {
    acc = acc ++ [(if j >= length notEmptyDisk then null else if isNull id then idFromEnd else id)];
    i = if isNull id then i + 1 else i;
    j = j + 1;
  }
  ) {i = 0; acc = []; j = 0;};

  checksumFullDisk = d: d |> filter (s: !isNull s)
  |> foldl'
    ({i, total}: id: {i = i + 1; total = total + i * id;})
    {i = 0; total = 0;};

in {

  inherit data disk defrag defragged checksum fullDisk;

  part1result = defragged |> checksum;

  # defraggedFullDisk = defragFullDisk fullDisk;

  # part1result = (defragFullDisk fullDisk).acc |> checksumFullDisk;

}
