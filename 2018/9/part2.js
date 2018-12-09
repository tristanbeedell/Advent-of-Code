// input
let players = 465;
let last = 7149800;

// part 2 : long but very efficient.

class Marble {
	constructor(data) {
		this.data = data;
		this.next = this;
		this.prev = this;
	}
}

// linked list
class Circle {
	constructor() {
		this.length = 0;
		this.head = null;
	}

	add(data, head) {
		head = head || this.head;
		const marble = new Marble(data);
		if (head) {
			marble.prev = head;
			marble.next = head.next;
			marble.prev.next = marble;
			marble.next.prev = marble;
		}
		this.length++;
		this.head = marble;
		return marble;
	}

	remove(marble) {
		marble = marble || this.head;
		marble.prev.next = marble.next;
		marble.next.prev = marble.prev;
		this.length--;
		this.head = marble.next;
		return this.length;
	}

	moveHead(amt) {
		for (let i = 0; i < Math.abs(amt); i++) {
			this.head = amt > 0 ? this.head.next : this.head.prev;
		}
		return this.head;
	}

	print() {
		let out = `\x1b[32m${this.head.data.toString()}\x1b[0m, `
		for (let i = 1; i < this.length; i++) {
			out += `${this.moveHead(1).data.toString()}, `
		}
		this.moveHead(1);
		console.log(out)
	}
}

console.time('speed');

circle = new Circle();
circle.add(0);

// initialise elves with scores of 0
let elves = [];
elves.length = players;
elves.fill(0);

// do all the marbles
for (let i = 1; i <= last; i++) {
	if (i % 23 == 0) {
		circle.moveHead(-7);
		elves[i % players] += circle.head.data + i;
		circle.remove();
	} else {
		circle.moveHead(1);
		circle.add(i);
	}
	// circle.print();
}
console.log(Math.max.apply(null, elves));

console.timeEnd('speed')
