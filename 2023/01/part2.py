#!/usr/bin/env python3

# 52746 too low

import os
import re

path = os.path.dirname(os.path.abspath(__file__))

nums = []

def toInt(txt: str):
    try:
        num = int(txt)
    except:
        if txt == 'one':
            num = 1
        elif txt == 'two':
            num = 2
        elif txt == 'three':
            num = 3
        elif txt == 'four':
            num = 4
        elif txt == 'five':
            num = 5
        elif txt == 'six':
            num = 6
        elif txt == 'seven':
            num = 7
        elif txt == 'eight':
            num = 8
        elif txt == 'nine':
            num = 9
    finally:
        return num

with open(path+'/input.txt', 'r') as input:
    for text in input.readlines():
        text = text.strip()

        print('original:',text)

        left = re.findall(r"(?=(one|two|three|four|five|six|seven|eight|nine|1|2|3|4|5|6|7|8|9))", text)

        print('search:',left)

        a = toInt(left[0])
        b = toInt(left[-1])

        print(a, b)

        total = (10*a) + b

        print('total:',total)

        nums.append(total)

print(sum(nums))
