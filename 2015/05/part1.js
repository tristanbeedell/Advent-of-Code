const fs = require('fs');
const input = fs.readFileSync('input.txt', 'utf-8').split('\n');

let counter = 0;
for (let str of input) {
	if ((str.match(/(a|e|i|o|u)/g) || []).length >= 3 &&
		str.match(/(\w)\1/g) &&
		!str.match(/(ab|cd|pq|xy)/))
		counter++;
}
console.log(counter)
