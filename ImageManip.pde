PImage img;
PImage ui;

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
      //x et y sont les coordonnees du centre d'application du flou
      
      float moyR = red(twoDImg[x][y]);
      float moyG = green(twoDImg[x][y]);
      float moyB = blue(twoDImg[x][y]);
      
      for(int i = x - radius; i <= x + radius; i++) {
        for(int j = y - radius; j <= y + radius; j++) {
          //i et j sont les coordonnees de tous les points appartenant au radius du flou
          //mise a jour des composantes r g b du flou
          moyR = (moyR + red(twoDImg[i][j])) / 2;
          moyG = (moyG + green(twoDImg[i][j])) / 2;
          moyB = (moyB + blue(twoDImg[i][j])) / 2;
        }
      }

      for(int i = x - radius; i <= x + radius; i++) {
        for(int j = y - radius; j <= y + radius; j++) {
          //on applique la couleur que l'on vient de calculer a tous les pixels de la zone
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

void flip(int mode) {
  loadPixels();
  color[] newPixels = new color[img.width * img.height];

  //on aurait pu le faire avec des tableaux en 2 dimensions, mais il est tout aussi simple de calculer les coordonnees sur le tableau unidimensionnel

  for(int y = 0; y < img.height; y++) {
    for(int x = 0; x < width; x++) {
      if(mode == 0) newPixels[y * width + x] = pixels[y * width + (width - x)];    //flip horizontal
      if(mode == 1) newPixels[y * width + x] = pixels[(img.height - y - 1) * width + x];  //flip vertical
    }
  }
  
  for(int i = 0; i < newPixels.length; i++) {
    pixels[i] = newPixels[i];
  }
  
  updatePixels();
}

void blackAndWhite() {
  loadPixels();
  for(int i = 0; i < pixels.length; i++) {
    float newColor = colorMoy(pixels[i]);
    pixels[i] = color(newColor, newColor, newColor);
  }
  updatePixels();
}

void reverseColors() {
  loadPixels();
  for(int i = 0; i < pixels.length; i++) {
    pixels[i]=color(255-red(pixels[i]), 255-green(pixels[i]), 255-blue(pixels[i]));
  }
  updatePixels();
}

void setup() {
  img = loadImage("shiba.jpg");    //les shibas, c'est mignon :3
  ui = loadImage("boutons.png");   //boutons de l'inteface
  size(480, 680);
  frameRate(30);
  background(0, 0, 0);
  image(img, 0, 0);
}

void drawMenu(int x, int y) {
  strokeWeight(0);
  image(ui, x, y);
  fill(pencilColor[0], pencilColor[1], pencilColor[2]);
  rect(x + 2, y + 2, 36, 36);
  fill(255, 255, 255);
  text(String.valueOf(pencilWeight), x + 10, y + 20);
}

void draw() {
  //On dessine YAY ! (on cree une ligne entre la derniere position de la souris et sa position actuelle)
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
    if(mouseX >= 40 && mouseX <= 79) {
      if(mouseY < 660 && pencilWeight + 1 < maxPencilWeight) pencilWeight++;
      else if(mouseY >= 660 && pencilWeight - 1 > 1) pencilWeight--;
    }
    else if(mouseX >= 80 && mouseX <= 119) setNewPenColor();
    else if(mouseX >= 120 && mouseX <= 159) binarize();
    else if(mouseX >= 160 && mouseX <= 199) blackAndWhite();
    else if(mouseX >= 200 && mouseX <= 239) reverseColors();
    else if(mouseX >= 240 && mouseX <= 279) flip(0);
    else if(mouseX >= 280 && mouseX <= 319) flip(1);
    else if(mouseX >= 320 && mouseX <= 359) blur(2);
    else if(mouseX >= 360 && mouseX <= 399) saveImage();
    else if(mouseX >= 400 && mouseX <= 439) image(img, 0, 0);
    else if(mouseX >= 440 && mouseX <= 480) exit();
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
  if(key == 'd') blackAndWhite();
  if(key == 'i') reverseColors();
  if(key == 'f') flip(0);
  if(key == 'g') flip(1);
  if(key == 's') saveImage();
  if(key == 'b') binarize();
  if(key == 'n') blur(2);
  if(key == 'c') setNewPenColor();
  if(key == 'p') if(pencilWeight + 1 < maxPencilWeight) pencilWeight++;
  if(key == 'm') if(pencilWeight - 1 > 1) pencilWeight--;
}