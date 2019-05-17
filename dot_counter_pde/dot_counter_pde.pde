//initiation page that allows loading of image into analysis window
PImage logo;
//image to analyse
String startImg;
PImage workImg;
//image that will hold dot pixel colours
PImage shedImg;
boolean loading=false;


//initiate variables and define splash page
void setup() {
  size(500,140);
  colorMode(RGB);
  background(255);
  logo = loadImage("logo.png");
  //place nice greeen buttons
  btnOpenFile = new GButton(this, 10, 110, 140, 20, "Select File");
  btnQuit = new GButton(this, 170, 110, 140, 20, "Quit");
  btnOpenFile.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  btnQuit.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  smooth();
  guihei=140;
}

//draw the splash page
void draw(){
  background(255);
  image(logo, 10, 10);
}
