const fs = require('fs');

let input = fs.readFileSync(`${__dirname}/input.txt`, 'utf-8').split('\n').sort((a, b) => val(a).getTime() - val(b).getTime());

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

function sleps(guard) {
	try {
		return Object.values(guard[1]).reduce((a, b) => a + b) / shifts.filter(v => v == guard[0]).length;
	} catch (err) {
		return 0;
	}
}
id = Object.entries(guards).sort((a, b) => sleps(b) - sleps(a))[0][0];
let minute = Number(Object.entries(guards[id]).sort((a, b) => b[1] - a[1])[0][0]);

console.log(`#${id} * minute ${minute} = ${id * minute}`)
