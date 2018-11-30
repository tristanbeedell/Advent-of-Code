with open("input.txt", "r") as commands:
	x = 0
	y = 0
	history = []
	for command in commands.readlines()[0]:
		if command == ">":
			x += 1
		elif command == "<":
			x -= 1
		elif command == "^":
			y += 1
		elif command == "v":
			y -= 1
		if not [x, y] in history:
			history.append([x, y])
	print(len(history))
	commands.close()

