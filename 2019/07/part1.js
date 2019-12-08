const fs = require("fs");
const text = fs.readFileSync("2019/07/input.txt", "utf-8");
  
let memory = text.split(',').map(opcode => parseInt(opcode));

function valueOf(index, paramMode) {
	return paramMode == "0" ? memory[memory[index]] : memory[index];
}

function fiveDig(value) {
	return value.toString().length < 5 ? fiveDig("0" + value) : value.toString();
}

function run(phase, input) {
	let inputSequence = [phase, input];
	let inputNo = 0;
	let outputSequence = []
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
			userInput = inputSequence[inputNo % inputSequence.length];
			inputNo++;
			// console.log("IN "+userInput);
			memory[memory[i+1]] = userInput;
			i+=2;
		} else if (opcode == '04') {
			outputValue = valueOf(i+1, instruction[2])
			// console.log("OUT "+outputValue);
			outputSequence.push(outputValue);
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
			// console.log("HLT")
			return outputSequence;
		}
	}
}

function test(phaseSequence) {
	let output = [0]
	phaseSequence.forEach(phase => {
		output = run(phase, output[0]);
	})
	return output[0];
}

function arrayIsUnique(myArray) {
	return myArray.length === new Set(myArray).size;
}

maxSignal = 0;
// inefficient af but idk how else to do it
for (let phase = 0; phase < Math.pow(5, 5); phase++){
	phaseSequence = [phase % 5, Math.floor(phase/5)%5, Math.floor(phase/25)%5, Math.floor(phase/125)%5, Math.floor(phase/625)%5]
	if (!arrayIsUnique(phaseSequence)) {
		continue;
	}
	if (phaseSequence == [1, 0, 4, 3, 2]) {
		console.log(phaseSequence);
	}
	thrustSignal = test(phaseSequence);
	if (maxSignal < thrustSignal) {
		maxSignal = thrustSignal;
	}
}
console.log(maxSignal);