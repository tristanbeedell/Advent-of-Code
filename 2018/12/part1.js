const fs = require('fs'); // file system
const input = fs.readFileSync(`${__dirname}/input.txt`, 'utf-8')	// read the input file
	.split('\n');	// split on lines

// get the initial state from the input
let state = input[0].slice('initial state: '.length);

let rules = {};

// extract all rules from input
for (const line of input.splice(2)) {
	rules[line.slice(0, 5)] = line.slice(9);
}

// to add extra pots as if there were endless pots
function expand () {
	state = state.replace(/^(\.+)?/, '.....');
	state = state.replace(/(\.+)?$/, '.....');
}

let zero = 5;
// add empty pots
expand();
console.log(Array(20-zero).join(' ')+state);

for (let i = 0; i < 20; i++){

	// create 'empty' array of '.'s
	const pots = Array(3).join('.').split('');

	state.split('').forEach((_, n) => {
		// get the section to look at of prev gen
		const sect = state.slice(n-2, n+3);
		if (sect.length !== 5) { return }

		// get the value of the matching rule
		let plant = rules[sect];
		if (!plant) { return }

		// replace the value in the next gen
		pots.push(plant);
	});
	// move the '0th pot' marker
	zero -= pots.indexOf('#') - 5;
	state = pots.join('');

	// add empty pots
	expand();
	console.log(Array(20-zero).join(' ')+state);
}

const result = state.split('').reduce((val, pot, index) => {
	return (Number(val) || 0) + (pot === '#' ? index - zero : 0);
})

console.log(result);