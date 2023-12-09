
package part1

import (
	"regexp"
	"errors"
	"fmt"
)

type Network = map[string][2]string
const start = "AAA"
const Goal = "ZZZ"

func GetValues(in string) (src, left, right string, err error) {
	re := regexp.MustCompile(`[A-Z1-9]{3}`)
	out := re.FindAllString(in, -1)
	if (len(out) != 3) {
		return "", "", "", errors.New("must be three values")
	}
	src = out[0];
	left = out[1];
	right = out[2];
	return
}

func AddToNet(net Network, line string) error {
	src, left, right, err := GetValues(line)
	if err != nil {
		return err
	}
	net[src] = [2]string{left, right}
	return nil
}

func StepsToSolve(ins string, net Network) (int, error) {
	current := start;
	steps := 0;
	i := 0
	for {
		if current == Goal {
			return steps, nil
		}
		steps ++
		switch ins[i  % len(ins)] {
		case 'L':
			current = net[current][0]
		case 'R':
			current = net[current][1]
		default:
			return 0, fmt.Errorf("instructions unclear! Must only be 'R' and 'L', but got %v at [%v]", ins[i], i)
		}
		i++
	}
}

