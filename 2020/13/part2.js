// this was a tough one. I still don't fully understand what the puzzle was asking for. but i played around in excel and found this method to find the solution. 
const fs = require('fs');
const input = fs.readFileSync('input.txt', 'utf-8').split('\n');
const busses = input[1].split(',').map(n => Number(n)).map((v,i)=>[v,i]).filter(v => !isNaN(v[0]));
console.log(busses)
// start with a timestamp of 0
let time = 0;
// if you incrment by the ID of the first bus, the first bus will always meet the pattern described in the puzzle.
let inc = busses[0][0]
for (let bus = 1; bus < busses.length; bus++){
  // continue incrementing until the next bus meets the pattern described in the puzzle
  while (((time+busses[bus][1]) % busses[bus][0]) != 0) {
    time += inc
  }
  // now you can increment by the new bus that met the pattern, and it will continue to meet the pattern
  inc*=busses[bus][0]
}
// since we looped through all the busses, we know that all busses meet the pattern.
console.log(time)