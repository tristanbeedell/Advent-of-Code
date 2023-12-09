
package main

import (
	"bufio"
	"os"
	"fmt"
	"git.tristans.cloud/tristan/aoc/2023/09/part1"
	"git.tristans.cloud/tristan/aoc/2023/09/part2/part2"
)

func main() {
	reader := bufio.NewReader(os.Stdin);
	total := 0;
	for {
		line, err := reader.ReadString('\n');
		if (err != nil) {
			break
		}
		values, err := part1.LineConv(line)
		if err != nil {
			fmt.Println(err)
			return
		}
		next, err := part2.Next(values, true)
		if err != nil {
			fmt.Println(err)
			return
		}
		total += next;
		fmt.Printf("%v => %v\n", values, next)
	}
	println(total)
	return
}

