
const input = (await Bun.file(Bun.argv[2]).text()).trim()

let map = input.split("\n")

const dirs = [[-1,0], [1,0], [0, -1], [0, 1]];
const height = map.length;
const width = height;

const key = (x,y) => x + y*width;
const visited = new Set();

function search(x,y) {
  if (visited.has(key(x,y))) {
    return {area: 0, perimeter: 0}
  }
  visited.add(key(x,y))
  const letter = map[y][x]
  let perimeter = 0
  let area = 1
  for (const [dx, dy] of dirs) {
    const nletter = map[y + dy]?.[x + dx];
    if (letter !== nletter) {
      perimeter += 1
      continue
    }
    const n = search(x + dx, y + dy)
    area += n.area
    perimeter += n.perimeter
  }

  return {area, perimeter}
}

const regions = [];

for (let y = 0; y < height; y++) {
  for (let x = 0; x < width; x++) {
    if (visited.has(key(x,y))) continue
    regions.push(search(x,y))
  }
}

let cost = 0
for (const {area, perimeter} of regions) {
  cost += area * perimeter
}
console.log(cost)


