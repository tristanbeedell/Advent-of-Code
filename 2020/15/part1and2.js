const input = [1,17,0,10,18,11,6];
const find = 30000000;

let saidNums = new Map();
input.slice(0,input.length-1).forEach((n,i) => saidNums.set(n,i));

let lastNum = input[input.length-1];
let i = input.length;

while (i < find) {
  let thisNum = 0;
  if (saidNums.has(lastNum)) {
    thisNum = (i-1) - saidNums.get(lastNum);
  }
  saidNums.set(lastNum, i-1);
  lastNum = thisNum;
  i++;
}

console.log(lastNum)