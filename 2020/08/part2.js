const fs = require('fs');

const data = fs.readFileSync('input.txt', 'utf-8');
const lines = data.split('\n');
let instructions = [];

lines.forEach((line, i) => {
  t = line.split(' ');
  instructions[i] = [t[0], parseInt(t[1])]
})

function loop (i, seen, acc, swapped) {
  console.log(i, instructions[i])
  if (seen.has(i)) {
    console.log('seen, escaping')
    return false;
  }
  seen.add(i);
  console.log('acc = ', acc)
  let nextI = i;
  let nextAcc = acc;
  switch (instructions[i][0]) {
    case 'acc':
      nextAcc+=instructions[i][1];
      nextI++;
      break;
    case 'jmp':
      nextI += instructions[i][1];
      break;
    case 'nop':
      nextI ++;
      break;
    default:
      console.log('halting with', acc);
      return true;
  }
  nextAcc = loop(nextI, seen, nextAcc, swapped);
  if (nextAcc === false) {
    console.log(i, instructions[i])
    if (instructions[i][0] == 'jmp' && !swapped) {
      nextAcc = loop(i+1, seen, acc, true)
    }
  }
  return nextAcc;
}

loop(0, new Set(), 0, false)
// take the last acc value