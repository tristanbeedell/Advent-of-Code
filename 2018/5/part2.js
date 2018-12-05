const fs = require('fs');
let input = fs.readFileSync('input.txt', 'utf-8');
let exp = /(qQ|wW|eE|rR|tT|yY|uU|iI|oO|pP|aA|sS|dD|fF|gG|hH|jJ|kK|lL|zZ|xX|cC|vV|bB|nN|mM|Qq|Ww|Ee|Rr|Tt|Yy|Uu|Ii|Oo|Pp|Aa|Ss|Dd|Ff|Gg|Hh|Jj|Kk|Ll|Zz|Xx|Cc|Vv|Bb|Nn|Mm)/g;

function react(input) {
	while (input.match(exp)) {
		input = input.replace(exp, '')
	}
	return input
}

let best = Infinity;
for (let char of 'qwertyuiopasdfghjklzxcvbnm') {
	let inp = input.replace(new RegExp(char, 'ig'), '');
	let out = react(inp)
	best = Math.min(best, out.length)
}

console.log(best);
