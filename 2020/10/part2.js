const fs = require('fs');
const data = fs.readFileSync('input.txt', 'utf-8');
const lines = data.split('\n').map(num => parseInt(num)).sort((a,b)=>(a-b));
lines.unshift(0);
lines.push(lines[lines.length-1]+3);


// convert to linked list
let last = {};
let i = 0
do {
  let entry = {
    value: lines[i],
    prev: last
  };
  last.next = entry;
  last = entry;
  i++;
} while (i < lines.length)

// find removeable adaptors
let removeableAdaptors = [];
const lastVal = last
last = last.prev
while (last.prev) {
  if (last.next.value - last.prev.value <= 3){
    removeableAdaptors.push(last)
  }
  last = last.prev
}

// divide removeable adaptors into groups that don't interfere with one another when removed
// this changes the runtime with the given input from a over a month to less than a millisecond
// however, in a worst case scenareo, where every adaptor is removeable, this would still take trillions of years.
let adaptorGroups = []
function makeGroups(removeableAdaptors) {
  for (let i = removeableAdaptors.length-1; i>-1; i--) {
    // if the gap between two removeable adaptors > 2 then you know they will not intefere with each other
    if (i == 0 || removeableAdaptors[i-1].value - removeableAdaptors[i].value > 2) {
      adaptorGroups.push(removeableAdaptors.slice(i))
      makeGroups(removeableAdaptors.slice(0, i))
      break;
    }
  }
}
makeGroups(removeableAdaptors)

function findArrangements (removeableAdaptors, s = 0) {
  total = 1
  // for each adaptor in the group
  for (let i = s; i < removeableAdaptors.length; i++){
    // if you can remove this adaptor
    if (removeableAdaptors[i].next.value-removeableAdaptors[i].prev.value <= 3) {
      // remove the adaptor and find arrangements with it gone
      removeableAdaptors[i].prev.next = removeableAdaptors[i].next
      total += findArrangements (removeableAdaptors, i+1)
      // add the adaptor back for following tests
      removeableAdaptors[i].prev.next = removeableAdaptors[i]
    }
  }
  return total
}

console.time('time')
// multipy the amount of arrangements in each group to get the total amount of arrangements.
answer = adaptorGroups.reduce((a, g) => {return a*findArrangements(g)},1)
console.timeEnd('time')

console.log(answer)
