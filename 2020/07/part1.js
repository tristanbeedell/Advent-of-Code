const fs = require('fs');

const data = fs.readFileSync('input.txt', 'utf-8');
const rules = data.split('\n');

let allBagsThatContainGold = new Set()

let bagRules = []
rules.forEach(rule => {
  halves = rule.split(' bags contain ')
  bagRules.push ( 
  { name : halves[0],
    content : halves[1].replace(/( bags| bag|\.)/g, "")
      .split(", ")
      .map((t)=>{
        return {
          name: t.replace(/\d /,""),
          amt: t[0]
        }
      })
  })
});

function searchFor(name) {
  console.log(name)
  let bagsThatContain = []
  bagRules.forEach(bagRule => {
    if (bagRule.content.find(innerBag => innerBag.name == name))
      bagsThatContain.push(bagRule.name)
  });
  bagsThatContain.forEach(bag => {
    if (!allBagsThatContainGold.has(bag)) {
      allBagsThatContainGold.add(bag)
      searchFor(bag)
    }
  })
  return bagsThatContain
}
searchFor('shiny gold')
console.log(allBagsThatContainGold.size)
