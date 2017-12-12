PImage img;
boolean mouseDown = false;
int saveFile = 0;
int[] pencilColor = {0, 0, 0};
int pencilWeight = 1;

color[][] get2DImage() {
  color[][] twoD = new color[width][height];
  int waf = 0;
  loadPixels();
  
  for(int y = 0; y < height; y++) {
    for(int x = 0; x < width; x++) {
      twoD[y][x] = pixels[waf];
      waf++;
    }
  }
  
  return twoD;
}

void upload2D(color[][] twoD) {
  int wuf = 0;
  
  loadPixels();  
  for(int y = 0; y < height; y++) {
    for(int x = 0; x < width; x++) {
      pixels[wuf] = twoD[y][x];
      wuf++;
    }
  }
  
  updatePixels();
}

void stupeFlip(int mode) {
  loadPixels();
  color[] newPixels = new color[img.width * img.height];

  for(int y = 0; y < img.height; y++) {
    for(int x = 0; x < width; x++) {
      if(mode == 0) newPixels[y * width + x] = pixels[y * width + (width - x)];    //flip horizontal
      if(mode == 1) newPixels[y * width + x] = pixels[(img.height - y) * width + x];  //flip vertical
    }
  }
  
  for(int i = 0; i < newPixels.length; i++) {
    pixels[i] = newPixels[i];
  }
  
  updatePixels();
}

void darkMooode() {
  loadPixels();
  for(int i = 0; i < pixels.length; i++) {
    float r = red(pixels[i]);
    float g = green(pixels[i]);
    float b = blue(pixels[i]);
    float newColor = (r + g + b) / 3;
    pixels[i] = color(newColor, newColor, newColor);
  }
  updatePixels();
}

void slenderMooode() {
  loadPixels();
  for(int i = 0; i < pixels.length; i++) {
    pixels[i]=color(255-red(pixels[i]), 255-green(pixels[i]), 255-blue(pixels[i]));
  }
  updatePixels();
}

void setup() {
  img = loadImage("shiba.jpg");
  size(480, 670);
  frameRate(30);
  background(0, 0, 0);
  image(img, 0, 0);
}

void drawMenu(int x, int y) {
  strokeWeight(0);
  fill(255, 255, 255);
  rect(x, y, width, 30);
  fill(pencilColor[0], pencilColor[1], pencilColor[2]);
  rect(5, 645, 20, 20);
  text(String.valueOf(pencilWeight), 30, 655);
}

void draw() {
  //On dessine YAY !
  //On aurait pu le faire avec un tableau, mais processing a toujours une fonction magique pour t'empecher de coder !
  stroke(pencilColor[0], pencilColor[1], pencilColor[2]);
  strokeWeight(pencilWeight);
  if(mouseDown) line(pmouseX, pmouseY, mouseX, mouseY);
  
  drawMenu(0, 640);
}

void mousePressed() {
  mouseDown = true;
}

void mouseReleased() {
  mouseDown = false;
}

void saveImage() {
  saveFrame("imagemanip-" + saveFile + ".png");
  saveFile++;
}

void setNewPenColor() {
  pencilColor[0] = (int) random(0, 255);
  pencilColor[1] = (int) random(0, 255);
  pencilColor[2] = (int) random(0, 255);
}

void keyPressed() {
  if(key == 'r') image(img, 0, 0);
  if(key == 'd') darkMooode();
  if(key == 'i') slenderMooode();
  if(key == 'f') stupeFlip(0);
  if(key == 'g') stupeFlip(1);
  if(key == 's') saveImage();
  if(key == 'c') setNewPenColor();
  if(key == 'p') if(pencilWeight + 1 < 100) pencilWeight++;
  if(key == 'm') if(pencilWeight - 1 > 0) pencilWeight--;
}