// input
let players = 465;
let last = 71498;

// part 1 : short and extreemly inefficient.
console.time('speed');

let circle = [0];
let pointer = 0;
let elves = [];
elves.length = players;
elves.fill(0);
for (let i = 1; i < last; i++) {
	if (i % 23 == 0) {
		let index = pointer - 7 + (pointer - 7 < 0 ? circle.length : 0);
		elves[i % players] += i + circle[index];
		circle.splice(index, 1);
		pointer = index;
	} else {
		circle.splice(pointer + 2 - (pointer + 2 > circle.length ? circle.length : 0), 0, i);
		pointer = circle.indexOf(i);
	}
	// console.log(circle.join());
}
console.log(Math.max.apply(null, elves));

console.timeEnd('speed');
