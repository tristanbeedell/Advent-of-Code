// this is really slow but it works after a few seconds. I only learnt about memoising yesterday and couldn't get it to work. I will probably leave this as it is anyway.
const fs = require('fs');
const data = fs.readFileSync('input.txt', 'utf-8');

// convert seat layout to matrix of bools
let layoutMat = data.split('\n').map(l=>l.split('').map(s=>s=='L'));


function iterate (stateMat, layoutMat){
  let nextState = stateMat.map(r => r.slice());
  for (let y = 0; y < layoutMat.length; y++) {
    for (let x = 0; x < layoutMat[1].length; x++) {
      if (!layoutMat[y][x]) continue // if this point is the floor, skip
      // count how many adjacent seats are full
      let seenSeats = lookAround(stateMat, x, y)
      // update seat according to rules in the challenge
      nextState[y][x] = stateMat[y][x] ? seenSeats < 5 : seenSeats == 0;
      // console.log('from', x,y,'i see', seenSeats, 'full chairs', nextState[y][x] ? 'so i sit here':'so i leave')
    }
  }
  return nextState
}

// look every direction from given co-ords
function lookAround (stateMat, x, y) {
  let amt = 0
  for (let dx = -1; dx <=1; dx++) {
    for (let dy = -1; dy <= 1; dy++) {
      if (dx == 0 && dy == 0) continue
      isChair = look(stateMat, x, y, dx, dy);
      // console.log(matToString(stateMat))
      // console.log('looking from', x, y, 'in direction', dx,dy, 'chair is', isChair)
      amt += isChair
    }
  }
  return amt
}

function look(stateMat, x, y, dx, dy) {
  // if this is the edge, it there is no full chair
  if (x+dx < 0 || y+dy < 0 || x+dx >= stateMat[0].length|| y+dy >= stateMat.length) {return false}
  // if there is a chair, return if it is full or not
  if (layoutMat[y+dy][x+dx]) {return stateMat[y+dy][x+dx]}
  // this must be floor, check next spot
  return look(stateMat, x+dx, y+dy, dx, dy)
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
let stateMat = new Array(layoutMat.length).fill([]).map(r => {return new Array(layoutMat[0].length).fill(false)})

while (true) {
  prevState = stateMat.map(r => r.slice()); // deep clone the current state
  stateMat = iterate(stateMat, layoutMat);  // iterate on the state 
  // console.log(matToString(stateMat))
  if (compareMat(prevState, stateMat)) break // if there is no change, we are done
}

// log the total amount of taken seats
console.log(stateMat.reduce((a1,b1)=>a1+b1.reduce((a2, b2)=>a2+b2, 0), 0)) 
