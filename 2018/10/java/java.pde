float[][] points = new float[370][4];
float[] min = new float[] {0, 0},
        max = new float[] {0, 0},
        cen = new float[] {0, 0},
        size = new float[] {0, 0},
        tr = new float[] {0, 0};
float zoom = 10;
float speed = 1;
float time = 0;

void setup(){
  String[] lines = loadStrings("../input.txt");
  for (int l = 0; l < lines.length; l++) {
    String[][] matches = matchAll(lines[l], "< *(-?\\d+), *(-?\\d+)>");
    if (matches.length == 2){
      points[l] = new float[]{
        Integer.parseInt(matches[0][1]),
        Integer.parseInt(matches[0][2]),
        Integer.parseInt(matches[1][1]),
        Integer.parseInt(matches[1][2])
      };
      for (int d = 0; d < 2; d++) {
        min[d] = min(min[d], points[l][d]);
        max[d] = max(max[d], points[l][d]);
      }
    }
  }
  size(500, 500);
  frameRate(30);
  background(200);
}

void draw() {
	background(200);

	// centering the image
	size = new float[]{
		(max[0]-cen[0])-(min[0]-cen[0]),
		(max[1]-cen[1])-(min[1]-cen[1])
	};
	cen = new float[]{(max[0]+min[0])/2, (max[1]+min[1])/2};

  for (int i = 0; i < points.length; i++) {
		// drawing the image
    rect(width/2 + (points[i][0]-cen[0]+tr[0]) * zoom, height/2 + (points[i][1]-cen[1]+tr[1]) * zoom, zoom, zoom);
		// move the points
    points[i][0] += points[i][2]*((speed * speed * speed)/frameRate);
    points[i][1] += points[i][3]*((speed * speed * speed)/frameRate);
		// centering the image
    max = new float[]{max(max[0], points[i][0]), max(max[1], points[i][1])};
    min = new float[]{min(min[0], points[i][0]), min(min[1], points[i][1])};
  }
	time += ((speed * speed * speed)/frameRate);
	text("time: "+time,width/2,10);
	point(width/2, height/2);
	if (keyPressed){
		if (key == ' '){
			save("frames/"+frameCount+".jpg");
		} else if (key == '<') {
			speed -= 0.1;
		} else if (key == '>') {
			speed += 0.1;
		} else if (key == ',') {
			speed -= 0.01;
		} else if (key == '.') {
			speed += 0.01;
		} else if (key == '/') {
			speed = 0;
		} else if (key == '-') {
			zoom /= 1.2;
		} else if (key == '=') {
			zoom *= 1.2;
		} else if (keyCode == 37) {
			tr[0] += sqrt(zoom)/3;
		} else if (keyCode == 39) {
			tr[0] -= sqrt(zoom)/3;
		} else if (keyCode == 38) {
			tr[1] += sqrt(zoom)/3;
		} else if (keyCode == 40) {
			tr[1] -= sqrt(zoom)/3;
		}
		if (zoom <= 0) {
			zoom = abs(zoom) + 1;
		}
	}
}
