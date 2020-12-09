const fs = require('fs');
const data = fs.readFileSync('input.txt', 'utf-8');
const lines = data.split('\n').map(num => parseInt(num));
const preambleLength = 25;

let sum
for (let i = preambleLength; i < lines.length; i++) {
  valid = false
  for (let j = i-preambleLength; j < i && !valid; j++) {
    for (let k = j+1; k < i && !valid; k++) {
      if (lines[j]+lines[k]== lines[i]) {
        valid = true
      }
    }
  }
  if (!valid) {
    sum = lines[i]
    break
  }
}

for ( let start = 0; start < lines.length; start++) {
  for (let end = start+1; end < lines.length; end++) {
    if (lines[end] > sum) {continue}
    let range = lines.slice(start, end)
    if (range.reduce((a,b) => (a+b)) == sum) {
      console.log(Math.min(...range)+ Math.max(...range))
    }
  }
}