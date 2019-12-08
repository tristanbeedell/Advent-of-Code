const fs = require("fs");
const text = fs.readFileSync("2019/06/input.txt", "utf-8");

let inputArr = text.split('\n');
let objNet = {};
let objArr = [];
inputArr.forEach(input => {
	points = input.split(')');
	objNet[points[1]] = points[0];
	objArr.push(points[1]);
})
console.log(objNet);
total = 0;
let i;
objArr.forEach(obj => {
	i=0
	getOrigin(obj)
	total+=i
});
console.log(total)

function getOrigin(obj) {
	center = objNet[obj]
	if (center) {
		i++
		return getOrigin(center)
	} else {
		return i
	}
}