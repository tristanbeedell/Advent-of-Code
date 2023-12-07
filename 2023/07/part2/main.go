
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
		println(hand[0], GetType(hand[0]), bid)
		total += rank * bid
	}
	println(total)
}


func IsFiveOfAKind(cardMap CardMap) (bool) {

	for suit, value := range cardMap {
		jokers := cardMap['J']
		if suit == 'J' {
			jokers = 0
		}
		if value + jokers == 5 {
			return true
		}
	}
	
	return false
}

func IsFourOfAKind(cardMap CardMap) (bool) {
	for suit,value := range cardMap {
		jokers := cardMap['J']
		if suit == 'J' {
			jokers = 0
		}
		if value + jokers == 4 {
			return true
		}
	}
	
	return false
}

func HasTriple(cardMap CardMap) (bool) {
	for suit,value := range cardMap {
		jokers := cardMap['J']
		if suit == 'J' {
			jokers = 0
		}
		if value + jokers == 3 {
			return true
		}
	}
	
	return false
}

func NoJokerPairCount(cardMap CardMap) (int) {
	count := 0;
	for _,value := range cardMap {
		if value == 2 {
			count ++
		}
	}

	return count
}

func PairCount(cardMap CardMap) (int) {
	count := 0;
	jokers := cardMap['J']
	for suit,value := range cardMap {
		if suit == 'J' {
			continue
		}
		if value == 2 {
			count ++
		} else if jokers > 0 && value == 1 {
			count ++
			jokers --
		}
	}

	return count
}

func IsFullHouse(cardMap CardMap) (bool) {
	if cardMap['J'] == 1 {
		return NoJokerPairCount(cardMap) == 2
	} else if cardMap['J'] == 0 {
		return PairCount(cardMap) == 1 && HasTriple(cardMap)
	}
	return false
}

func GetType(hand string) int {
	cardMap := GetCardMap(hand)
	if IsFiveOfAKind(cardMap) {
		return 6
	} else if IsFourOfAKind(cardMap) {
		return 5
	} else if IsFullHouse(cardMap) {
		return 4
	} else if HasTriple(cardMap) {
		return 3
	} 
	return PairCount(cardMap)
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
	cardValues := map[rune]int{'A': 13, 'K': 12, 'Q': 11, 'T': 10, '9':9, '8':8, '7':7, '6':6, '5':5, '4':4, '3':3, '2': 2, 'J': 1}
	value := 0
	for _, card := range hand {
		value *= 14
		value += cardValues[card]-1
	}
	return value
}

type CardMap = map[rune]int

func GetCardMap(hand string) (cardMap CardMap) {
	cardMap = map[rune]int{};
	for _, card := range hand {
		cardMap[card] ++;
	}
	return
}
