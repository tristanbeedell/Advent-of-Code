
package part2
import (
	"testing"
	"reflect"
)

func TestPrev(t *testing.T) {
	next, err := Next([]int{0,1,2,3}, true)
	equal(t,err,nil)
	equal(t,next,-1)
}

func equal(t *testing.T, actual any, target any) {
	if !reflect.DeepEqual(actual, target) {
		t.Errorf("expected %v, got %v", target, actual)
	}
}

