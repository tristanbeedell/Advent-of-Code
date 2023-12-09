
package part2

import (
	"testing"
	"reflect"
	"sort"
)

func TestGetStarts(t *testing.T) {
	net := Network{
		"11A": [2]string{"11B", "XXX"},
		"11B": [2]string{"XXX", "11Z"},
		"11Z": [2]string{"11B", "XXX"},
		"22A": [2]string{"22B", "XXX"},
		"22B": [2]string{"22C", "22C"},
		"22C": [2]string{"22Z", "22Z"},
		"22Z": [2]string{"22B", "22B"},
		"XXX": [2]string{"XXX", "XXX"},
	}
	starts := GetStarts(net);
	sort.Strings(starts)
	equal(t, starts, []string{"11A", "22A"})
}

func TestIsDone(t *testing.T) {
	equal(t, IsDone([]string{"ABZ", "11Z"}), true)
	equal(t, IsDone([]string{"ABC", "11Z"}), false)
}

func TestStepsToSolveAll(t *testing.T) {
	net := Network{
		"11A": [2]string{"11B", "XXX"},
		"11B": [2]string{"XXX", "11Z"},
		"11Z": [2]string{"11B", "XXX"},
		"22A": [2]string{"22B", "XXX"},
		"22B": [2]string{"22C", "22C"},
		"22C": [2]string{"22Z", "22Z"},
		"22Z": [2]string{"22B", "22B"},
		"XXX": [2]string{"XXX", "XXX"},
	}
	steps, err := StepsToSolveAll("LR", net)
	equal(t, err, nil)
	equal(t, steps, 6)
}

func TestStepsToSolve(t *testing.T) {
	net := Network{
		"11A": [2]string{"11B", "XXX"},
		"11B": [2]string{"XXX", "11Z"},
		"11Z": [2]string{"11B", "XXX"},
		"22A": [2]string{"22B", "XXX"},
		"22B": [2]string{"22C", "22C"},
		"22C": [2]string{"22Z", "22Z"},
		"22Z": [2]string{"22B", "22B"},
		"XXX": [2]string{"XXX", "XXX"},
	}
	steps, err := StepsToSolve("LR", net, "11A")
	equal(t, err, nil)
	equal(t, steps, 2)
	steps, err = StepsToSolve("LR", net, "22A")
	equal(t, err, nil)
	equal(t, steps, 3)
}

func TestLCM(t *testing.T) {
	equal(t, LCM(2,3), 6)
}

func equal(t *testing.T, actual any, target any) {
	if !reflect.DeepEqual(actual, target) {
		t.Errorf("expected '%v', got '%v'", target, actual)
	}
}

