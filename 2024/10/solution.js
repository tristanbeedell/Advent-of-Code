
const input = (await Bun.file("input.txt").text()).trim()

const rows = [[]];

const trailheads = [];

for (let i = 0, x = 0, y = 0; i < input.length; i++) {
  if (input[i] == "\n") {
    rows.push([]);
    y++;
    x = 0;
    continue;
  }
  const alt = parseInt(input[i]);
  rows[y].push(alt);
  if (alt == 0) {
    trailheads.push({x,y})
  }
  x++;
}

const summitChart = Array.from({length: rows.length}, () => Array.from({length: rows.length}, () => (new Set())))

function findSummits({x, y}) {
  if (summitChart[y][x].size > 0) {
    return summitChart[y][x]
  }
  if (rows[y][x] == 9) {
    summitChart[y][x].add(x + y * rows.length)
    return summitChart[y][x]
  }
  if (x != 0               && rows[y][x-1] - rows[y][x] == 1) {
    summitChart[y][x] = summitChart[y][x].union(findSummits({y, x: x - 1}))
  }
  if (x != rows.length - 1 && rows[y][x+1] - rows[y][x] == 1) {
    summitChart[y][x] = summitChart[y][x].union(findSummits({y, x: x + 1}))
  }
  if (y != 0               && rows[y-1][x] - rows[y][x] == 1) {
    summitChart[y][x] = summitChart[y][x].union(findSummits({y: y-1, x}))
  }
  if (y != rows.length - 1 && rows[y+1][x] - rows[y][x] == 1) {
    summitChart[y][x] = summitChart[y][x].union(findSummits({y: y+1, x}))
  }
  return summitChart[y][x]
}

let sum = 0;
for (const trailhead of trailheads) {
  const summits = findSummits(trailhead)
  sum += summits.size
}

console.log(sum)

