const fs = require('fs');

let input = fs.readFileSync('input.txt', 'utf-8');
let grid = {};

for (const line of input.split('\n')) {
	[rule,
		id,
		left,
		top,
		width,
		height] = line.match(/#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/).map(Number);
	for (let x = left; x < left + width; x++) {
		for (let y = top; y < top + height; y++) {
			grid[`${x},${y}`] = (grid[`${x},${y}`] || 0) + 1;
		}
	}
}

console.log(Object.values(grid).filter(v => v > 1).length);
