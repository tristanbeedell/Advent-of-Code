const input = (await Bun.file(Bun.argv[2]).text()).trim()

const map = input.split("\n")

const rotateL = ({x,y}) => ({x: -y, y: x,});
const rotateR = ({x,y}) => ({x: y, y: -x,});
const add = (a, b) => ({x: a.x + b.x, y: a.y + b.y});

const height = map.length;
const width = height;

const key = ({x,y}, dir) => (dir.x + (dir.y * 2)) * (width * height) + x + y*width;
const visited = new Set();

let end, pos;
for (let y = 0; y < map.length; y++) {
  const endx = map[y].indexOf("E")
  if (endx !== -1) {end = {x: endx, y}}
  const startx = map[y].indexOf("S")
  if (startx !== -1) {pos = {x: startx, y}}
}

let dir = {x: 1, y: 0};
console.log(end, pos)

function search(pos, dir) {
  if (visited.has(key(pos, dir))) {
    return {area: 0, perimeter: 0}
  }
  if (map[y][x] === "#") {
    return null
  }
  if (map[y][x] === "E") {
    return 0
  }
  search(add(pos,dir), dir)
}


