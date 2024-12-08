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

  # FASTER!

  startingObsMap = getObsMap chart;

  getObsMap = chart: chart
    |> lib.imap0 (y: line: line
      |> lib.imap0 (x: char: if char != "#" then null else makeObs chart (b: b == "#") {inherit x y;})
    )
  ;

  makeObs = chart: matcher: {x, y}: {
    right = if y + 1 >= height || x + 1 >= width then null else 
      searchRight matcher {x = x + 1; y = y + 1;} chart;

    left = if y < 1 || x <= 0 then null else
      searchLeft matcher {x = x - 1; y = y - 1;} chart;

    down = if x <= 0 || y + 1 >= width then null else 
      searchDown matcher {x = x - 1; y = y + 1;} chart;

    up = if x + 1 >= width then null else 
      searchUp matcher {x = x + 1; y = y - 1;} chart;
  };

  maybe = f: a: b: if !(builtins.isInt a && builtins.isInt b) then null else f a b;
  maybeAdd = maybe builtins.add;
  maybeSub = maybe builtins.sub;
  column = x: map (index x);

  searchLeft = matcher: {x, y}: chart: chart
    |> index y
    |> lib.sublist 0 (x + 1)
    |> lib.reverseList
    |> lib.lists.findFirstIndex matcher null
    |> maybeSub x
  ;
  searchDown = matcher: {x, y}: chart: chart
    |> lib.sublist y height
    |> column x
    |> lib.lists.findFirstIndex matcher null
    |> maybeAdd y
  ;
  searchRight = matcher: {x, y}: chart: chart
    |> index y
    |> lib.sublist x width
    |> lib.lists.findFirstIndex matcher null
    |> maybeAdd x
  ;
  searchUp = matcher: {x, y}: chart: chart
    |> lib.sublist 0 (y + 1)
    |> column x
    |> lib.reverseList
    |> lib.lists.findFirstIndex matcher null
    |> maybeSub y
  ;

  firstOb = {
    y = searchUp (i: !isNull i) startingPos startingObsMap;
    x = startingPos.x;
  };

  index2d = {x, y}: m: m |> index y |> index x;

  lookRight = obsMap: prev: {
    x = (index2d prev obsMap).right;
    y = prev.y + 1;
  };

  lookDown = obsMap: prev: {
    x = prev.x - 1;
    y = (index2d prev obsMap).down;
  };

  lookLeft = obsMap: prev: {
    x = (index2d prev obsMap).left;
    y = prev.y - 1;
  };

  lookUp = obsMap: prev: {
    x = prev.x + 1;
    y = (index2d prev obsMap).up;
  };

  getNextDir = i: [lookRight lookDown lookLeft lookUp]
    |> index (lib.mod i 4)
  ;

  getFastpath = {i ? 0, pos ? firstOb, obsMap ? startingObsMap, hist ? []}: let
    nextPos = (getNextDir i) obsMap pos;
    newHist = hist ++ [point];
    point = pos // {dir = lib.mod i 4;};
    looped = lib.elem point hist;
  in if isNull pos.x || isNull pos.y || looped
  then {path = hist ++ [pos]; inherit looped;}
  else getFastpath {i = i + 1; pos = nextPos; hist = newHist; inherit obsMap;}
  ;

  fastpath = getFastpath {};

  allObs = builtins.genList (i: {
    x = lib.mod i width;
    y = i / height;
  }) (height * width)
    |> builtins.filter (pos: index2d pos startingObsMap |> isNull)
    |> map (pos: insert pos startingObsMap)
  ;

  replaceColumn = y: lib.zipListsWith (row: new:
    replace y row new
  );

  insert = {x, y}@pos: chart: let
    newObs = makeObs chart builtins.isAttrs pos;
    # nextL = searchRight 
  in chart
    |> replace2d pos newObs
    # update obstacles on rows above and below
    |> (if y - 1 < 0 then lib.id else nChart: replace (y - 1) (
        nChart |> index (y - 1)
          |> lib.imap0 (x: b: if isNull b then null else
          makeObs nChart builtins.isAttrs {inherit x; y = y - 1;})
          # |> map (o: if builtins.isAttrs o && o.right > x then
          #   o // {right = x;} else o)
      ) nChart)
    |> (if y + 1 >= width then lib.id else nChart: replace (y + 1) (
        nChart |> index (y + 1)
          |> lib.imap0 (x: b: if isNull b then null else
          makeObs nChart builtins.isAttrs {inherit x; y = y + 1;})
      ) nChart)
    |> (if x - 1 < 0 then lib.id else nChart:
      replaceColumn (x - 1) (column (x - 1) nChart
        |> lib.imap0 (y: b: if isNull b then null else
        makeObs nChart builtins.isAttrs {inherit y; x = x - 1;})
      ) nChart)
    |> (if x + 1 >= width then lib.id else nChart:
      replaceColumn (x + 1) (column (x + 1) nChart
        |> lib.imap0 (y: b: if isNull b then null else
        makeObs nChart builtins.isAttrs {inherit y; x = x + 1;})
      ) nChart)
    
  ;

  loopyMaps = allObs
    |> builtins.filter (m: (getFastpath {obsMap = m;}).looped);

  part2faster = builtins.length loopyMaps;

}
