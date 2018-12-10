const fs = require('fs');
const input = fs.readFileSync('input.txt', 'utf-8').split('\n')[0].split(' ').map(Number);

function parse(arr) {
	if (arr[0] == 0) {
		return ([2 + arr[1], arr.slice(2, 2 + arr[1])]);
	}
	let meta = []
	let pointer = 2;
	for (let i = 0; i < arr[0]; i++) {
		let child = parse(arr.slice(pointer, arr.length));
		pointer += child[0];
		meta = meta.concat(child[1]);
	}
	meta = meta.concat(arr.slice(pointer, pointer + arr[1]))
	return [pointer + arr[1], meta];
}

let v = parse(input)[1];
console.log(v.reduce((a, b) => a + b));
