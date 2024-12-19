
const input = (await Bun.file(Bun.argv[2]).text()).trim()

const [towels, desired] = input.split("\n\n")

const regex = new RegExp(`^(${towels.split(", ").join("|")})+$`)

const lines = desired.split("\n")

let count = 0;
for (const line of lines) {
  if (regex.test(line)) {count ++}
}
console.log(count)

