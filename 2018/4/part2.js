const fs = require('fs');

let input = fs.readFileSync('input.txt', 'utf-8').split('\n').sort((a, b) => val(a).getTime() - val(b).getTime());

function val(a) {
	let time = new Date(a.match(/\[(.*)\]/)[1]);
	return time;
}

let guards = {};
let id;
let start;
let shifts = []
for (let line of input) {
	let match = line.match(/#(\d+)/);
	if (match) {
		id = match[1];
		if (!guards[id])
			guards[id] = {};
		shifts.push(id);
	} else {
		if (line.includes('falls')) {
			start = val(line).getMinutes();
		} else if (line.includes('wakes')) {
			let end = val(line).getMinutes();
			for (time = start; time < end; time++) {
				guards[id][time] = (guards[id][time] || 0) + 1;
			}
		}
	}
}

let theid;
let themost = 0;
let theminute;
for (id in guards) {
	let thismost = Object.entries(guards[id]).sort((a, b) => b[1] - a[1])[0];
	if (!thismost) { continue }
	if (thismost[1] > themost) {
		theid = id;
		themost = thismost[1];
		theminute = Number(thismost[0])
	}
}

console.log(`#${theid} * minute ${theminute} = ${theid * theminute}, ${themost} times`)
