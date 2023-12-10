
package part2

import (
	"testing"
	"reflect"
)

var inputMap = []string{
	"...........",
	".S-------7.",
	".|F-----7|.",
	".||.....||.",
	".||.....||.",
	".|L-7.F-J|.",
	".|..|.|..|.",
	".L--J.L--J.",
	"...........",
}

var complexMap = []string{
	"FF7FSF7F7F7F7F7F---7",
	"L|LJ||||||||||||F--J",
	"FL-7LJLJ||||||LJL-77",
	"F--JF--7||LJLJ7F7FJ-",
	"L---JF-JLJ.||-FJLJJ7",
	"|F|F-JF---7F7-L7L|7|",
	"|FFJF7L7F-JF7|JL---7",
	"7-L-JL7||F7|L7F-7F7|",
	"L.L7LFJ|||||FJL7||LJ",
	"L7JLJL-JLJLJL--JLJ.L",
}

var anotherMap = []string{
	".F----7F7F7F7F-7....",
	".|F--7||||||||FJ....",
	".||.FJ||||||||L7....",
	"FJL7L7LJLJ||LJ.L-7..",
	"L--J.L7...LJS7F-7L7.",
	"....F-J..F7FJ|L7L7L7",
	"....L7.F7||L7|.L7L7|",
	".....|FJLJ|FJ|F7|.LJ",
	"....FJL-7.||.||||...",
	"....L---J.LJ.LJLJ...",
}

var basicMap = []string{
	".....",
	".S-7.",
	".|.|.",
	".L-J.",
	".....",
}

func TestGetLoop(t *testing.T) {
	loop := GetLoop(basicMap)
	equal(t, loop, Loop{
		{1,1}:true,
		{2,1}:true,
		{3,1}:true,
		{3,2}:true,
		{3,3}:true,
		{2,3}:true,
		{1,3}:true,
		{1,2}:true,
	})
}

func TestGetVolume(t *testing.T) {
	v := GetVolume(inputMap)
	equal(t, v, 4)
}

func TestGetVolumeComplex(t *testing.T) {
	v := GetVolume(complexMap)
	equal(t, v, 10)
}

func TestGetVolumeAgain(t *testing.T) {
	v := GetVolume(anotherMap)
	equal(t, v, 8)
}

func equal(t *testing.T, actual any, target any) {
	if !reflect.DeepEqual(actual, target) {
		t.Errorf("expected %v, got %v", target, actual)
	}
}
