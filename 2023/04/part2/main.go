
package main

import (
	"bufio"
	"os"
	"strings"
	"fmt"
)

func main() {
	reader := bufio.NewReader(os.Stdin);

	total := 0;

	multipliers := []int{};

	for text, err := reader.ReadString('\n'); err == nil; text, err = reader.ReadString('\n') {
		text = strings.Trim(text, "\n")
		points := score(text);

		// fmt.Printf("%v: %v\n", text, points);

		newMultipliers := []int{};
		for i := range multipliers {
			if multipliers[i] > 0 {
				newMultipliers = append(newMultipliers, multipliers[i]-1)
			}
		}

		multipliers = newMultipliers;
		multiplier := len(multipliers) + 1;
		
		for i := 0; i < multiplier; i++ {
			multipliers = append(multipliers, points);
		}

		total += multiplier;
		fmt.Printf("%v | +%v = %v\n", points, multiplier, total);
	}

	fmt.Printf("total cards: %v", total);

}

func score(text string) (amt int) {
	gameStr := strings.ReplaceAll(strings.Split(text, ": ")[1], "  ", " ");

	nums := strings.Split(gameStr," | ");

	winners := strings.Split(nums[0]," ");
	draw := strings.Split(nums[1]," ");

	for _, n := range draw {
		match := false;
		for _, w := range winners {
			match = n == w;
			if match {
				break;
			}
		}
		if match {
			amt++;
		}
	}

	return
}


