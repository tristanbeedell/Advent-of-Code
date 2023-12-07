
package main

import (
	"testing"
)

func TestIsFiveOfAKind(t *testing.T) {
	if IsFiveOfAKind("AAAAQ") {
		t.Fail()
	}
	if !IsFiveOfAKind("AAAAA") {
		t.Fail()
	}
}

func TestIsFourOfAKind(t *testing.T) {
	if !IsFourOfAKind("AAAAQ") {
		t.Fail()
	}
	if IsFourOfAKind("AAAQQ") {
		t.Fail()
	}
}

func TestIsFullHouse(t *testing.T) {
	if !IsFullHouse("AAAQQ") {
		t.Fail()
	}
	if IsFullHouse("AAKQQ") {
		t.Fail()
	}
	if IsFullHouse("AAAAA") {
		t.Fail()
	}
}

func TestHasTriple(t *testing.T) {
	if HasTriple("AAKQQ") {
		t.Fail()
	}
	if HasTriple("AAAAQ") {
		t.Fail()
	}
	if !HasTriple("AAAQQ") {
		t.Fail()
	}
}

func TestPairCount(t *testing.T) {
	if PairCount("AAKQQ") != 2 {
		t.Fail()
	}
	if PairCount("AQKQA") != 2 {
		t.Fail()
	}
	if PairCount("12345") != 0 {
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
	if GetValue("A") != 13 {
		t.Fail()
	}
	if GetValue("AA") != 13*14 + 13 {
		t.Fail()		
	}
	if GetValue("KA") != 12*14 + 13 {
		t.Fail()		
	}
}
