import os
path = os.path.dirname(os.path.abspath(__file__))

with open(path+'/input.txt', 'r') as input:
	pos = 0
	char_pos = 0
	text = input.readline()
	for char in text :
		if char == ')':
			pos -= 1
		elif char == '(':
			pos += 1
		char_pos += 1
		if pos == -1:
			print (char_pos)
			break
	
	input.close()

