const fs = require("fs");
const text = fs.readFileSync("./input.txt", "utf-8");

for (let noun = 0; noun < text.split(',').length; noun++){

	for (let verb = 0; verb < text.split(',').length; verb++){

		let memory = text.split(',').map(opcode => parseInt(opcode));

		memory[1] = noun;
		memory[2] = verb;

		for (let i = 0; i < memory.length; i+=4) {
			if (memory[i] == 1) {
				memory[memory[i+3]] = memory[memory[i+1]] + memory[memory[i+2]];
			} else if (memory[i] == 2) {
				memory[memory[i+3]] = memory[memory[i+1]] * memory[memory[i+2]];
			} else if (memory[i] == 99) {
				break;
			}
		}

		if (memory[0] == 19690720){
			console.log(noun, verb);
		}
	}
}