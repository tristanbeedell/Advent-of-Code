{lib, ...}: input: rec {

  content = lib.trim input;

  chart = toChart content;

  toChart = s: s
    |> lib.strings.splitString "\n"
    |> map (lib.stringToCharacters)
  ;

  startingPos = let
    xs = map (lib.lists.findFirstIndex (char: char == "^") null) chart;
    y = lib.lists.findFirstIndex (x: !isNull x) null xs;
    x = builtins.elemAt xs y;
  in
    {inherit x y;}
  ;

  posToString = {x, y}: "${toString x},${toString y}";

  addVec = a: b: {x = a.x + b.x; y = a.y + b.y;};

  index = i: list: builtins.elemAt list i;

  getChar = {x, y}: chart: chart
    |> index y
    |> index x
  ;

  height = builtins.length chart;
  width = chart |> index 0 |> builtins.length;

  replace2d = {x, y}: updated: chart: let
    newRow = chart |> index y |> replace x updated;
  in
    replace y newRow chart;

  replace = i: updated: list: 
  let before = lib.sublist 0 i list;
    after = lib.sublist (i + 1) (builtins.length list - i) list;
  in
    if i < 0 || i > builtins.length list then list else
    before ++ [updated] ++ after;

  progress = {visited ? {}, pos, dir, obs ? [], charts ? chart, ...}: let
    newDir = if colliding then rotate dir else dir;
    newPos = addVec pos newDir;
    colliding = nextChar == "#";
    nextChar = getChar fwd charts;
    fwd = addVec pos dir;
    hash = posToString pos;
    exited = fwd.y >= height || fwd.x >= width || fwd.y < 0 || fwd.x < 0;
    canObstruct = 
      # unique
      (!lib.elem (posToString fwd) obs)
      # inside map
      && (!exited)
      # can't put an obstacle when there already is one
      && (!colliding)
      # if I already visited the place in front, putting an obstacle there won't work, as I can't get to where I am now!
      && (!lib.hasAttr (posToString fwd) visited)
      # see if I will end up in a loop turning right here
      && getLoop {inherit pos visited dir; charts = replace2d fwd "#" charts;};
  in
  {
    visited = visited // {${hash} = visited.${hash} or [] ++ [dir];};
    pos = if colliding then pos else newPos;
    dir = newDir;
    inherit exited charts;
    obs = obs ++ (if canObstruct then [(posToString fwd)] else []);
  };

  rotate = {x, y}: {x = -y; y = x;};

  startingDir = {x = 0; y = -1;};

  getVisits = {pos ? startingPos
  , dir ? startingDir
  , visited ? {}
  , obs ? []
  , charts ? chart
  , ...}:
    let
      nextStep = progress {inherit pos dir visited obs charts;};
    in if nextStep.exited then nextStep else getVisits nextStep;

  path = getVisits {};

  part1result = path.visited
    |> builtins.attrNames
    |> builtins.length
  ;

  getLoop = state:
    let
      nextStep = progress state;
      hash = posToString state.pos;
      enteredLoop = lib.elem state.dir (state.visited.${hash} or []);
    in if enteredLoop then true
      else if nextStep.exited then false
        else getLoop nextStep;

  part2result = builtins.trace "This is very slow!" (path.obs |> builtins.length)
  ;

  # visualisation stuff

  hashToVec = s: s |> lib.splitString "," |> map lib.strings.toInt |> (v: {x = index 0 v; y = index 1 v;});

  annotateObs = chart:
    builtins.foldl'
    (c: obs: let pos = hashToVec obs; in replace2d pos "O" c) chart path.obs;

  annotatePath = chart:
    builtins.foldl'
    (c: hash: let
      pos = hashToVec hash;
      dir = index 0 path.visited.${hash};
      sym = if dir.x == 1 then ">" else if dir.x == -1 then "<" else if dir.y == 1 then "v" else "^";
    in replace2d pos sym c) chart
    (builtins.attrNames path.visited);

  chartToStr = c: c
    |> map (lib.concatStringsSep "")
    |> lib.concatStringsSep "\n"
  ;

  annotated = chart |> annotatePath |> annotateObs |> chartToStr;

}
