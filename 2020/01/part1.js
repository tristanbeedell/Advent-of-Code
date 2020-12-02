const fs = require('fs');

let data = fs.readFileSync('input.txt', 'utf-8');
let lines = data.split('\n').map(x => parseInt(x));

let done = false
lines.forEach((number, index) => {
  if (done) {return}
  lines.forEach((number2, index2) => {
  if (done) {return}
    if (index != index2) {
    //console.log(number, number2)
      if (number + number2 == 2020){
        done = true
        console.log(number, number2, number*number2)
      }
    }
  })
})