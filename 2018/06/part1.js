const fs = require('fs');
let input = fs.readFileSync('input.txt', 'utf-8').split('\n').map(v => v.split(',').map(Number));
let minX = input.reduce((a, b) => Math.min(a[0] || a, b[0]));
let minY = input.reduce((a, b) => Math.min(a[1] || a, b[1]));
let maxX = input.reduce((a, b) => Math.max(a[0] || a, b[0]));
let maxY = input.reduce((a, b) => Math.max(a[1] || a, b[1]));
values = {};
for (let y = minY; y <= maxY; y++) {
	for (let x = minX; x <= maxX; x++) {
		let vs = input.map(v => Math.abs(v[0] - x) + Math.abs(v[1] - y));
		let min = Math.min.apply(null, vs);
		let index;
		if (vs.filter(a => a == min).length == 1) {
			index = vs.indexOf(min).toString();
			values[index] = (values[index] || 0) + 1;
		}
	}
}
for (edge of [minY, maxY]) {
	for (let x = minX; x <= maxX; x++) {
		let vs = input.map(v => Math.abs(v[0] - x) + Math.abs(v[1] - edge));
		index = vs.indexOf(Math.min(...vs)).toString();
		values[index] = Infinity
	}
}
for (edge of [minX, maxX]) {
	for (let y = minY; y <= maxY; y++) {
		let vs = input.map(v => Math.abs(v[0] - edge) + Math.abs(v[1] - y));
		index = vs.indexOf(Math.min(...vs)).toString();
		values[index] = Infinity
	}
}
finite = Object.values(values).filter(v => v != Infinity)

console.log(finite.sort((a, b) => a < b)) // for some reason it doesn't sort them properly, but the answer will be somewhere near the top.
