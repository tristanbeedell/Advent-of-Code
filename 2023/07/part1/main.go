
package main

import (
	"os"
	"bufio"
	"strings"
	"slices"
	"strconv"
)

func main() {

	reader := bufio.NewReader(os.Stdin);
	hands := [][2]string{}
	for {
		text, err := reader.ReadString('\n')
		if err != nil {
			break
		}
		strs := strings.Split(strings.Trim(text, "\n"), " ")
		hands = append(hands, [2]string{strs[0], strs[1]});
	}
	slices.SortFunc(hands, func(a, b [2]string) int {
		return Wins(a[0], b[0])
	})
	total := 0
	for i, hand := range hands {
		rank := i+1
		bid, _ := strconv.Atoi(hand[1])
		println(hand[0], rank, bid)
		total += rank * bid
	}
	println(total)
}


func IsFiveOfAKind(hand string) (bool) {
	return hand[0] == hand[1] && hand[0] == hand[2] && hand[0] == hand[3] && hand[0] == hand[4];
}

func IsFourOfAKind(hand string) (bool) {

	cardMap := map[rune]int{}
	for _, card := range hand {
		cardMap[card] ++;
		if cardMap[card] == 4 {
			return true
		}
	}
	
	return false
}

func HasTriple(hand string) (bool) {

	cardMap := map[rune]int{}
	for _, card := range hand {
		cardMap[card] ++;
	}
	for _,value := range cardMap {
		if value == 3 {
			return true
		}
	}
	
	return false
}

func PairCount(hand string) (int) {

	cardMap := map[rune]int{}
	for _, card := range hand {
		cardMap[card] ++;
	}
	count := 0;
	for _,value := range cardMap {
		if value == 2 {
			count ++
		}
	}
	
	return count
}

func IsFullHouse(hand string) (bool) {
	return PairCount(hand) == 1 && HasTriple(hand)	
}

func GetType(hand string) int {
	pc := 0;
	if IsFiveOfAKind(hand) {
		return 6
	} else if IsFourOfAKind(hand) {
		return 5
	} else if IsFullHouse(hand) {
		return 4
	} else if HasTriple(hand) {
		return 3
	} else if pc = PairCount(hand); pc == 2 {
		return 2
	} else if pc == 1 {
		return 1
	}
	return 0
}

func Wins(left string, right string) (int) {
	leftType := GetType(left)
	rightType := GetType(right)
	if leftType == rightType {
		return GetValue(left) - GetValue(right)
	}
	return leftType - rightType
}

func GetValue(hand string) (int) {
	cardValues := map[rune]int{'A': 14, 'K': 13, 'Q': 12, 'J': 11, 'T': 10, '9':9, '8':8, '7':7, '6':6, '5':5, '4':4, '3':3, '2': 2, '1': 1}
	value := 0
	for _, card := range hand {
		value *= 14
		value += cardValues[card]-1
	}
	return value
}
