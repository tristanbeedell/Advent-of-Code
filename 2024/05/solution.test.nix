{describe, it, ...}:
let
  pkgs = import <nixpkgs> {};
  solution = import ./solution.nix pkgs;
  exampleInput = pkgs.lib.readFile ./example.txt;
  example = solution exampleInput;
  parsed = {
        rules = {
          "29" = ["13"];
          "47" = ["53" "13" "61" "29"];
          "53" = ["29" "13"];
          "61" = ["13" "53" "29"];
          "75" = ["29" "53" "47" "61" "13"];
          "97" = ["13" "61" "47" "29" "53" "75"];
        };
        updates = [
          ["75" "47" "61" "53" "29"]
          ["97" "61" "53" "29" "13"]
          ["75" "29" "13"]
          ["75" "97" "47" "61" "53"]
          ["61" "13" "29"]
          ["97" "13" "75" "29" "47"]];
      };
in [
  (describe "part 1" [
    (it "splits the rules from updates" {
      actual = example.parts;
      expected = parsed;
    })
    (it "check if an update complies with rule" {
      actual = map example.check [{
        rules = {
          "0" = ["1"];
          "1" = ["2"];
        };
        update = ["0" "1" "2"];
      }
      {
        rules = {
          "0" = ["1"];
          "1" = ["0"];
        };
        update = ["0" "1" "2"];
      }
      {
        inherit (parsed) rules;
        update = 
          ["75" "47" "61" "53" "29"];
      }
      {
        inherit (parsed) rules;
        update = 
          ["75" "97" "47" "61" "53"];
      }
      ];
      expected = [true false true false];
    })
    (it "gets valid updates" {
      actual = example.getValid parsed;
      expected = [
        ["75" "47" "61" "53" "29"]
        ["97" "61" "53" "29" "13"]
        ["75" "29" "13"]
      ];
    })
    (it "sums middles of arrays" {
      actual = example.getMiddles [
        ["75" "47" "61" "53" "29"]
        ["97" "61" "53" "29" "13"]
        ["75" "29" "13"]
      ];
      expected = [61 53 29];
    })
    (it "gets the result" {
      actual = example.part1result;
      expected = 143;
    })
  ])
  (describe "part 2" [
    (it "sorts an update" {
      actual = parsed.updates
        |> map (example.sortUpdate parsed.rules);
      # in reverse but who cares
      expected =
        [["29" "53" "61" "47" "75"] ["13" "29" "53" "61" "97"] ["13" "29" "75"] ["53" "61" "47" "75" "97"] ["13" "29" "61"] ["13" "29" "47" "75" "97"]];
    })
    (it "filters invalid" {
      actual = example.getInvalid parsed;
      expected = [
        ["75" "97" "47" "61" "53"]
        ["61" "13" "29"]
        ["97" "13" "75" "29" "47"]
      ];
    })
    (it "gets result" {
      actual = example.part2result;
      expected = 123;
    })
  ])
]
