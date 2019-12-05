// NOT WORKING: I gave up on this approach. too much to think about

const fs = require('fs');
const text = fs.readFileSync("./2019/03/input.txt", "utf-8");
// `R75,D30,R83,U83,L12,D49,R71,U7,L72
// U62,R66,U55,R34,D71,R55,D58,R83`;

let lineIns = text.split('\n').map(line => line.split(','))
let linePoints = [];

for (let line = 0; line < 2; line++){
	let points = [[0,0]];
	for (let i = 0; i < lineIns[line].length; i++){
		let segment = lineIns[line][i];
		let dist = parseInt(segment.slice(1));
		let axis = ((segment[0] == "R") || (segment[0] == "L")) ? 0 : 1;
		let dir = ((segment[0] == "R") || (segment[0] == "U")) ? 1 : -1;
		let coord = points[i].slice();
		coord[axis] += dir * dist;
		coord.axis = axis;
		points.push(coord);
	}
	linePoints.push(points);
}
let line0Dist = 0;
let line1Dist = 0;
for (let i = 0; i < linePoints[0].length-1; i++) {
	let segment0 = linePoints[0].slice(i, i+2);
	let axis0 = linePoints[0][i].axis;
	segment0.sort((a, b) => a[(axis0+1)%2] - b[(axis0+1)%2]);
	for (let j = 0; j < linePoints[1].length-1; j++) {
		let segment1 = linePoints[1].slice(j, j+2);
		let axis1 = linePoints[1][j].axis;
		segment1.sort((a, b) => a[(axis1+1)%2] - b[(axis1+1)%2]);
		if (segment0[0][axis0] >= segment1[0][axis0] && segment0[1][axis0] <= segment1[1][axis0] &&
			segment1[0][axis1] >= segment0[0][axis1] && segment1[1][axis1] <= segment0[1][axis1]) {
			let segment0dist = Math.abs(linePoints[0][i][axis1] - segment1[0][axis1]);
			let segment1dist = Math.abs(linePoints[1][j][axis0] - segment0[0][axis0]);
			console.log(line0Dist+line1Dist+segment0dist+segment1dist);
		}
		line1Dist += Math.abs(segment1[1][1] - segment1[0][1]) + segment1[1][0] - segment1[0][0];
	}
	line1Dist = 0;
	line0Dist += Math.abs(segment0[1][1] - segment0[0][1]) + segment0[1][0] - segment0[0][0];
}
