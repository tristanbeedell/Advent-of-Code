const fs = require('fs');
const input = fs.readFileSync('input.txt', 'utf-8').split('\n').map(l=>l.split(' = '));

let mask = [];
let mem = new Map();
let memo = new Map()
let runningTotal = 0
input.forEach((command,i) => {
  if (command[0] == 'mask') {
    // reset the mask and memorised values from that mask
    mask = command[1].split('');
    memo = new Map();
  } else {
    let value = Number(command[1]);
    let index = Number(command[0].substring(4,command[0].length-1)).toString(2);
    while (index.length < mask.length) {
      index = '0' + index;
    }
    let addresses = [...address(index.split(''))]
    addresses.forEach(add => {
      // keep a running total instead of adding it up at the end by adding the value and subtracting the value that it replaces
      runningTotal += value - (mem.get(parseInt(add, 2))||0)
      mem.set(parseInt(add, 2), value)
    })
  }
});
console.log(runningTotal)

// calculate all addresses from a given address after the mask is applied
function address(loc, i = 0, found = new Set()) {
  // reached the end of the address
  if (i >= mask.length) {
    // add the new address
    return found.add(loc.join(''))
  }
  // if I have already seen this address ending
  let key = loc.slice(i).join('')
  if (memo.has(key)) {
    // add all the addresses that result from this ending
    let prefix = loc.slice(0,i).join('');
    [...memo.get(key)].forEach(suffix => {found.add(prefix+suffix)});
    return found
  }
  // apply the mask from point i and get all possibilities into the array rem
  let rem = []
  switch (mask[i]) {
    case '1':
      loc[i] = '1'
    case '0':
      rem = [...address([...loc],i+1,found)]
      break;
    case 'X':
      loc[i] = '0';
      rem = [...address([...loc],i+1,found)]
      loc[i] = '1';
      rem.push(...[...address([...loc],i+1,found)])
      break;
    default:
      console.log('oops, bad mask at index', i)
  }
  // store the possibilities in the memo in case we come across this pattern again.
  memo.set(key, new Set(rem.map(o => o.slice(i))))
  return found
}

