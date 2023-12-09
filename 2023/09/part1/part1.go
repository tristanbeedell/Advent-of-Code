
package part1

import (
	"bufio"
	"strings"
	"strconv"
	"os"
	"errors"
	"fmt"
)

func main() {
	reader := bufio.NewReader(os.Stdin);
	total := 0;
	for {
		line, err := reader.ReadString('\n');
		if (err != nil) {
			break
		}
		values, err := LineConv(line)
		if err != nil {
			fmt.Println(err)
			return
		}
		next, err := Next(values)
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

func Next(src []int) (int, error) {
	if len(src) < 2 {
		return 0, errors.New("not enough data!")
	}
	if  IsZero(src) {
		return 0, nil
	}
	deriv := Deriv(src)
	nextDelta, err := Next(deriv)
	if (err != nil) {
		return 0, err 
	}
	return src[len(src)-1] + nextDelta, nil
}

func Deriv(src []int) (deriv []int) {
	for i := range src {
		if i == len(src)-1 {
			break
		}
		deriv = append(deriv, src[i+1] - src[i])
	}
	return
}

func IsZero(src []int) bool {
	res := true
	for _,v := range src {
		if v != 0 {
			res = false
		}
	}
	return res
}

func LineConv(line string) ( []int, error ) {
	strs := strings.Split(strings.Trim(line, "\n"), " ")
	values := []int{};
	for _, str := range strs {
		value, err := strconv.Atoi(str)
		if (err != nil) {
			return []int{}, err
		}
		values = append(values, value)
	}
	return values, nil;
}

