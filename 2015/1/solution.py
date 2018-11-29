with open('input.txt', 'r') as input:
	counter = 0
	text = input.readline()
	for char in text :
		if char == ')':
			counter -= 1
		elif char == '(':
			counter += 1
	print (counter)
