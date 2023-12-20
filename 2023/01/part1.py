#!/usr/bin/env python3

import os
path = os.path.dirname(os.path.abspath(__file__))

nums = []

with open(path+'/filtered.txt', 'r') as input:
    for text in input.readlines():
        a = int(text[0])
        b = int(text[-2])
        nums.append((10*a) + b)

print(nums)
print(sum(nums))
