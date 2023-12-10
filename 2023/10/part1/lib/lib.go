
package part1

import (
	"bufio"
	"strings"
)

var Tiles = map[byte][2][2]int{
	'|': {{0,-1}, {0,1}},
	'-': {{-1,0}, {1,0}},
	'L': {{0,-1}, {1,0}},
	'J': {{0,-1}, {-1,0}},
	'7': {{0,1}, {-1,0}},
	'F': {{0,1}, {1,0}},
}

func ReadMap(scanner *bufio.Scanner) (res []string) {
	for scanner.Scan() {
		res = append(res, scanner.Text())
	}
	return
}

func FindStart(pipeMap []string) (x,y int) {
	for y = range pipeMap {
		if x = strings.IndexRune(pipeMap[y], 'S'); x > -1 {
			return
		}
	}
	return -1, -1
}

func FindFirst(pipeMap []string, sx,sy int) (int, int, int) {
	for y := sy-1; y <= sy+1;y++ {
		if y < 0 || y >= len(pipeMap) {
			continue
		}
		for x := sx-1; x <= sx+1 ;x++ {
			if x < 0 || x >= len(pipeMap[y]) {
				continue
			}
			side, ok := GetSide(pipeMap, sx,sy, x,y)
			if ok {
				return side,x,y
			}
		}
	}
	return -1, -1, -1
}

func GetSide(pipeMap []string, px,py, x,y int) ( int, bool ) {
	tile := pipeMap[y][x]
	dirs, ok := Tiles[tile]
	if !ok {
		return -1, false
	}
	for i,dir := range dirs {
		if x + dir[0] == px && y + dir[1] == py {
			return i, true
		}
	}
	return -1, false
}


func FindNext(pipeMap []string, side, x,y int) (int,int,int) {
	tile := pipeMap[y][x]

	dir := Tiles[tile][1-side]

	nx,ny := x+dir[0], y+dir[1]

	nside, _ := GetSide(pipeMap, x,y, nx,ny)
	return nside,nx,ny
}

func LoopSize(pipeMap []string) int {
	x,y := FindStart(pipeMap)
	side,x,y := FindFirst(pipeMap, x,y)
	count := 1
	for pipeMap[y][x] != 'S' {
		count++
		side,x,y = FindNext(pipeMap, side, x,y)
	}
	return count

}

