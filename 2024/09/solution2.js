
const input = (await Bun.file("input.txt").text()).trim()

// const input = "2933133121414131402";
/*
 *  0123456789
 *  0..1.....2
 *  02.1
 *  021
 */


const files = [];

const spaces = [[], [], [], [], [], [], [], [], [], [], ];

let pos = 0;
for (let i = 0; i < input.length; i++ ) {
  const size = parseInt(input[i])
  if (size == 0) continue
  if (i % 2 == 0) {
    files.push({size, id: i / 2, start: pos,})
  } else {
    spaces[size].push(pos)
  }
  pos += size;
}

for (let i = files.length - 1; i >= 0; i--) {
  const file = files[i]
  const fitspaces = [];
  for (let size = files[i].size; size <= 9; size ++ ) {
    if (spaces[size].length == 0) {
      continue
    }
    const start = spaces[size][0]
    if (start > file.start) {
      continue
    }
    fitspaces.push({size, start})
  }
  if (fitspaces.length == 0) continue
  fitspaces.sort((a, b) => a.start > b.start)
  const space = fitspaces[0]
  files[i].start = space.start;
  spaces[space.size].shift()
  const newspacestart = space.start + files[i].size
  const newspacesize = space.size - file.size
  if (newspacesize == 0) continue
  spaces[newspacesize].push(newspacestart)
  spaces[newspacesize].sort((a, b) => a > b)
}

const checksum = fs => fs.reduce((acc, current) =>
  acc + (current.id * current.size * (current.start + (current.size - 1) / 2)),
0)

console.log(checksum(files))

