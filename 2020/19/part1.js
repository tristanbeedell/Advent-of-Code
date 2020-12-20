const fs = require('fs');
const input = fs.readFileSync('./part1input.txt', 'utf-8');
let rules = new Map();
input.split('\n\n')[0].split('\n').forEach(line => {
  parts = line.split(': ');
  rules.set(parts[0], parts[1].split(' | ').map(o => o.split(' ')));
});
let howFar = 0;

function check (str, ruleNum = '0', matchToEnd = true) {
  if (ruleNum[0] == '"') {
    return str[howFar++] == ruleNum[1];
  }
  let rule = rules.get(ruleNum);
  for (let pattern of rule) {
    let before = howFar;
    let success = true;
    for (let token of pattern) {
      let match = check(str, token, false);
      if (!match) {
        success = false;
        break;
      }
    }
    if (matchToEnd?success&&howFar==str.length:success) return true;
    howFar = before
  }
  return false;
}

let total = 0
input.split('\n\n')[1].split('\n').forEach(line => {
  howFar = 0
  total+=check(line)
});
console.log(total)