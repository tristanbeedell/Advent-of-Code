const fs = require('fs');

let input = fs.readFileSync('input.txt', 'utf-8');
let freq = 0;
input.split('\n').forEach(line => {
	num = parseInt(line);
	if (num){
		freq += num;
	}
})
console.log(freq);
