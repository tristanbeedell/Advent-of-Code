
const input = (await Bun.file("input.txt").text()).trim()

// const input = "12345";

const files = [];

const spaces = [];

let pos = 0;
for (let i = 0; i < input.length; i++ ) {
  const size = parseInt(input[i])
  if (i % 2 == 0) {
    files.push({size, id: i / 2, start: pos,})
  } else {
    spaces.push({size, start: pos})
  }
  pos += size;
}

const inserted = [];

let j = 0;
let end;
for (let i = files.length - 1; j < spaces.length; i--) {
  const file = files[i];

  let rem = file.size;
  while (rem > 0) {
    const space = spaces[j];
    if (space.start > file.start) {
      end = file.start + file.size;
      break;
    };
    const amt = Math.min(space.size, files[i].size)

    spaces[j] = {size: space.size - amt, start: space.start + amt};
    inserted.push({id: file.id, start: space.start, size: amt,})
    files[i] = {id: file.id, start: file.start, size: files[i].size - amt,};
    rem -= amt;

    if (amt == space.size) j++
  }

  if (end) break
}

const newfiles = files.concat(inserted)
  .filter(file => file.size > 0)
  .sort((a, b) => a.start > b.start)

const checksum = fs => fs.reduce((acc, current) =>
  acc + (current.id * current.size * (current.start + (current.size - 1) / 2)),
0)

console.log(checksum(newfiles))

