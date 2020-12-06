const fs = require('fs');

const data = fs.readFileSync('input.txt', 'utf-8');
const lines = data.split('\n');

let max = 0
// who really needs semicolons anyway
for (let i = 0; i < lines.length; i++) {
  let line = lines[i]
  let rowCode = line.substring(0, 7).replace(/F/g, "0").replace(/B/g, "1")
  let colCode = line.substring(7).replace(/L/g, "0").replace(/R/g, "1")

  // another excuse to flex that recursive muscle
  function getIndexFromBSP (BSP, min, max) {
    if (BSP.length != 1) { 
      [min, max] = getIndexFromBSP (BSP.substring(0, BSP.length-1), min, max)
    }

    switch (BSP[BSP.length-1]) {
      case '0':
        max = Math.floor((min + max) / 2)
        break
      case '1':
        min = Math.ceil((min + max) / 2)
        break
      default:
        console.log("something went wrong")
    }

    return [min, max]
  }
  let row = getIndexFromBSP(rowCode, 0, 127)[0]
  let col = getIndexFromBSP(colCode, 0, 7)[0]

  let seatID = (row * 8) + col

  max = seatID > max ? seatID : max
}
console.log(max)