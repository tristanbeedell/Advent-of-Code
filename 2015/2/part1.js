const fs = require('fs');

let data = fs.readFileSync('input.txt', 'utf-8');
let lines = data.split('\n');
let amt = 0;
lines.forEach(line => {
	let dim
	try {
		dim = line.match(/(\d+)x(\d+)x(\d+)/).splice(1,3);
	}
	catch (err) {
		return 0;
	}
	let sides = []
	sides[0] = dim[0]*dim[1];
	sides[1] = dim[1]*dim[2];
	sides[2] = dim[0]*dim[2];
	let smallest =  Math.min.apply(Math, sides);
	amt += (sides[0]+sides[1]+sides[2])*2+smallest;	
	console.log(dim, sides, smallest, amt);
})
console.log(amt);
