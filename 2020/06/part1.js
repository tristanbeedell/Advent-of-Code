const fs = require('fs');

const data = fs.readFileSync('test.txt', 'utf-8');
const groups = data.split('\n\n');

let sum = 0
for (let g = 0; g<groups.length; g++){
  let group = groups[g]
  // ignore spaces and new lines; we don't care about that
  group = group.replace(/[ \n]/gm, "")

  // list of seen chars
  let chars = []
  for (let i = 0; i < group.length; i++) {
    // if not already seen, add to list of seen chars
    if (!chars.find(char => char == group[i])) { chars.push(group[i]) }
  }
  // keep a sum for our puzzle answer
  sum += chars.length
}
console.log(sum)