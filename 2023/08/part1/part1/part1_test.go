
package part1

import (
	"testing"
	"reflect"
)

func TestGetValues(t *testing.T) {
	src, left, right, err := GetValues("AAA = (BBB, CCC)\n")
	equal(t, err, nil)
	equal(t, src, "AAA")
	equal(t, left, "BBB")
	equal(t, right, "CCC")
}

func TestAddToNet(t *testing.T) {
	net := Network{}
	err := AddToNet(net, "AAA = (BBB, CCC)")
	equal(t, err, nil)
	equal(t, net["AAA"], [2]string{"BBB","CCC"})
}

func TestStepsToSolveWithBadDirections(t *testing.T) {
	_, err := StepsToSolve("AB", Network{})
	if err == nil {
		t.Errorf("wanted an error")
	}
}

func TestStepsToSolve(t *testing.T) {
	net := Network{
		"AAA": [2]string{"BBB","CCC"},
		"CCC": [2]string{"ZZZ","AAA"},
		"ZZZ": [2]string{"ZZZ","ZZZ"},
	}
	steps, err := StepsToSolve("RL", net)
	equal(t, err, nil)
	equal(t, steps, 2)
}

func TestStepsToSolveWithLoop(t *testing.T) {
	net := Network{
		"AAA": [2]string{"BBB","BBB"},
		"BBB": [2]string{"AAA","ZZZ"},
		"ZZZ": [2]string{"ZZZ","ZZZ"},
	}
	steps, err := StepsToSolve("LLR", net)
	equal(t, err, nil)
	equal(t, steps, 6)
}

func equal(t *testing.T, actual any, target any) {
	if !reflect.DeepEqual(actual, target) {
		t.Errorf("expected '%v', got '%v'", target, actual)
	}
}

