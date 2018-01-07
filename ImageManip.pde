PImage img;
boolean mouseDown = false;
int saveFile = 0;
int[] pencilColor = {0, 0, 0};
int pencilWeight = 1;
final int maxPencilWeight = 100;

color[][] get2DImage() {
  color[][] twoD = new color[width][height];
  int waf = 0;
  loadPixels();
  
  for(int y = 0; y < height; y++) {
    for(int x = 0; x < width; x++) {
      twoD[x][y] = pixels[waf];
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
      pixels[wuf] = twoD[x][y];
      wuf++;
    }
  }
  
  updatePixels();
}

float colorMoy(color input) {
  return (red(input) + green(input) + blue(input)) / 3;
}

void blur(int radius) {
  color[][] twoDImg = get2DImage();
  
  for(int x = radius; x < img.width - radius; x+= radius * 2 + 1) {
    for(int y = radius; y < img.height - radius; y+= radius * 2 + 1) {
      //x et y == coordonnes du centre du blur
      //print(x + " " + y + ", ");
      
      float moyR = red(twoDImg[x][y]);
      float moyG = green(twoDImg[x][y]);
      float moyB = blue(twoDImg[x][y]);
      
      for(int i = x - radius; i <= x + radius; i++) {
        for(int j = y - radius; j <= y + radius; j++) {
          //i et j == coordonnes de tous les pixels dans le radius
          //print(i + " " + j + ", ");
          moyR = (moyR + red(twoDImg[i][j])) / 2;
          moyG = (moyG + green(twoDImg[i][j])) / 2;
          moyB = (moyB + blue(twoDImg[i][j])) / 2;
        }
      }

      for(int i = x - radius; i <= x + radius; i++) {
        for(int j = y - radius; j <= y + radius; j++) {
          twoDImg[i][j] = color(moyR, moyG, moyB);
        }
      }
    }
  }
  
  upload2D(twoDImg);
}

void binarize() {
  loadPixels();
  for(int i = 0; i < pixels.length; i++) {
    if(colorMoy(pixels[i]) > 127) pixels[i] = color(255f, 255f, 255f);
    else pixels[i] = color(0f, 0f, 0f);
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
    float newColor = colorMoy(pixels[i]);
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
  img = loadImage("shiba.jpg");    //alors evidemment (bonjour a tous) !
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
  stroke(0, 0, 0);
  text("H Flip   V Flip   Revert   Black&White   Save   Reload", 60, 655);
}

void draw() {
  //On dessine YAY ! (en fait c'etait simple (basique (mdrrrrrr c pa drol lol)))
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

void mouseClicked() {
  if(mouseY >= 640) {
    //println(mouseX);
    if(mouseX >= 60 && mouseX <= 100) stupeFlip(0);
    else if(mouseX >= 101 && mouseX <= 145) stupeFlip(1);
    else if(mouseX >= 146 && mouseX <= 200) slenderMooode();
    else if(mouseX >= 201 && mouseX <= 285) darkMooode();
    else if(mouseX >= 286 && mouseX <= 330) saveImage();
    else if(mouseX >= 331 && mouseX <= 400) image(img, 0, 0);
  }
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
  if(key == 'b') binarize();
  if(key == 'n') blur(2);
  if(key == 'c') setNewPenColor();
  if(key == 'p') if(pencilWeight + 1 < maxPencilWeight) pencilWeight++;
  if(key == 'm') if(pencilWeight - 1 > 0) pencilWeight--;
}