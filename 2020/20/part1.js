const fs = require('fs');
const input = fs.readFileSync('./input.txt', 'utf-8');

const inputTiles = input.split('\n\n');

// it is implied that the image is a square, which makes it far simpler.
const sideLength = Math.sqrt(inputTiles.length);
const tileSize = 9
let allBorders = new Map();
console.log(sideLength);
let tiles = [];
inputTiles.forEach(inputTile => {
  tileLines = inputTile.split('\n');
  let tileID = tileLines[0].slice(5, 9);
  let tileData = tileLines.slice(1)
  let borders = [
    tileData[0], 
    tileData[tileSize],
    tileData.reduce((a,b)=>a+b[0], ''),
    tileData.reduce((a,b)=>a+b[tileSize], '')
  ];
  borders.forEach(border=>{
    if (!allBorders.has(border)) {
      allBorders.set(border, 1)
    } else {
      allBorders.set(border, allBorders.get(border) + 1)
    }
  })
  tiles.push({tileID, borders})
})

function reverseString(str) {
  return (str === '') ? '' : reverseString(str.substr(1)) + str.charAt(0);
}

let runningTotal = 1;
tiles.forEach(tile => {
  if (tile.borders.reduce((a, border) => a + allBorders.get(border) + (allBorders.get(reverseString(border))||0), -4) == 2) {
    console.log(tile.tileID)
    runningTotal *= tile.tileID
  }
})
console.log(runningTotal)