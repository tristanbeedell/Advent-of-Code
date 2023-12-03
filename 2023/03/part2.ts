enum LogLevel {
	Answer,
	Info,
	Debug,
}
const LOG_LEVEL = LogLevel.Debug;

const print = (level: keyof typeof LogLevel, msg: string) => {
	if (LogLevel[level] <= LOG_LEVEL) {
		console.log(level+': '+msg);
	}
}

const file = Bun.file("input.txt");

const input = await file.text();

function* findGears (schematic: string[]) {
	const matcher = /\*/g;

	for (const i in schematic) {
		const line = schematic[i];
		for (let res = matcher.exec(line); res !== null; res = matcher.exec(line)) {
			const index = matcher.lastIndex - 1;
			const end = matcher.lastIndex - 1;
			print('Debug',`[${Number(i)+1},${index+1}]`);
			yield {
				line: Number(i),
				index,
			};
		}
	}
}

interface Match {
	line: number,
	index: number,
}

function neighbours (schematic: string[], match: Match): number[] {
	const lastCol = schematic[0].length - 1;
	const lastRow = schematic.length - 1;

	function inbounds(x,y) {
		return x >= 0 && y >= 0 && x <= lastCol && y <= lastRow;
	}

	const matches = [];
	
	for (let y of [match.line-1, match.line, match.line+1]) {
		let left = match.index-1;
		while (inbounds(left,y) && /[0-9]/.test(schematic[y][left])) {
		     left--;
		};
		left = Math.max(left, 0);
		let right = match.index+1;
		while (inbounds(right,y) && /[0-9]/.test(schematic[y][right])) {
			right++;
		};
		right = Math.min(right, lastCol+1);
		
		const substr = schematic[y].slice(left,right);
		const matcher = /[0-9]+/g;
		for (let res = matcher.exec(substr); res !== null; res = matcher.exec(substr)) {
			matches.push(...res)
		}
	}

	print('Debug', `neighbours: ${matches}`);
	
	return matches.map(Number);
	
}

function main(): void {
	const lines = input.trim().split("\n");
	for (const line of lines) {
		print('Info', line);
	}
	let total = 0;
	for (const match of findGears(lines)) {
		const nums = neighbours(lines,match)
		if (nums.length === 2) {
			const ratio = nums[0] * nums[1];
			print('Debug', `adding ${ratio}`);
			total += ratio;
		}
	}

	print('Answer', total);
}

main();

// too low: 83445843
