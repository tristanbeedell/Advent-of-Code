const inputMin = 172930;
const inputMax = 683082;


amt = 0;
for (let i = inputMin; i < inputMax; i++) {
	adjChars = 1;
	pair = false;
	decreasing = false;
	let prev;
	for (char of String(i)) {
		if (char == prev) {
			adjChars++;
		} else if (adjChars == 2) {
			pair = true;
		} else {adjChars = 1}
		
		if (char < prev) {decreasing = true}
		prev = char;
	}

	if (adjChars == 2) {
		pair = true;
	}

	if (pair && !decreasing) {amt++;console.log(i)}
}
console.log(amt);