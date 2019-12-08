const fs = require("fs");
const text = fs.readFileSync("2019/07/input.txt", "utf-8");
  
let instructions = text.split(',').map(opcode => parseInt(opcode));

function fiveDig(value) {
	return value.toString().length < 5 ? fiveDig("0" + value) : value.toString();
}

function IntcodeAmp(verbose) {
	this.verbose = verbose;

	this.reset = function(){
		this.active = false;
		this.memory = instructions.slice();
		this.memoryAdress = 0;
		if (this.verbose) {
			console.log("RESET");
		}
	}
	this.reset();

	this.valueOf = function(index, paramMode) {
		return paramMode == "0" ? this.memory[this.memory[index]] : this.memory[index];
	}

	this.add = function (a, b){
		this.memory[this.memory[this.memoryAdress+3]] = 
			this.valueOf(this.memoryAdress+1, b) + 
			this.valueOf(this.memoryAdress+2, a);
		this.memoryAdress+=4;
	}

	this.mult = function (a, b){
		this.memory[this.memory[this.memoryAdress+3]] = 
			this.valueOf(this.memoryAdress+1, b) *
			this.valueOf(this.memoryAdress+2, a);
		this.memoryAdress+=4;
	}

	this.input = function () {
		let userInput = this.inputSequence[this.inputNo];
		this.inputNo++;
		if (this.verbose){
			console.log("IN "+userInput);
		}
		this.memory[this.memory[this.memoryAdress+1]] = userInput;
		this.memoryAdress+=2;
	}

	this.jmpIfNot0 = function(a, b) {
		if (this.valueOf(this.memoryAdress+1, b) != 0) {
			this.memoryAdress = this.valueOf(this.memoryAdress+2, a)
		} else {
			this.memoryAdress+=3;
		}
	}

	this.jmpIf0 = function(a, b) {
		if (this.valueOf(this.memoryAdress+1, b) == 0) {
			this.memoryAdress = this.valueOf(this.memoryAdress+2, a)
		} else {
			this.memoryAdress+=3;
		}
	}

	this.jmpIfLessThan = function(a, b) {
		this.memory[this.memory[this.memoryAdress+3]] = 
			this.valueOf(this.memoryAdress+1, b) < 
			this.valueOf(this.memoryAdress+2, a) ? 1 : 0;
		this.memoryAdress+=4;
	}
	
	this.jmpIfEqual = function(a, b) {
		this.memory[this.memory[this.memoryAdress+3]] = 
			this.valueOf(this.memoryAdress+1, b) ==
			this.valueOf(this.memoryAdress+2, a) ? 1 : 0;
		this.memoryAdress+=4;
	}

	this.run = function (inputSequence){
		this.active = true;
		this.inputSequence = inputSequence;
		this.inputNo = 0;
		while (true) {
			instruction = fiveDig(this.memory[this.memoryAdress]);
			opcode = instruction.slice(3);
			if (opcode == '01') {
				this.add(instruction[1], instruction[2]);
			} else if (opcode == '02') {
				this.mult(instruction[1], instruction[2])
			} else if (opcode == '03') {
				if (this.inputNo >= this.inputSequence.length) {
					return "input required";
				}
				this.input();
			} else if (opcode == '04') {
				outputValue = this.valueOf(this.memoryAdress+1, instruction[2])
				this.memoryAdress+=2;
				return outputValue;
			} else if (opcode == '05') {
				this.jmpIfNot0(instruction[1], instruction[2]);
			} else if (opcode == '06') {
				this.jmpIf0(instruction[1], instruction[2]);
			} else if (opcode == '07') {
				this.jmpIfLessThan(instruction[1], instruction[2]);
			} else if (opcode == '08') {
				this.jmpIfEqual(instruction[1], instruction[2]);
			} else if (opcode == '99') {
				this.reset();
				return;
			}
		}
	}
}
amps = [
	new IntcodeAmp(),
	new IntcodeAmp(),
	new IntcodeAmp(),
	new IntcodeAmp(),
	new IntcodeAmp()
]

function test(phaseSequence) {
	output = 0;

	for (let i = 0; i < phaseSequence.length; i++){
		amps[i].run([phaseSequence[i]]);
	}

	do {
		for (amp of amps) {
			let ampOut = amp.run([output]);
			if (!ampOut) {
				break;
			} else {
				output = ampOut;
			}
		}
	} while (amps[0].active)

	for (amp of amps) {
		amp.reset();
	}

	return output;
}

maxSignal = 0;
// inefficient af but idk how else to do it
function arrayIsUnique(myArray) {
	return myArray.length === new Set(myArray).size;
}
for (let phase = 0; phase < Math.pow(5, 5); phase++){
	phaseSequence = [(phase%5)+5,
		(Math.floor(phase/5)%5)+5,
		(Math.floor(phase/25)%5)+5, 
		(Math.floor(phase/125)%5)+5, 
		(Math.floor(phase/625)%5)+5]
	if (!arrayIsUnique(phaseSequence)) {
		continue;
	}
	thrustSignal = test(phaseSequence);
	if (maxSignal < thrustSignal) {
		maxSignal = thrustSignal;
	}
}
console.log(maxSignal);