
package main

import (
	"bufio"
	"os"
	"strings"
	"strconv"
)

func main() {
	reader := bufio.NewReader(os.Stdin);

	text, _ := reader.ReadString('\n')
	seeds := strings.Split(strings.Trim(strings.Split(text, ": ")[1], "\n"), " ");

	reader.ReadString('\n')
	mappers := [][]resMap{};

	points := []int{};

	for {

		line, _ := reader.ReadString('\n')
		if len(line) < 1 {
			break;
		}

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
			points = append(points, seedLocOrigin(mappers, srcStart));
		}

		mappers = append(mappers, mapper)
	}
	
	min := 0;

	for i := 0; i < len(seeds) -1; i += 2 {
		start, _ := strconv.Atoi(seeds[i]);
		length, _ := strconv.Atoi(seeds[i+1]);
		o := seedLoc(mappers, start);
		if min == 0 || o < min {
			min = o;
		}
		for _, point := range points {
			if point > start && point < start + length {

				o := seedLoc(mappers, point);
				if min == 0 || o < min {
					min = o;
				}
			}
		}
	}

	println(min)
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

func unMapSeed(soil []resMap, source int) (int) {
	for _, m := range soil {
		if source >= m.destStart && source < m.destStart + m.length {
			return m.srcStart + (source - m.destStart)
		}
	}
	return source
}

func seedLocOrigin(mappers [][]resMap, source int) int {
	for i := range mappers {
		fMaps := mappers[len(mappers)-i-1]
		source = unMapSeed(fMaps, source)
	}
	return source
}

type resMap struct {
	destStart int
	srcStart int
	length int
}

