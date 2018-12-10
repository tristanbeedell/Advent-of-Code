with open('input.txt') as input:
    lines = [line.strip('\n') for line in input.readlines()]

    for line1 in lines:
        for line2 in lines:
            i = 0
            amt = 0
            for i in range(len(line1)):
                if line1[i] != line2[i]:
                    diff = i
                    amt += 1
                    if amt > 1:
                        break
                i += 1
            if amt == 1:
                print(line1 + '\n' + line2)
                print('you can figure out where the different char is')
                break
        if amt == 1:
            break
