const fs = require('fs');

let input = fs.readFileSync('input.txt', 'utf-8');
let grid = {};
let claims = []

for (let line of input.split('\n')) {
	[rule,
		id,
		left,
		top,
		width,
		height] = line.match(/#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/).map(Number);
	claims[id] = true;
	for (let x = left; x < left + width; x++) {
		for (let y = top; y < top + height; y++) {
			if (grid[`${x},${y}`]) {
				claims[grid[`${x},${y}`]] = false;
				claims[id] = false;
			}
			grid[`${x},${y}`] = id;
		}
	}
}
console.log(Object.entries(claims).filter(v => v[1])[0][0]);
