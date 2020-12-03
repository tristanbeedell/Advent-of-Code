const fs = require('fs');

const data = fs.readFileSync('input.txt', 'utf-8');
const lines = data.split('\n');

console.log()
const width = lines[0].length
// lets do it recursively why not
function trees(x, y, slopex, slopey) {
  // escape case : bottom row
  if (y >= lines.length - 1) { 
    return lines[y][x % width]=="#"
  }
  // haha javascript bool to int type casting go brrr
  return (lines[y][x % width]=="#") + trees(x+slopex, y+slopey, slopex, slopey)
}

// got lucky with this star lol
console.log(trees(0,0,1,1)
*trees(0,0,3,1)
*trees(0,0,5,1)
*trees(0,0,7,1)
*trees(0,0,1,2))