
package main

import (
	"bufio"
	"os"
	"git.tristans.cloud/tristan/aoc/2023/10/part1/lib"
)

func main() {
	scanner := bufio.NewScanner(os.Stdin);
	pipeMap := part1.ReadMap(scanner)
	size := part1.LoopSize(pipeMap)
	println(size / 2)
}

