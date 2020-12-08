const fs = require('fs');

const data = fs.readFileSync('input.txt', 'utf-8');
const lines = data.split('\n');
let instructions = [];

lines.forEach((line, i) => {
  t = line.split(' ');
  instructions[i] = [t[0], parseInt(t[1])]
})

function loop (i, seen, acc) {
  if (seen.has(i)) {
    return acc;
  }
  seen.add(i);
  switch (instructions[i][0]) {
    case 'acc':
      acc+=instructions[i][1];
      i ++;
      break;
    case 'jmp':
      i += instructions[i][1];
      break;
    case 'nop':
      i ++;
      break;
    default:
      console.log('something went wrong. got instruction:', instruction[i][0]);
  }
  acc = loop(i, seen, acc);
  return acc;
}

loop(0, new Set(), 0)