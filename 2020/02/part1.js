const fs = require('fs');
let data = fs.readFileSync('input.txt', 'utf-8');
let lines = data.split('\n').map(x => x.split(" "));
let count = 0
for (let i = 0; i < lines.length; i++) {
  let line = lines[i]
  let lim = line[0].split("-")
  let char = line[1].substring(0, 1)
  let pass = line[2]
  let match = pass.match(new RegExp(char, 'g'))
  if (!match) { continue }
  let matches = match.length
  if (matches < lim[0] || matches > lim[1]) { continue }
  console.log(pass)
  count++
}
console.log(count)