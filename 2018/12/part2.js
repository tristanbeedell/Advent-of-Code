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
function expand (s) {
	let r = s.replace(/^(\.+)?/, '.....');
	r = r.replace(/(\.+)?$/, '.....');
	return r;
}

let zero = 5;
// add empty pots
state = expand(state);

let done = false;
for (var i = 0; i < 250; i++){


	if (done) {
		var gen = i;
		break;
	}

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

	// if the pattern is repeating. process is done.
	done = expand(pots.join('')) === state;

	// store the generation with extra pots.
	state = expand(pots.join(''));


	// console.log(Array(20-zero).join(' ')+state);	// output with pot 0 aligned
	// console.log(state);	// output misaligned

}

// calculate the value of last gen
const result = state.split('').reduce((val, pot, index) => {
	return (Number(val) || 0) + (pot === '#' ? index - zero : 0);
})

console.log(result + (50000000000 - gen) * state.match(/#/g).length)