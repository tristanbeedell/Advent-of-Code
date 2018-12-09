const fs = require('fs');
const input = fs.readFileSync('input.txt', 'utf-8').split('\n');

let counter = 0;
for (let str of input) {
	if (str.match(/(\w{2}).*\1/g) && str.match(/(\w)\w\1/g))
		counter++;
}
console.log(counter)
