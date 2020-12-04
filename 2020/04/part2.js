const fs = require('fs');

const data = fs.readFileSync('input.txt', 'utf-8');
const passports = data.split('\n\n').map(p=>p.split(/[\n\s]/g).map(e=>e.split(":")));

// requried fields
const req = [
  ["byr", (v => !(v.length != 4 || v<1920 || v>2002))],
  ["iyr", (v => !(v.length != 4 || v<2010 || v>2020))],
  ["eyr", (v => !(v.length != 4 || v<2020 || v>2030))],
  ["hgt", (v => {
    n = parseInt(v)
    if (v.endsWith('cm')){
      if (n<150 || n>193) {return false}
    } else if ( v.endsWith('in')) {
      if (n<59 || n>76) {return false}
    } else {
      return false
    }
    return true
  })],
  ["hcl", (v => !!v.match(/^#[0-9a-f]{6}/))],
  ["ecl", (v => !!['amb','blu','brn','gry','grn','hzl','oth'].find(e => e==v))],
  ["pid", (v => !!v.match(/^[0-9]{9}$/))]
];

let validamt = 0
passports.forEach(passport=>{
  for(let i = 0; i < req.length; i++){
    result = passport.find(entry => entry[0] == req[i][0])
    if(!result) {
      return
    }
    if(!req[i][1](result[1])){
      return
    }
  }
  validamt++
});

console.log(validamt)