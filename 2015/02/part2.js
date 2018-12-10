const fs = require('fs');

let data = fs.readFileSync('input.txt', 'utf-8');
let lines = data.split('\n');
let amt = 0;
lines.forEach(line => {
	let dim;
	try {
		dim = line.match(/(\d+)x(\d+)x(\d+)/).splice(1,3);
	}
	catch (err) {
		return 0;
	}
	intify(dim);
	dim.sort((a, b) => parseInt(a) > parseInt(b));
	let wrap = 2*(dim[0]+dim[1]);
	let bow = dim[0]*dim[1]*dim[2];
	amt += bow+wrap;
	console.log(dim, bow, wrap)
})
console.log(amt);

function intify (array) {
	array.forEach(item => {
		array[array.indexOf(item)] = parseInt(item)
	})
}
