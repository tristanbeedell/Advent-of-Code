const fs = require("fs");
const text = fs.readFileSync("./input.txt", "utf-8");

let memory = text.split(',').map(opcode => parseInt(opcode));

memory[1] = 12;
memory[2] = 2;

for (let i = 0; i < memory.length; i+=4) {
	if (memory[i] == 1) {
		memory[memory[i+3]] = memory[memory[i+1]] + memory[memory[i+2]];
	} else if (memory[i] == 2) {
		memory[memory[i+3]] = memory[memory[i+1]] * memory[memory[i+2]];
	} else if (memory[i] == 99) {
		break;
	}
}

console.log(memory[0]);