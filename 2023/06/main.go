
package main

import (
	"os"
	"strconv"
)

func main() {
	if len(os.Args) < 3 {
		println("usage: part1 <time> <distance>");
		return;
	}
	time, err := strconv.Atoi(os.Args[1]);
	if err != nil {
		println("time must be a number!");
	}
	dist, err := strconv.Atoi(os.Args[2]);
	if err != nil {
		println("dist must be a number!");
	}
	
	minimum := min(0, time, time, dist);

	maximum := time - minimum - 1;

	variety := maximum - minimum;

	println(variety);

}

func min(start, end, time, dist int) int {

	if end - start < 2 {
		return start
	}

	guess := start + ((end-start) / 2);

	res := calc(guess, time);

	if res > dist {
		return min(0, guess, time, dist);
	}
	return min(guess, end, time, dist);

}

func calc(pushtime, totaltime int) int {
	return (totaltime*pushtime) - (pushtime*pushtime)
}

