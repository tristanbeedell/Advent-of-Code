
package part2

import (
	"git.tristans.cloud/tristan/aoc/2023/10/part1/lib"
	"fmt"
)

type Loop map[[2]int]bool

func GetLoop(pipeMap []string) ( loop Loop ) {
	x,y := part1.FindStart(pipeMap)
	loop = Loop{{x,y}: true}
	side,x,y := part1.FindFirst(pipeMap, x,y)
	for pipeMap[y][x] != 'S' {
		loop[[2]int{x,y}] = true
		side,x,y = part1.FindNext(pipeMap, side, x,y)
	}
	return
}

func GetShapeOfS(pipeMap []string) () {
	return 
}

const CLEAR = "\u001b[0;0m";
const OUT_OF_LOOP = CLEAR;
const ON_LOOP = "\u001b[0;31m";
const IN_LOOP = "\u001b[0;33m";

func GetVolume(pipeMap []string) int {
	loop := GetLoop(pipeMap)
	count := 0
	for y,line := range pipeMap {
		inLoop := false
		onDownEdge := false
		onUpEdge := false
		for x,c := range line {
			_,onLoop := loop[[2]int{x,y}]

			if onLoop {
				switch c {
				case '|':
					inLoop = !inLoop
				case 'L':
					onDownEdge = true
				case 'F':
					onUpEdge = true
				case '7':
					if onDownEdge {
						onDownEdge = false
						inLoop = !inLoop
					} else if onUpEdge {
						onUpEdge = false
					}
				case 'J':
					if onUpEdge {
						onUpEdge = false
						inLoop = !inLoop
					} else if onDownEdge {
						onDownEdge = false
					}

				}

			}
			color := OUT_OF_LOOP
			if onLoop {
				color = ON_LOOP
			}
			if inLoop && !onLoop {
				count++
				color = IN_LOOP
			}
			if c == 'S' {
				color = "\u001b[41;30m"
			}
			fmt.Printf("%v%c", color, c)
		}
		println(CLEAR)
	}
	return count
}

