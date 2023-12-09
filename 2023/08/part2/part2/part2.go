
package part2

import (
	"fmt"
	"git.tristans.cloud/tristan/aoc/2023/08/part1/part1"
)

type Network = part1.Network
const start = 'A'
const goal = 'Z'

func StepsToSolveAll(ins string, net Network) (int, error) {
	current := GetStarts(net)
	res := 1
	for _,start := range current {
		steps, err := StepsToSolve(ins, net, start)
		if err != nil {
			return 0, err
		}
		// I expected I'd have to do a bit more than that!
		res = LCM(res, steps)
	}

	return res, nil
}

func GetStarts(net Network) (current []string) {
	for key := range net {
		if key[2] == start {
			current = append(current, key)
		}
	}
	return
}

func IsDone(state []string) bool {
	for _,key := range state {
		if key[2] != goal {
			return false
		}
	}
	return true
}

func StepsToSolve(ins string, net Network, start string) (int, error) {
	current := start
	steps := 0;
	for {
		switch ins[steps  % len(ins)] {
		case 'L':
			current = net[current][0]
		case 'R':
			current = net[current][1]
		default:
			return 0, fmt.Errorf("instructions unclear! Must only be 'R' and 'L', but got '%c' at [%v]", ins[steps], steps)
		}
		steps ++
		if current[2] == goal {
			return steps, nil
		}
	}

}

// greatest common divisor (GCD) via Euclidean algorithm
func GCD(a, b int) int {
	for b != 0 {
		t := b
		b = a % b
		a = t
	}
	return a
}

// find Least Common Multiple (LCM) via GCD
func LCM(a, b int, integers ...int) int {
	return a * b / GCD(a, b)
}

