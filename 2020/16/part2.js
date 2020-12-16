const fs = require('fs');
const [fields, myTicket, nearbyTickets] = fs.readFileSync('./input.txt', 'utf-8').split('\n\n');

const allValid = new Set(); // a set of all values that are within any of the ranges
const allFieldNames = [];  // an array of all names that the fields have
const fieldsValid = fields // an array containing a set of all values within the ranges for each field
.split('\n')
.map(f => {
  allFieldNames.push(f.split(':')[0])
  return f.match(/\d+-\d+/g)
  .reduce((a, v) => {
    let [start, end] = v.split('-').map(a=>parseInt(a));
    for (let j = start; j <= end; j++) {
      a.add(j);
      allValid.add(j);
    }
    return a;
  }, new Set())
})
// for example class: 1-3 \ row: 0-1 or 4-5 would become
// allFieldNames  = ['class', 'row'    ]
// fieldsValid    = [{1,2,3}, {0,1,4,5}]

// get all the valid tickets
const tickets = nearbyTickets 
.split('\n')
.slice(1)
.map(t => t.split(',').map(v => parseInt(v)))
.filter(ticket => 
  ticket.every(e => allValid.has(e))
)

let entrysOptions = [];
// iterate thru each entry of the valid tickets
for (let entryNum = 0; entryNum < tickets[0].length; entryNum++) {
  // assume that this entry could be one of any of the fields
  let couldBe = new Set(allFieldNames);
  // for each value this entry has on all the valid tickets
  for (let ticketNum = 0; ticketNum < tickets.length; ticketNum++) {
    // if any value doesn't fit into a field, this entry cannot be that field.
    fieldsValid.forEach((field,i)=> {
      if (!field.has(tickets[ticketNum][entryNum])) {
        couldBe.delete(allFieldNames[i]);
      }
    })
  }
  // keep track of the possibilities for each entry
  entrysOptions.push(couldBe);
}

let found = []
let amtFound = 0;
while (amtFound < allFieldNames.length) {
  entrysOptions.forEach((options, i) => {
    // if there is only one possibile field for this entry we know what it is
    if (options.size == 1) {
      let fieldName = options.values().next().value;
      // remove this field as a possibility for every other entry
      entrysOptions.forEach(allOptions => {allOptions.delete(fieldName)});
      // remember which entry correlates to which field
      found[i] = fieldName;
      amtFound++;
    }
  })
}
// get the values from my ticket
const myTicketValues = myTicket.split('\n')[1].split(',').map(e => parseInt(e));

// get the multiple of all departure values for the puzzle answer
let departures = 1;
found.forEach((name, i) => {
  console.log(name, myTicketValues[i]);
  if (name.split(' ')[0] == 'departure') {
    departures *= myTicketValues[i]
  }
})
console.log('puzzle answer',departures)