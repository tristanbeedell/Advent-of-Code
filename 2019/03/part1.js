const fs = require('fs');
const text = fs.readFileSync("./2019/03/input.txt", "utf-8");

let lineIns = text.split('\n').map(line => line.split(','))
let linePoints = [];

for (let line = 0; line < 2; line++){
	let points = [[0,0]];
	for (let i = 0; i < lineIns[line].length; i++){
		let segment = lineIns[line][i];
		let dist = parseInt(segment.slice(1));
		let axis = ((segment[0] == "R") || (segment[0] == "L")) ? 0 : 1;
		let dir = ((segment[0] == "R") || (segment[0] == "U")) ? 1 : -1;
		let coord = points[i];
		coord[axis] += dir * dist;
		coord.axis = axis;
		points.push(coord.slice());
	}
	linePoints.push(points);
}

let closest = Infinity;
for (let i = 0; i < linePoints[0].length-1; i++) {
	let segment0 = linePoints[0].slice(i, i+2);
	let axis0 = linePoints[0][i].axis;
	segment0.sort((a, b) => a[(axis0+1)%2] - b[(axis0+1)%2]);
	for (let j = 0; j < linePoints[1].length-1; j++) {
		let axis1 = linePoints[1][j].axis;
		if (axis0 == axis1) continue;
		let segment1 = linePoints[1].slice(j, j+2);
		segment1.sort((a, b) => a[(axis1+1)%2] - b[(axis1+1)%2]);
		if (segment0[0][axis0] >= segment1[0][axis0] && segment0[1][axis0] <= segment1[1][axis0] &&
			segment1[0][axis1] >= segment0[0][axis1] && segment1[1][axis1] <= segment0[1][axis1]) {
			let cross = Math.abs(segment0[0][axis0]) + Math.abs(segment1[0][axis1]);
			closest = closest < cross ? closest : cross;
		}
	}
}
console.log(closest);
