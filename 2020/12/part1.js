// cool today's puzzle is basically a turtle
const fs = require('fs');
const instructions = fs.readFileSync('input.txt', 'utf-8').split('\n');
// position and direcion start at 0
let x = y = d = 0;
instructions.forEach((instruction, i) => {
  console.log(x,y,d)
  action = instruction[0];
  arg = Number(instruction.slice(1));
  switch (action) {
    case 'N':
      y+=arg;
      break;
    case 'S':
      y-=arg;
      break;
    case 'E':
      x+=arg;
      break;
    case 'W':
      x-=arg;
      break;
    case 'L':
      d-=arg;
      break;
    case 'R':
      d+=arg;
      break;
    case 'F':
      y -= Math.round(arg * Math.sin(d*Math.PI/180));
      x += Math.round(arg * Math.cos(d*Math.PI/180));
      break;
    default:
      console.log('instruction no', i+1, action,'invald')
  }
})
console.log(x,y,d)
console.log(Math.abs(x)+ Math.abs(y))