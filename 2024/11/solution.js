
const input = (await Bun.file(Bun.argv[2]).text()).trim()
const stones = input.split(" ").map(num => parseInt(num))

const splits = num => countDigits(num) % 2 == 0;

const countDigits = num => Math.floor(Math.log10(num)) + 1;

const getLeft = num => Math.floor(num / Math.pow(10, countDigits(num) / 2));
const getRight = num => num - getLeft(num) * Math.pow(10, countDigits(num) / 2);

const memo = new Map();

const blinkTimes = (times, num) => {
  if (times == 0) return 1;
  const key = times + '*' + num;
  if (memo.has(key)) {
    return memo.get(key)
  }
  let result
  if (num === 0) {
    result = blinkTimes(times-1, 1)
  } else if (splits(num)) {
    result = blinkTimes(times-1, getLeft(num)) + blinkTimes(times-1, getRight(num))
  } else {
    result = blinkTimes(times-1, num * 2024)
  }
  memo.set(key, result)
  return result;
}

let count = 0
for (const stone of stones) {
  count += blinkTimes(25, stone)
}
console.log("part 1", count)

count = 0
for (const stone of stones) {
  count += blinkTimes(75, stone)
}
console.log("part 2", count)
