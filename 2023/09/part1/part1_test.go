
package part1

import (
	"testing"
	"reflect"
)

func TestNextConst(t *testing.T) {
	next, err := Next([]int{1, 1, 1})
	equal(t, err, nil)
	equal(t, next, 1)
	next, err = Next([]int{2, 2, 2})
	equal(t, err, nil)
	equal(t, next, 2)
}

func TestNextLinear(t *testing.T) {
	next, err := Next([]int{0, 1, 2, 3})
	equal(t, err, nil)
	equal(t, next, 4)
}

func TestNextQuad(t *testing.T) {
	next, err := Next([]int{0, 1, 4, 9, 16})
	equal(t, err, nil)
	equal(t, next, 25)
}

func TestNextBadList(t *testing.T) {
	v, err := Next([]int{0, 5, 2})
	if err == nil {
		t.Errorf("expected error, got %v", v)
	}
}

func TestDerivConst(t *testing.T) {
	equal(t, Deriv([]int{1,1,1}), []int{0,0})
	equal(t, Deriv([]int{2,2,2}), []int{0,0})
}

func TestDerivLinear(t *testing.T) {
	equal(t, Deriv([]int{0,1,2}), []int{1,1})
	equal(t, Deriv([]int{0,2,4}), []int{2,2})
}

func TestDerivQuad(t *testing.T) {
	equal(t, Deriv([]int{0,1,4,9,16}), []int{1,3,5,7})
}

func TestIsZero(t *testing.T) {
	equal(t, IsZero([]int{0}), true)
	equal(t, IsZero([]int{0, 0}), true)
	equal(t, IsZero([]int{1}), false)
	equal(t, IsZero([]int{1, 1}), false)
	equal(t, IsZero([]int{1, 0}), false)
}

func TestLineConv(t *testing.T) {
	r, err := LineConv("0 1 2 3")
	equal(t, err, nil)
	equal(t, r, []int{0, 1, 2, 3})
}

func equal(t *testing.T, actual any, target any) {
	if !reflect.DeepEqual(actual, target) {
		t.Errorf("expected %v, got %v", target, actual)
	}
}

