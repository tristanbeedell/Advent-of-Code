const fs = require('fs');
const data = fs.readFileSync('./input.txt', 'utf-8');
const lines = data.split('\n').map(num => parseInt(num)).sort((a,b)=>(a-b));
lines.unshift(0); // add the outlet with joltage 0
lines.push(lines[lines.length-1]+3); // your device has a joltage 3 above the highest
let threes = 0; // keep track of differences for puzzle solution
let ones = 0;
for (let i = 1; i < lines.length; i++) {
  switch (lines[i]-lines[i-1]) {
    case 3:
      threes++;
      break;
    case 1:
      ones++;
      break;
  }
}
console.log(ones * threes)