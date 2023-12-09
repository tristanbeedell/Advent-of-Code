
package main

import (
	"bufio"
	"os"
	"fmt"
	"git.tristans.cloud/tristan/aoc/2023/08/part2/part2"
	"git.tristans.cloud/tristan/aoc/2023/08/part1/part1"
	"strings"
)

func main() {
	reader := bufio.NewReader(os.Stdin);
	ins, err := reader.ReadString('\n');
	if err != nil {
		fmt.Println("Halted too soon!")
		return
	}
	ins = strings.Trim(ins, "\n")
	_, err = reader.ReadString('\n');
	if err != nil {
		fmt.Println("Halted too soon!")
		return
	}
	net := part1.Network{}
	for {
		line, err := reader.ReadString('\n');
		if err != nil {
			break
		}
		err = part1.AddToNet(net, line)
		if err != nil {
			fmt.Println(err, line, net)
		}
	}
	steps, err := part2.StepsToSolveAll(ins, net)
	if (err != nil) {
		fmt.Println(err)
	}
	fmt.Println(steps)
}

