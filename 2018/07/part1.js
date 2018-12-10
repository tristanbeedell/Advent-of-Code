const fs = require('fs');
let rules = fs.readFileSync('input.txt', 'utf-8').split('\n');
steps = [];
for (let rule of rules) {
	[_, step1, step2] = rule.match(/Step (\w) must be finished before step (\w) can begin./);
	if (!steps[step1])
		steps[step1] = []
	if (!steps[step2])
		steps[step2] = []
	steps[step2].push(step1)
}
let ans = '';

while (Object.entries(steps).length > 0) {
	let step = Object.entries(steps).filter(v => v[1].length == 0).map(v => v[0]).sort()[0]
	delete steps[step];
	for (let step_ in steps) {
		steps[step_] = steps[step_].filter(v => v != step)
	}
	ans += step
}
console.log(ans)
