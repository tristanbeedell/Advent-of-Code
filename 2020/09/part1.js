const fs = require('fs');
const data = fs.readFileSync('input.txt', 'utf-8');
const lines = data.split('\n').map(num => parseInt(num));
const preambleLength = 25;

let first
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
    first = lines[i]
    break
  }
}
console.log(first)