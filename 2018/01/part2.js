const fs = require('fs');

let input = fs.readFileSync('input.txt', 'utf-8');
let freq = 0;
let history = [0];
found = false;
while (!found) {
	for (let line of input.split('\n')) {
		num = parseInt(line);
		if (num) {
			freq += num;
		}
		if (history.includes(freq)) {
			found = true;
			break;
		} else {
			history.push(freq);
		}
	}
}
console.log(freq)
