// I wanted to do today's puzzle using bitwise operators, but it kept on spitting out negative numbers, so I gave up with that and ended up with this way that uses arrays and strings instead.
const fs = require('fs');
const input = fs.readFileSync('input.txt', 'utf-8').split('\n').map(l=>l.split(' = '));

let mask = [];
let mem = []
input.forEach(command => {
  if (command[0] == 'mask') {
    // convert the mask into an array
    mask = command[1].split('')
  } else {
    // grab the number in mem[x]
    let index = Number(command[0].substring(4,command[0].length-1));
    // convert the arg to binary string
    let value = Number(command[1]).toString(2)
    // add 0s to front so it is the same length as the mask
    while (value.length < mask.length) {
      value = '0' + value
    }
    // run the value thru the mask and convert back to a Number
    let result = parseInt(mask.map((m,i)=>m=='X'?value[i]:m).join(''),2)
    // store the result
    mem[index] = result
  }
});
// log the total of mem
console.log(mem.reduce((a,b)=>a+b, 0))
