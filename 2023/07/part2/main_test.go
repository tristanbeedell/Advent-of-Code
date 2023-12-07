
package main

import (
	"testing"
)

func TestIsFiveOfAKind(t *testing.T) {
	if IsFiveOfAKind(GetCardMap("AAAAQ")) {
		t.Fail()
	}
	if !IsFiveOfAKind(GetCardMap("AAAAA")) {
		t.Fail()
	}
	if !IsFiveOfAKind(GetCardMap("AAJAA")) {
		t.Fail()
	}
	if !IsFiveOfAKind(GetCardMap("AAJJJ")) {
		t.Fail()
	}
}

func TestIsFourOfAKind(t *testing.T) {
	if !IsFourOfAKind(GetCardMap("AAAAQ")) {
		t.Fail()
	}
	if IsFourOfAKind(GetCardMap("AAAQQ")) {
		t.Fail()
	}
	if !IsFourOfAKind(GetCardMap("AAAJQ")) {
		t.Fail()
	}
	if !IsFourOfAKind(GetCardMap("AJJJQ")) {
		t.Fail()
	}
}

func TestIsFullHouse(t *testing.T) {
	if !IsFullHouse(GetCardMap("AAAQQ")) {
		t.Fail()
	}
	if IsFullHouse(GetCardMap("AAKQQ")) {
		t.Fail()
	}
	if IsFullHouse(GetCardMap("AAAAA")) {
		t.Fail()
	}
	if !IsFullHouse(GetCardMap("AAJQQ")) {
		t.Fail()
	}
	if !IsFullHouse(GetCardMap("33J99")) {
		t.Fail()
	}
	if IsFullHouse(GetCardMap("JJ32A")) {
		t.Fail()
	}
}

func TestHasTriple(t *testing.T) {
	if HasTriple(GetCardMap("AAKQQ")) {
		t.Fail()
	}
	if HasTriple(GetCardMap("AAAAQ")) {
		t.Fail()
	}
	if !HasTriple(GetCardMap("AAAQQ")) {
		t.Fail()
	}
	if !HasTriple(GetCardMap("AAJQQ")) {
		t.Fail()
	}
}

func TestJokerPairCount(t *testing.T) {
	if PairCount(GetCardMap("AAKQQ")) != 2 {
		t.Fail()
	}
	if PairCount(GetCardMap("AQKQA")) != 2 {
		t.Fail()
	}
	if PairCount(GetCardMap("12345")) != 0 {
		t.Fail()
	}
	if PairCount(GetCardMap("123J5")) != 1 {
		t.Fail()
	}
}

func TestPairCount(t *testing.T) {
	if NoJokerPairCount(GetCardMap("AAKQQ")) != 2 {
		t.Fail()
	}
	if NoJokerPairCount(GetCardMap("AQKQA")) != 2 {
		t.Fail()
	}
	if NoJokerPairCount(GetCardMap("12345")) != 0 {
		t.Fail()
	}
	if NoJokerPairCount(GetCardMap("123J5")) != 0 {
		t.Fail()
	}
}

func TestGetType(t *testing.T) {
	pass := GetType("AAAAA") == 6 &&
		GetType("AAKAA") == 5 &&
		GetType("AAKAK") == 4 &&
		GetType("AAAKQ") == 3 &&
		GetType("AAKK2") == 2 &&
		GetType("AAK12") == 1 &&
		GetType("12345") == 0
		
	if !pass {
		t.Fail();
	}
}

func TestWins(t *testing.T) {
	if Wins("AAAAA", "AAAA1") < 0 {
		t.Fail();
	}
	if Wins("AAAA1", "AAA11") < 0 {
		t.Fail();
	}
	if Wins("AAA11", "AAA12") < 0 {
		t.Fail();
	}
	if Wins("AAA12", "AA123") < 0 {
		t.Fail();
	}
	if Wins("AA123", "A1234") < 0 {
		t.Fail();
	}
	if Wins("A1234", "1234A") < 0 {
		t.Fail();
	}
	if Wins("AAAAK", "KAAAA") < 0 {
		t.Fail();
	}
	if Wins("12212", "22112") > 0 {
		t.Fail();
	}
	if Wins("77788", "77888") > 0 {
		t.Fail();
	}
}

func TestGetValue(t *testing.T) {
	if GetValue("A") != 12 {
		t.Fail()
	}
	if GetValue("AA") != 12*14 + 12 {
		t.Fail()		
	}
	if GetValue("KA") != 11*14 + 12 {
		t.Fail()		
	}
	if GetValue("JA") != 0*14 + 12 {
		t.Fail()		
	}
}
