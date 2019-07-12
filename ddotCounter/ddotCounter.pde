//initiation page that allows loading of image into analysis window
PImage logo;
PImage titlebaricon;
//image to analyse
String startImg;
PImage workImg;
//image that will hold dot pixel colours
PImage shedImg;
int bhei = 180;
int bwid = 50;


//initiate variables and define splash page
void setup() {
  //small window to load files from
  size(420,210);
  colorMode(RGB);
  background(255);
  logo = loadImage("data/logo.png");
  logo.resize(400,0);
  //set window title and icon
  surface.setTitle("DDot Counter");
  titlebaricon = loadImage("data/icon.png");
  surface.setIcon(titlebaricon);
  //place file select and quit buttons and set custom color scheme
  g4p_controls.G4P.setGlobalColorScheme(8);
  btnOpenFile = new GButton(this, bwid, bhei, 140, 20, "Select File");
  btnQuit = new GButton(this, 180+bwid, bhei, 140, 20, "Quit");
  GLabel verNum = new GLabel(this, 320+bwid, bhei-30, 140, 20, "v1.0.0");
}

//draw the splash page
void draw(){
  background(255);
  image(logo, 10, 10);
}
