const fs = require('fs');

const data = fs.readFileSync('input.txt', 'utf-8');
const passports = data.split('\n\n').map(p=>p.split(/[\n\s]/g).map(e=>e.split(":")));
// requried fields
const req = ['ecl', 'eyr', 'hcl', 'byr', 'iyr', 'pid', 'hgt'];

let validamt = 0
passports.forEach(passport=>{
  for(let i = 0; i < req.length; i++){
    if(!passport.find(entry => entry[0] == req[i])){
      return
    }
  }
  validamt++
});

console.log(validamt)