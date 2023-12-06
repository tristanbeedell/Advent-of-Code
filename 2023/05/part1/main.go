
package main

import (
	"bufio"
	"os"
	"strings"
	"strconv"
)

func main() {
	reader := bufio.NewReader(os.Stdin);

	println("reading seeds")
	text, _ := reader.ReadString('\n')
	seeds := strings.Split(strings.Trim(strings.Split(text, ": ")[1], "\n"), " ");

	reader.ReadString('\n')
	mappers := [][]resMap{};

	for {

		line, _ := reader.ReadString('\n')
		if len(line) < 1 {
			break;
		}
		println("reading", line)

		mapper := []resMap{};

		for {
			nextLine, _ := reader.ReadString('\n');
			seedToSoil := strings.Split(strings.Trim(nextLine, "\n"), " ");
			if len(seedToSoil) != 3 {
				break;
			}
			destStart, _ := strconv.Atoi(seedToSoil[0]);
			srcStart, _ := strconv.Atoi(seedToSoil[1]);
			length, _ := strconv.Atoi(seedToSoil[2]);
			mapper = append(mapper, resMap{destStart,srcStart,length})
		}

		mappers = append(mappers, mapper)
	}

	smallest := 0;

	for _, seed := range seeds {
		loc, _ := strconv.Atoi(seed)
		newLoc := seedLoc(mappers, loc)
		if smallest == 0 || newLoc < smallest {
			smallest = newLoc
		}
	}

	println(smallest)
	
}

func seedLoc(mappers [][]resMap, source int) int {
	for _, m := range mappers {
		source = mapSeed(m, source)
	}
	return source
}

func mapSeed(soil []resMap, source int) (int) {
	for _, m := range soil {
		if source >= m.srcStart && source < m.srcStart + m.length {
			return m.destStart + (source - m.srcStart)
		}
	}
	return source
}

type resMap struct {
	destStart int
	srcStart int
	length int
}

