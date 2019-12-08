const fs = require("fs");
const text = fs.readFileSync("2019/06/input.txt", "utf-8");

let inputArr = text.split('\n');
let objNet = {};
let objArr = [];
inputArr.forEach(input => {
	points = input.split(')');
	objNet[points[1]] = {orbits: points[0]};
	objArr.push(points[1]);
})

function getOrigin(obj, track, transfers = 0) {
	center = objNet[obj]
	if (center) {
		objNet[obj]["distFrom"+track] = transfers-1;
		transfers++;
		return getOrigin(center.orbits, track, transfers)
	} else {
		return transfers
	}
}
getOrigin("SAN", "SAN")
getOrigin("YOU", "YOU")

min = Infinity;
objArr.forEach(obj => {
	totalDist = objNet[obj].distFromSAN + objNet[obj].distFromYOU;
	min = totalDist < min? totalDist:min;
})
console.log(min)