// this was fairly simple; just keep increasing the wait until you find a bus that leaves. there is probably a more efficient solution but this works
const fs = require('fs');
const input = fs.readFileSync('input.txt', 'utf-8').split('\n');
const time = Number(input[0]);
const busses = input[1].split(',').filter(v=>v!='x').map(n => Number(n));

let isBus = false;
let timeDif = 0;
let busID;
for (; !isBus; timeDif++) {
  for(bus of busses) {
    if ((time + timeDif) % bus == 0){
      busID = bus;
      isBus = true;
      break;
    }
  }
}
// the for loop does an extra increment at the end oops
timeDif--
console.log(timeDif*busID)