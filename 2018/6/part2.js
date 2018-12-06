const fs = require('fs');
let input = fs.readFileSync('input.txt', 'utf-8').split('\n').map(v => v.split(',').map(Number));
let minX = input.reduce((a, b) => Math.min(a[0] || a, b[0]));
let minY = input.reduce((a, b) => Math.min(a[1] || a, b[1]));
let maxX = input.reduce((a, b) => Math.max(a[0] || a, b[0]));
let maxY = input.reduce((a, b) => Math.max(a[1] || a, b[1]));
let amt = 0
for (let y = minY; y <= maxY; y++) {
	for (let x = minX; x <= maxX; x++) {
		let total = input.reduce((a, b) => (typeof a == 'number' ? a : dist([x, y], a)) + dist([x, y], b));
		amt += total < 10000 ? 1 : 0;
	}
}

function dist(c1, c2) {
	return Math.abs(c1[0] - c2[0]) + Math.abs(c1[1] - c2[1])
}

console.log(amt)
