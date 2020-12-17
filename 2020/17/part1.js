const fs = require('fs');
const textIn = fs.readFileSync('./input.txt', 'utf-8');
const iterAmt = 6;

// make a list of points to add at first
let startPoints = []
// could do forEach() instead of map() but i already did it like this and it works
startGrid = textIn.split('\n').map((line, y) => line.split('').map((point, x) => {
  if (point=='#') {
    startPoints.push([iterAmt+x,iterAmt+y,iterAmt])
  }
  return point=='#'
}));
// start with zero active cubes
let runningTotal = 0;
// create an empty pocket dimension
let p = new Pocket()
// add the points from the input
startPoints.forEach(point => add(...point, p));

for (let i = 0; i < iterAmt; i++) {
  printLayer(p,iterAmt);

  // create a deep copy of the current state
  let next = p.map(layer => layer.map(row => row.map(cube => {return{active:cube.active,nearby:cube.nearby}})))

  // for every single cube in the pocket dimension
  p.forEach((layer, z) => layer.forEach((row, y) => row.forEach((cube, x) => {
    // apply the game of life rules using p and store in next
    if (cube.active && (cube.nearby < 2 || cube.nearby > 3)) {
      remove(x,y,z,p,next)
    } else if (!cube.active && (cube.nearby == 3)) {
      add(x,y,z,p,next)
    }
  })))

  p = next;
}

console.log(runningTotal);

// -------------------------------

function printLayer(pocket, layer) {
  console.log( pocket[layer].reduce((a,b)=>a+b.reduce((c,d)=>c+(d.active?'\x1b[36m':'\x1b[0m')+(d.nearby.toString().length==1?'0':'')+d.nearby,'')+'\n',''))
}

// returns empty pocket dimension
function Pocket () {
  let pocket = [];
  for (let z = 0; z < iterAmt*2+1; z++) {
    let layer = []
    for (let y = 0; y < iterAmt*2+startGrid.length; y++) {
      let row = []
      row = Array(iterAmt*2 + startGrid[0].length).fill(0).map(()=>{return{active:false,nearby:0}})
      layer.push(row)
    }
    pocket.push(layer)
  }
  return pocket
}


function add (x,y,z,before,after=before) {
  if (before[z][y][x].active) return before; // if it's already active, do nothing
  runningTotal++;
  after[z][y][x].active = true;
  // for every cube near the one we just added
  for (let layer = Math.max(z-1, 0); layer <= Math.min(z+1, before.length-1); layer++) {
    for (let row = Math.max(y-1, 0); row <= Math.min(y+1, before[0].length-1); row++) {
      for (let col = Math.max(x-1, 0); col <= Math.min(x+1, before[0][0].length-1); col++) {
        // but not the one we just added
        if (layer == z && row == y && col == x) continue;
        // there now is one more nearby cube
        after[layer][row][col].nearby++
      }
    }
  }
  return after;
}

// add and remove could be combined into one function but i did it like this and it works
function remove (x,y,z,before,after=before) {
  if (!before[z][y][x].active) return before;
  runningTotal--;
  after[z][y][x].active = false;
  for (let layer = Math.max(z-1, 0); layer <= Math.min(z+1, before.length-1); layer++) {
    for (let row = Math.max(y-1, 0); row <= Math.min(y+1, before[0].length-1); row++) {
      for (let col = Math.max(x-1, 0); col <= Math.min(x+1, before[0][0].length-1); col++) {
        if (layer == z && row == y && col == x) continue;
        after[layer][row][col].nearby--
      }
    }
  }
  return after;
}