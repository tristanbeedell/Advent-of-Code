
package part1

import (
	"testing"
	"reflect"
	"bufio"
	"strings"
)

const basicInput =
	".....\n" +
	".S-7.\n" +
	".|.|.\n" +
	".L-J.\n" +
	".....\n"

var basicMap = []string{
	".....",
	".S-7.",
	".|.|.",
	".L-J.",
	".....",
}

const complexInput = 
	"7-F7-\n" +
	".FJ|7\n" +
	"SJLL7\n" +
	"|F--J\n" +
	"LJ.LJ\n"

var complexMap = []string{
	"7-F7-",
	".FJ|7",
	"SJLL7",
	"|F--J",
	"LJ.LJ",
}

func TestReadMap(t *testing.T) {
	reader := bufio.NewScanner(strings.NewReader(basicInput));
	pipes := ReadMap(reader)
	equal(t, pipes, basicMap)
}

func TestReadMapComplex(t *testing.T) {
	reader := bufio.NewScanner(strings.NewReader(complexInput));
	pipes := ReadMap(reader)
	equal(t, pipes, complexMap)
}

func TestFindStart(t *testing.T) {
	x,y := FindStart(basicMap)
	equal(t, x, 1)
	equal(t, y, 1)
}

func TestFindStartComplex(t *testing.T) {
	x,y := FindStart(complexMap)
	equal(t, x, 0)
	equal(t, y, 2)
}

func TestFindFirstBasic(t *testing.T) {
	x,y := 1,1
	side,newX,newY := FindFirst(basicMap, x,y)
	equal(t, side, 0)
	equal(t, newX, 2)
	equal(t, newY, 1)
}

func TestFindFirstComplex(t *testing.T) {
	x,y := 0, 2
	side,newX,newY := FindFirst(complexMap, x,y)
	equal(t, side, 1)
	equal(t, newX, 1)
	equal(t, newY, 2)
}

func TestGetSide(t *testing.T) {
	side,ok := GetSide(basicMap, 1,1, 2,1)
	equal(t, side, 0)
	equal(t, ok, true)
}

func TestFindNext(t *testing.T) {
	cx,cy := 2,1

	s,nx,ny := FindNext(basicMap, 0, cx,cy)
	equal(t, nx, 3)
	equal(t, ny, 1)

	s,nx,ny = FindNext(basicMap, s, nx,ny)
	equal(t, nx, 3)
	equal(t, ny, 2)

	s,nx,ny = FindNext(basicMap, s, nx,ny)
	equal(t, nx, 3)
	equal(t, ny, 3)

	s,nx,ny = FindNext(basicMap, s, nx,ny)
	equal(t, nx, 2)
	equal(t, ny, 3)

	s,nx,ny = FindNext(basicMap, s, nx,ny)
	equal(t, nx, 1)
	equal(t, ny, 3)

	s,nx,ny = FindNext(basicMap, s, nx,ny)
	equal(t, nx, 1)
	equal(t, ny, 2)

	s,nx,ny = FindNext(basicMap, s, nx,ny)
	equal(t, nx, 1)
	equal(t, ny, 1)
}

func TestLoopSize(t *testing.T) {
	size := LoopSize(basicMap)
	equal(t, size, 8)
	size = LoopSize(complexMap)
	equal(t, size, 16)
}

func equal(t *testing.T, actual any, target any) {
	if !reflect.DeepEqual(actual, target) {
		t.Errorf("expected %v, got %v", target, actual)
	}
}

