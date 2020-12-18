const fs = require('fs');
const expressions = fs.readFileSync('./input.txt', 'utf-8').split('\n');

function calc (expression) {
  // if it's just a number, do nothing
  if (!isNaN(Number(expression))) { Number(expression) }
  // if there's brackets, do that first
  while (expression.match(/\(/)){
    expression = expression.replace(/\([^()]+\)/, match => 
      calc (match.slice(1, match.length-1))
    )
  }
  // do all the calculations until it's just a number
  while (isNaN(Number(expression))) {
    expression = expression.replace(/(\d+) ([+*]) (\d+)/, (match, a, op, b) => 
      op == '+' ? parseInt(a) + parseInt(b) : parseInt(a) * parseInt(b)
    )
  }
  return Number(expression)
}

let runningTotal = 0
for (expression of expressions) {
  runningTotal += calc (expression)
}
console.log(runningTotal)