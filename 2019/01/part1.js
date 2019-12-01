const fs = require('fs');

let input = fs.readFileSync('input.txt', 'utf-8');
let totalFuel = 0;
input.split('\n').forEach(line => {
	num = parseInt(line);
	if (num){
		totalFuel += Math.floor(num/3)-2;
	}
});
console.log(totalFuel);
