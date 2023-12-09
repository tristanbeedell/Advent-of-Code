
package part2

import (
	"errors"
	"git.tristans.cloud/tristan/aoc/2023/09/part1"
)

func Next(src []int, dir bool) (int, error) {
	if len(src) < 2 {
		return 0, errors.New("not enough data!")
	}
	if part1.IsZero(src) {
		return 0, nil
	}
	deriv := part1.Deriv(src)
	nextDelta, err := Next(deriv, dir)
	if (err != nil) {
		return 0, err 
	}
	if dir {
		return src[0] - nextDelta, nil
	} else {
		return src[len(src)-1] + nextDelta, nil
	}
}


