const fs = require('fs');

const data = fs.readFileSync('input.txt', 'utf-8');
const groups = data.split('\n\n');

let sum = 0
for (let g = 0; g<groups.length; g++){
  // list of people in group
  let group = groups[g].split('\n')
  // first person
  let first = group[0]

  // for each of the first person's answers
  for (let answer = 0; answer < first.length; answer++) {
    // if the total amount of that answer in the group is equal to the amount of people in the group, then everyone in the group answered that question
    if (group.length == [...groups[g].matchAll(first[answer])].length) {
      sum++
    }
  }
}
console.log(sum)