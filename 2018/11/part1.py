gsn = 9798  # input


def get_power(x, y):
	rack_id = x + 10
	power = ((rack_id * y) + gsn) * rack_id
	h_digit = int(str(power)[-3]) if len(str(power)) >= 3 else 0
	return h_digit - 5

size = 300
side = 1
top = 1
totals = [[0 for i in range(size)]]
printing = size <= 10
if printing:
	print(*range(side, side+size), sep='\t')
	print('_ _ _\t|'*size)
for y in range(1, size):
	row = [0]
	totals.append([0])
	p = []

	for x in range(1, size):
		point = get_power(x+side, y+top)
		left = row[x-1] if len(row) > 0 else 0
		row.append(left + point)
		up = totals[y-1][x] if len(totals) > 1 else 0
		totals[y].append(up + left + point)
		p.append(point)

	if printing:
		print(str(y+top), end = '\t| ')
		print(*p, sep='\t| ')
		print('_ _ _\t|'*size)

largest = ((0,0),0)
for y in range(1, len(totals)-3):
	for x in range(1, len(totals[y])-3):
		p = ((x+side, y+top), totals[y+2][x+2] - totals[y-1][x+2] - totals[y+2][x-1] + totals[y-1][x-1])
		if p[1] > largest[1]:
			largest = p

print('largest:\n\
\tco-ordinates: {}\n\
\tvalue: {}'.format(largest[0], largest[1]))