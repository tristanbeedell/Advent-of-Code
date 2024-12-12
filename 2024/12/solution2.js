
const input = (await Bun.file(Bun.argv[2]).text()).trim()

let map = input.split("\n")

const dirs = [[-1,0], [0,-1], [1,0], [0, 1]];
const height = map.length;
const width = height;

const key = (x,y) => x + y*width;
const vkey = (x,y) => y + x*height;
const visited = new Set();

function search(x,y) {
  if (visited.has(key(x,y))) {
    return {area: 0, hsides: new Set()}
  }
  visited.add(key(x,y))
  const letter = map[y][x]
  let area = 1
  let hsides = new Set()
  for (const [dx, dy] of dirs) {
    const nletter = map[y + dy]?.[x + dx];
    if (letter !== nletter) {
      if (dx === 0) {
        hsides.add({y: y+dy/2, key: key(x,y)})
      }
      continue
    }
    const n = search(x + dx, y + dy)
    area += n.area
    hsides = hsides.union(n.hsides)
  }

  return {area, hsides}
}

const regions = [];

for (let y = 0; y < height; y++) {
  for (let x = 0; x < width; x++) {
    if (visited.has(key(x,y))) continue
    regions.push(search(x,y))
  }
}


let cost = 0;
for (const {area, hsides} of regions) {
  // hacky filter of all perimeter nodes to extract adjacent
  const horizontal = Array.from(hsides)
    .sort((a, b) => a.key - b.key)
    .sort((a, b) => a.y - b.y)
    .filter(({y, key}, i, a) => a[i-1]?.key + 1 !== key || a[i-1]?.y !== y)
    .length

  // there's always an equal amount of horizontal and vertical sides
  cost += area * (horizontal * 2)
}

console.log(cost)


