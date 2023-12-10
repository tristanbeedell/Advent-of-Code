
package main

import (
	"git.tristans.cloud/tristan/aoc/2023/10/part1/lib"
	"git.tristans.cloud/tristan/aoc/2023/10/part2/lib"
	"bufio"
	"os"
)

func main () {
	scanner := bufio.NewScanner(os.Stdin);

	pipeMap := part1.ReadMap(scanner)
	inside := part2.GetVolume(pipeMap)
	println(inside)
}

