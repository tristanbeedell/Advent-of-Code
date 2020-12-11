// looks like today's puzzle is the game of life but with holes in the grid
// never programmed the game of life before but I am familiar

const fs = require('fs');
const data = fs.readFileSync('input.txt', 'utf-8');

// convert seat layout to matrix of bools with padding left and right
let layoutMat = data.split('\n').map(l=>('.'+l+'.').split('').map(s=>s=='L'));
// create padding on top and bottom
layoutMat.unshift(new Array(layoutMat[0].length).fill(false));
layoutMat.push(new Array(layoutMat[0].length).fill(false));


function iterate (stateMat, layoutMat){
  let nextState = stateMat.map(r => r.slice());

  for (let y = 1; y < layoutMat.length - 1; y++) {
    for (let x = 1; x < layoutMat[1].length - 1; x++) {
      if (!layoutMat[y][x]) continue // if this point is the floor, skip
      // count how many adjacent seats are full
      let adjSeatsFull = stateMat[y-1][x-1] + stateMat[y-1][x  ] + stateMat[y-1][x+1] +
                         stateMat[y  ][x-1]                      + stateMat[y  ][x+1] +
                         stateMat[y+1][x-1] + stateMat[y+1][x  ] + stateMat[y+1][x+1];

      // update seat according to rules in the challenge
      nextState[y][x] = stateMat[y][x] ? adjSeatsFull < 4 : adjSeatsFull == 0;
    }
  }
  return nextState
}
// convert matrix of seats into a string for logging
function matToString (m) {
  return m.reduce((a1, r, y) => {
    return a1 + 
    r.reduce((a,full,x) => a+String(full?'#':layoutMat[y][x]?'L':'.'), '') + 
    '\n'},
  '');
}
// compare two matricies because javascript wont do that for you
function compareMat (m1, m2) {
  return m1.reduce((a1,v1,i)=>a1&&v1.reduce((a2,v2,j)=>a2&&v2==m2[i][j],true),true)
}
// create matrix of false values. this is the initial state (all empty seats)
let stateMat = new Array(layoutMat.length).fill(new Array(layoutMat[0].length).fill(false));

while (true) {
  // console.log(matToString(stateMat))
  // console.log(stateMat.reduce((a1,b1)=>a1+b1.reduce((a2, b2)=>a2+b2, 0), 0))
  prevState = stateMat.map(r => r.slice()); // clone the current state
  stateMat = iterate(stateMat, layoutMat);  // iterate on the state 
  if (compareMat(prevState, stateMat)) break // if there is no change, we are done
}

// log the total amount of taken seats
console.log(stateMat.reduce((a1,b1)=>a1+b1.reduce((a2, b2)=>a2+b2, 0), 0)) 