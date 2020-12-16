// I didn't expect this to be very efficient but it acually was pretty quick

const fs = require('fs');
const [fields, myTicket, nearbyTickets] = fs.readFileSync('./input.txt', 'utf-8').split('\n\n');

// make set of all valid nums
const valid = fields.match(/\d+-\d+/g).reduce((a, v) => {
  let [start, end] = v.split('-').map(a=>parseInt(a));
  for (let j = start; j <= end; j++) {
    a.add(j);
  }
  return a;
}, new Set())

// get all nums on nearby tickets
const nums = nearbyTickets.match(/\d+/g).map(v => parseInt(v))

// find all the nums that aren't valid, add up the total
let v = nums.filter(num => !valid.has(num)).reduce((a,b)=>a+b,0);
console.log(v)