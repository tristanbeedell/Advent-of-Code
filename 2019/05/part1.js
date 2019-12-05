const fs = require("fs");
const text = fs.readFileSync("2019/05/input.txt", "utf-8");
const userInput = 5;
  
let memory = text.split(',').map(opcode => parseInt(opcode));

function valueOf(index, paramMode) {
	return paramMode == "0" ? memory[memory[index]] : memory[index];
}

function fiveDig(value) {
	return value.toString().length < 5 ? fiveDig("0" + value) : value.toString();
}

let i = 0;
while (true) {
	instruction = fiveDig(memory[i]);
	opcode = instruction.slice(3);
	if (opcode == '01') {
		memory[memory[i+3]] = valueOf(i+1, instruction[2]) + valueOf(i+2, instruction[1]);
		i+=4;
	} else if (opcode == '02') {
		memory[memory[i+3]] = valueOf(i+1, instruction[2]) * valueOf(i+2, instruction[1]);
		i+=4;
	} else if (opcode == '03') {
		console.log("IN "+userInput);
		memory[memory[i+1]] = userInput;
		i+=2;
	} else if (opcode == '04') {
		console.log("OUT "+valueOf(i+1, instruction[2]));
		i+=2;
	} else if (opcode == '05') {
		if (valueOf(i+1, instruction[2]) != 0) {
			i = valueOf(i+2, instruction[1])
		} else {
			i+=3;
		}
	} else if (opcode == '06') {
		if (valueOf(i+1, instruction[2]) == 0) {
			i = valueOf(i+2, instruction[1])
		} else {
			i+=3;
		}
	} else if (opcode == '07') {
		memory[memory[i+3]] = valueOf(i+1, instruction[2]) < valueOf(i+2, instruction[1]) ? 1 : 0;
		i+=4;
	} else if (opcode == '08') {
		memory[memory[i+3]] = valueOf(i+1, instruction[2]) == valueOf(i+2, instruction[1]) ? 1 : 0;
		i+=4;
	} else if (opcode == '99') {
		console.log("HLT")
		break;
	}
}
