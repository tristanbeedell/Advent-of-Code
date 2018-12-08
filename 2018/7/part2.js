const fs = require('fs');
let rules = fs.readFileSync('input.txt', 'utf-8').split('\n');
steps = {};
for (let rule of rules) {
	[_, step1, step2] = rule.match(/Step (\w) must be finished before step (\w) can begin./);
	if (!steps[step1])
		steps[step1] = []
	if (!steps[step2])
		steps[step2] = []
	steps[step2].push(step1)
}

let elves = {};
for (let time = 0; Object.entries(steps).length > 0; time++) {
	if (elves[time]) {
		console.log(`step ${elves[time]} done`)
		remove(elves[time])
		delete elves[time];
	}
	let avaliable = Object.entries(steps).filter(v => v[1].length == 0).map(v => v[0]).sort();
	for (let i = 0; Object.entries(elves).length < 5 && i < avaliable.length; i++) {
		if (!Object.values(elves).some(v => v == avaliable[i])) {
			elves[time + timeof(avaliable[i])] = avaliable[i]
		}
	}
	console.log(time, Object.values(elves))
}

function timeof(step) {
	return 60 + '0ABCDEFGHIJKLMNOPQRSTUVWXYZ'.indexOf(step)
}

function remove(step) {
	delete steps[step];
	for (let s in steps) {
		steps[s] = steps[s].filter(v => v != step)
	}
}
