// puzzle input
const inputMin = 172930;
const inputMax = 683082;

amt = 0;
for (let i = inputMin; i < inputMax; i++) {
	adjChars = false;
	increasing = false;
	let prev;
	for (char of String(i)) {
		if (char == prev) {adjChars = true}
		if (char < prev) {increasing = true}
		prev = char;
	}

	if (adjChars && !increasing) {amt++;console.log(i)}
}
console.log(amt);