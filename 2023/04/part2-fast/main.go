package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func main() {
	reader := bufio.NewReader(os.Stdin)


	lines := []string{}

	for text, err := reader.ReadString('\n'); err == nil; text, err = reader.ReadString('\n') {
		lines = append(lines, text)
	}

	size := len(lines)

	fmt.Printf("%v lines\n", size)

	linepoints := make([]int, size)

	for i, text := range lines {
		amt := score(text)
		fmt.Printf("%v %v\n", text, amt)
		linepoints[i] = amt
	}

	const maxPoints = 10

	newTot := 0;
	mults := make([]int, size)

	for line, points := range linepoints {

		mul := 1
		for i := line - maxPoints; i < line; i++ {
			if i < 0 {
				continue
			}
			end := i + linepoints[i]
			if end >= line {
				mul += mults[i]
			}
		}
		mults[line] = mul

		newTot += mul
		fmt.Printf("%v | +%v = %v \n", points, mul, newTot)
	}

	fmt.Printf("total cards: %v", newTot)

}

func score(text string) int {
	amt := 0

	text = strings.Trim(text, "\n")

	gameStr := strings.ReplaceAll(strings.Split(text, ": ")[1], "  ", " ")

	nums := strings.Split(gameStr, " | ")

	winners := strings.Split(nums[0], " ")
	draw := strings.Split(nums[1], " ")

	for _, n := range draw {
		match := false
		for _, w := range winners {
			match = n == w
			if match {
				break
			}
		}
		if match {
			amt++
		}
	}

	return amt
}

