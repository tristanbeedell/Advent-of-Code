with open('input.txt', 'r') as f:
	data = f.read().split('\n')

# i wish i thought of this from the start
grid = {}
crossings = []
lineNo = 0
for line in data:
	steps = 0
	pos = [0, 0]
	line = line.split(',')
	for segment in line:
		dirChar = segment[0]
		dirV = [0, 1] if dirChar == "U" else [0, -1] if dirChar == "D" else [1, 0] if dirChar == "R" else [-1, 0]
		for i in range(1, int(segment[1:])+1):
			pos[0] += dirV[0]
			pos[1] += dirV[1]
			steps += 1
			if lineNo == 0:
				grid[str(pos)] = steps
				continue
			try:
				crossings.append(grid[str(pos)] + steps)
				print(pos, grid[str(pos)], steps)
			except:
				continue
	lineNo += 1

print(min(crossings))