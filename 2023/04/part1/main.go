
package main

import (
	"bufio"
	"os"
	"strings"
)

func main() {
	reader := bufio.NewReader(os.Stdin);

	total := 0;

	for text, err := reader.ReadString('\n'); err == nil; text, err = reader.ReadString('\n') {
		points := score(text);

		total += points;
	}

	println(total);

}

func score(text string) (score int) {
	gameStr := strings.Trim(strings.ReplaceAll(strings.Split(text, ": ")[1], "  ", " "), "\n");

	nums := strings.Split(gameStr," | ");

	winners := strings.Split(nums[0]," ");
	draw := strings.Split(nums[1]," ");

	amt := 0;

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
			if amt == 1 {
				score = 1;
			} else {
				score *= 2;
			}
		}
	}

	return
}


