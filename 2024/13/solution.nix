{lib, ...}: input: let
  inherit (builtins) elemAt match filter foldl';
  inherit (lib.strings) toIntBase10;

  acost = 3;
  bcost = 1;
  part2offset = 10000000000000;

  machines = input
    |> lib.trim
    |> lib.splitString "\n\n"
    |> map (text: let
        parts = text |> lib.splitString "\n";
        buttona = elemAt parts 0;
        buttonb = elemAt parts 1;
        prize = elemAt parts 2;
      in {
        a = buttonToVec buttona;
        b = buttonToVec buttonb;
        prize = prizeToVec prize;
      }
    )
  ;

  buttonToVec = text: text
    |> match ''Button .: X\+([0-9]+), Y\+([0-9]+)''
    |> map toIntBase10
    |> (nums: {
      x = elemAt nums 0;
      y = elemAt nums 1;
    })
  ;
  prizeToVec = text: text
    |> match ''Prize: X=([0-9]+), Y=([0-9]+)''
    |> map toIntBase10
    |> (nums: {
      x = elemAt nums 0;
      y = elemAt nums 1;
    })
  ;

  getPresses = {a, b, prize}:
  let
    # see https://www.desmos.com/calculator/qfzdjjffso
    # ma = 1.0 * a.y / a.x;
    # mb = 1.0 * b.y / b.x;
    # c = prize.y - prize.x * mb;
    # x = c / (ma - mb);

    # rearranged to avoid precision errors
    x = (b.x * prize.y - prize.x * b.y) * a.x / (b.x * a.y - a.x * b.y);

    apresses = x / a.x;
    bpresses = (prize.x - x) / b.x;
  in {
    a = apresses;
    b = bpresses;
    doable = a.x * apresses + b.x * bpresses == prize.x &&
      a.y * apresses + b.y * bpresses == prize.y;
  };

in {
  inherit machines buttonToVec prizeToVec getPresses;

  part1result = machines
    |> map getPresses
    |> filter ({doable, ...}: doable)
    |> foldl' (cost: {a,b,...}: cost + a * acost + b * bcost) 0
  ;

  part2result = machines
    |> map (machine: machine // {prize = {
      x = machine.prize.x + part2offset;
      y = machine.prize.y + part2offset;
    };})
    |> map getPresses
    |> filter ({doable, ...}: doable)
    |> foldl' (cost: {a,b,...}: cost + a * acost + b * bcost) 0
  ;

}
