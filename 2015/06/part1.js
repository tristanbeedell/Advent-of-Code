const fs = require('fs');

function grid(size) {
	let lights = {};
	for (let y = 0; y <= size; y++) {
		for (let x = 0; x <= size; x++) {
			lights[`${x},${y}`] = false;
		}
		lights[`${y}n`] = '\n';
	}
	return lights;
}
lights = grid(1000);

function out() {
	return '\t' + Object.values(lights).join().replace(/true/g, '*').replace(/false/g, '_').replace(/,/g, '\t');
};

console.time('speed');
let counter = 0;
fs.readFileSync('input.txt', 'utf-8').split('\n').forEach(line => {
	[, state, x1, y1, x2, y2] = line.match(/(toggle|off|on) (\d+),(\d+) \w+ (\d+),(\d+)/);
	[x1, y1, x2, y2] = [x1, y1, x2, y2].map(Number);
	func = state == 'toggle' ? (v => !v) : state == 'on' ? (v => true) : (v => false);
	for (let y = y1; y <= y2; y++) {
		for (let x = x1; x <= x2; x++) {
			let b = lights[`${x},${y}`]
			let a = func(lights[`${x},${y}`])
			counter += !b && a ? 1 : b && !a ? -1 : 0;
			lights[`${x},${y}`] = a;
		}
	}
});
console.log(counter);
console.timeEnd('speed');
