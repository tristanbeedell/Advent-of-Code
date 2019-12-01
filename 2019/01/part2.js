const fs = require('fs');

let input = fs.readFileSync('input.txt', 'utf-8');
let totalFuel = 0;
input.split('\n').forEach(line => {
	let num = parseInt(line);
	if (!num) {
		console.log(`num not found in ${line}`);
		return;
	}
	let moduleFuel = num;
	while (true) {
		thisFuel = Math.floor(moduleFuel/3)-2;
		if (thisFuel <= 0) { break }
		moduleFuel = thisFuel;
		totalFuel += moduleFuel;
	}
});
console.log(totalFuel);
