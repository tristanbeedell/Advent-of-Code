enum LogLevel {
	Answer,
	Info,
	Debug,
}
const LOG_LEVEL = LogLevel.Info;

const print = (level: keyof typeof LogLevel, msg: string) => {
	if (LogLevel[level] <= LOG_LEVEL) {
		console.log(level+': '+msg);
	}
}

const file = Bun.file("input.txt");

const input = await file.text();

function* findNumbers (schematic: string[]) {
	const matcher = /[0-9]+/g;

	for (const i in schematic) {
		const line = schematic[i];
		for (let res = matcher.exec(line); res !== null; res = matcher.exec(line)) {
			const start = matcher.lastIndex - res[0].length;
			const end = matcher.lastIndex - 1;
			print('Debug',`"${res[0]}" at [${start}-${end}]`);
			yield {
				line: Number(i),
				index: start,
				len: res[0].length,
				num: Number(res[0])
			};
		}
	}
}

interface Match {
	line: number,
	index: number,
	len: number,
	num: number,
}

function isPartNumber (schematic: string[], match: Match): boolean {
	const width = schematic[0].length - 1;
	const height = schematic.length - 1;

	let surroundings = "";

	const start = Math.max(match.index-1, 0);
	const end = Math.min(match.index + match.len, width);
	
	if (match.line > 0) {
		surroundings += schematic[match.line - 1].slice(start, end + 1) + " ";
	}

	if (match.index > 0) {
		surroundings += schematic[match.line][start] + " ";
	}

	if (match.index + match.len + 1 < width) {
		surroundings += schematic[match.line][end] + " ";
	}

	if (match.line < height) {
		surroundings += schematic[match.line + 1].slice(start, end + 1) + " ";
	}

	print('Debug', `surroundings: ${surroundings}`)

	return /[^0-9. ]/g.test(surroundings);
}

function main(): void {
	const lines = input.trim().split("\n");
	for (const line of lines) {
		print('Info', line);
	}
	const partNumbers = [];
	for (const match of findNumbers(lines)) {
		if (isPartNumber(lines,match)) {
			partNumbers.push(match.num);
		}
	}
	print('Debug', `Part Numbers: ${partNumbers}`)
	print('Answer', `${partNumbers.reduce((a,b)=>a+b)}`)
}

main();
