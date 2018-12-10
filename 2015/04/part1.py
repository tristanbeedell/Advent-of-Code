input = "ckczppom"

import hashlib
num = 6
i = 0
while True:
	i += 1
	m = hashlib.md5()
	m.update(str(input+str(i)).encode())
	print(m.hexdigest())
	if m.hexdigest()[0:num] == "0"*num:
		print(i)
		break

