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
  // if there's addition, do that
  while (expression.match(/\+/)){
    expression = expression.replace(/(\d+) \+ (\d+)/, (match, a, b) => 
      parseInt(a) + parseInt(b)
    )
  }
  // if there's multiplication, do that
  while (expression.match(/\*/)) {
    expression = expression.replace(/(\d+) \* (\d+)/, (match, a, b) => 
      parseInt(a) * parseInt(b)
    )
  }
  return Number(expression)
}

let runningTotal = 0
for (expression of expressions) {
  runningTotal += calc (expression)
}
console.log(runningTotal)