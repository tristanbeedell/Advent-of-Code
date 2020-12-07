const fs = require('fs');

const data = fs.readFileSync('input.txt', 'utf-8');
const rules = data.split('\n');


let bagRules = {}
rules.forEach(rule => {
  halves = rule.split(' bags contain ')
  bagRules[halves[0]] =
    halves[1].replace(/( bags| bag|\.)/g, "")
      .split(", ")
      .map((t)=>{
        return {
          name: t.replace(/\d /,""),
          amt: t[0]
        }
      })
});

function howManyIn(name) {
  let amt = 1
  bagRules[name].forEach(rule => {
    if (rule.amt == 'n') {return}
    amt += parseInt(rule.amt) * howManyIn(rule.name)
  })
  return amt
}

howManyIn('shiny gold')-1 // subtract the first gold bag