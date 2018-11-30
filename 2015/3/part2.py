
# lets just make it object oriented wtf
class Dud ():
	def __init__ (self):
		self.x = 0
		self.y = 1

	def do(self, command):
		if command == ">":
			self.x += 1
		elif command == "<":
			self.x -= 1
		elif command == "^":
			self.y += 1
		elif command == "v":
			self.y -= 1


with open("input.txt", "r") as commands:
	santa = Dud()
	robo = Dud()

	history = set()
	num = 0
	for command in commands.readlines()[0]:
		dud = santa if num % 2 == 0 else robo
		dud.do(command)

		history.add((dud.x, dud.y))
		
		num += 1
	print(len(history))
	commands.close()





