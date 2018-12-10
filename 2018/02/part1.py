with open('input.txt') as input:
    lines = [line.strip('\n') for line in input.readlines()]
    two = 0
    three = 0
    for line in lines:
        for char in 'qwertyuiopasdfghjklzxcvbnm':
            if line.count(char) == 2:
                two += 1
                break
        for char in 'qwertyuiopasdfghjklzxcvbnm':
            if line.count(char) == 3:
                three += 1
                break
    print(two, three, two * three)
