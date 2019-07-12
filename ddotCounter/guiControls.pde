//code to generate the main analysis window and handle the GUI controls
import g4p_controls.*;

//Window size
int winwidth=800;
int winheight=550;

//GUI sections
int rgbstart = 10;
int cropstart = 210;
int threshstart = 400;
int mapstart = 550;
int watstart = 690;

//pop up window for the analysis
GWindow window;
int guihei = 180;

//splash buttons
GButton btnOpenFile;
GButton btnQuit;

//gui section headings
GLabel imagemod;
GLabel cropping;
GLabel thresholding;
GLabel distmapping;
GLabel watershed;

//RGB controls
GCheckbox rgbCheck;
GSlider redSlide;
GLabel redText;
GLabel redVal;
GSlider greenSlide;
GLabel greenText;
GLabel greenVal;
GSlider blueSlide;
GLabel blueText;
GLabel blueVal;
int redv = 255;
int greenv = 255;
int bluev = 255;
Boolean rgbon = false;

//greyscale mode
Boolean greyscale = false;
GCheckbox greyCheck;

//dilate mode
Boolean dilate = false;
GCheckbox dilCheck;

//crop controls
GButton btnCircleCrop;
GButton btnSquareCrop;
GButton btnCropConfirm;
GButton btnCropCancel;
Boolean cropactive = false;

//thresholding controls
GCheckbox threshCheck;
GSlider threshSlide;
GLabel threshText;
GLabel valLabel;
int threshval = 50;
Boolean threshon = false;

//map controls
GCheckbox mapCheck;
GSlider mapSlider;
boolean mapon = false;
GSlider resSlide;
int resolution = 10;
GLabel resLabel;
GLabel resText;

//asterisk label
GLabel asterisk;

//watershed (counting) controls
GButton watCount;
GCheckbox watCheck;
boolean waton = true;
boolean shedready = false;
GLabel countTitle;
GLabel countVal;
GButton addSection;
GButton clearSections;
boolean sectionactive=false;
GButton exportDat;


//controls for buttons
void handleButtonEvents(GButton button, GEvent event) {
  //loading button from splash page
  if (button == btnOpenFile && event == GEvent.CLICKED) {
    selectInput("Select a file to process:", "fileSelected");
  }
  //quit button
  if (button == btnQuit && event == GEvent.CLICKED) {
    exit();
  }
  //circular crop
  if (button == btnCircleCrop && event == GEvent.CLICKED){
    cropShape=true;
    cropToggle();
  }
  //square crop
  if (button == btnSquareCrop && event == GEvent.CLICKED){
    cropShape=false;
    cropToggle();
  }
  //confirm a cropped area
   if (button == btnCropConfirm && event == GEvent.CLICKED){
    if(cropactive=true){
    cropToggle();
    if(midCrop==false && drawCrop==true){
      cropset=true;
      imageRefresh();
    }
    }
  }
  //cancel cropping
  if (button == btnCropCancel && event == GEvent.CLICKED){
    if(cropactive==true){
    cropToggle();
    crop1x=0;
    crop1y=0;
    crop2x=0;
    crop2y=0;
    }
    cropset=false;
    cropactive=false;
    imageRefresh();
  }
  //initiate calculation of watershed (dot counting)
  if (button == watCount && event == GEvent.CLICKED){
    watCount.setEnabled(false);
    watershedRun();
    countVal.setText(str(objCount));
    imageRefresh();
    watCount.setEnabled(true);
    watCount.setText("Re-count");
  }
  //section creation button
  if (button == addSection && event == GEvent.CLICKED){
    sectionactive=true;
  }
  //section clearing button
  if(button == clearSections && event == GEvent.CLICKED){
    clearSecs(true);
  }
    //export button
  if (button == exportDat && event == GEvent.CLICKED) {
    selectOutput("Select output destination:", "writeOutput");
  }
}

//toggle rgb filter with checkbox
public void rgbCheck_clicked(GCheckbox source, GEvent event) {
  if(source.isSelected()){
    rgbon=true;
  }
  else{
    rgbon=false;
  }
  imageRefresh();
}

//change tint based on rgb settings
public void redSlider_change(GSlider source, GEvent event) { 
  redv=round(source.getValueF());
  redVal.setText(str(redv));
  imageRefresh();
}
public void greenSlider_change(GSlider source, GEvent event) { 
  greenv=round(source.getValueF());
  greenVal.setText(str(greenv));
  imageRefresh();
}
public void blueSlider_change(GSlider source, GEvent event) { 
  bluev=round(source.getValueF());
  blueVal.setText(str(bluev));
  imageRefresh();
}

//toggle greyscale with checkbox
public void greyCheck_clicked(GCheckbox source, GEvent event) {
  if(source.isSelected()){
    greyscale=true;
  }
  else{
    greyscale=false;
  }
  imageRefresh();
}

//toggle dilate with checkbox
public void dilCheck_clicked(GCheckbox source, GEvent event) {
  if(source.isSelected()){
    dilate=true;
  }
  else{
    dilate=false;
  }
  imageRefresh();
}

//toggle threshold filter with checkbox
public void threshCheck_clicked(GCheckbox source, GEvent event) {
  if(source.isSelected()){
    threshon=true;
    mapCheck.setEnabled(true);
  }
  else{
    threshon=false;
    mapon=false;
    //can only carryout gradient mapping with threshold enabled
    mapCheck.setSelected(false);
    mapCheck.setEnabled(false);
    watCount.setEnabled(false);
  }
  imageRefresh();
}

//change threshold value based on slider value
public void threshSlider_change(GSlider source, GEvent event) { 
  threshval=round(source.getValueF());
  threshText.setText(str(threshval));
  imageRefresh();
}

//toggle gradient map display with checkbox
public void mapCheck_clicked(GCheckbox source, GEvent event) {
  if(source.isSelected()){
    mapon=true;
    //can only carryout watershed with gradient map enabled
    watCount.setEnabled(true);
  }
  else{
    mapon=false;
    watCount.setEnabled(false);
  }
  imageRefresh();
}

//change mapping resolution value based on slider value
public void resSlider_change(GSlider source, GEvent event) { 
  resolution=round(source.getValueF());
  resText.setText(str(resolution));
  imageRefresh();
}

//toggle drawing of counted dots with checkbox
public void watCheck_clicked(GCheckbox source, GEvent event) {
  if(source.isSelected()){
    waton=true;
  }
  else{
    waton=false;
  }
  imageRefresh();
}


//function to initiate an analysis window after selecting a file
//specifies location of all GUI elements
void fileSelected(File selection) {
  if (selection == null) {
  } else {
    startImg = selection.getAbsolutePath();
    //make working image a reasonable size and add space for gui at the bottom
    imageRefresh();
    
    //generate working window
    window=GWindow.getWindow(this, "DDot: "+startImg, 100, 50, winwidth, winheight+guihei, JAVA2D);
    window.addDrawHandler(this, "windowDraw");
    window.addMouseHandler(this, "windowMouse");
    window.addOnCloseHandler(this, "windowClose");
    //set close window actions as defined in windowDraw
    window.setActionOnClose(G4P.CLOSE_WINDOW);    
    
    //disable file opener as can only work on one image at a time
    btnOpenFile.setEnabled(false);

    //add controls to gui area
    int guistart=winheight+30;
    
    //RGB controls
    imagemod = new GLabel(window,rgbstart,guistart-25,200,20);
    imagemod.setText("1. Image Adjustments");
    imagemod.setTextBold();
    rgbCheck = new GCheckbox(window,rgbstart,guistart,150,20,"RGB Filter");
    rgbCheck.addEventHandler(this, "rgbCheck_clicked");
    rgbCheck.setSelected(false);
    if(rgbon==true){rgbCheck.setSelected(true);}
    redText = new GLabel(window, rgbstart, guistart+25,80,20);
    redText.setText("Red:");
    redSlide = new GSlider(window, rgbstart+50, guistart+25, 75,20,10.0);
    redSlide.setLimits(0,255);
    redSlide.setValue(redv);
    redSlide.addEventHandler(this, "redSlider_change");
    redVal = new GLabel(window, rgbstart+130, guistart+25,80,20);
    redVal.setText(str(redv));
    greenText = new GLabel(window, rgbstart, guistart+40,80,20);
    greenText.setText("Green:");
    greenSlide = new GSlider(window, rgbstart+50, guistart+40, 75,20,10.0);
    greenSlide.setLimits(0,255);
    greenSlide.setValue(greenv);
    greenSlide.addEventHandler(this, "greenSlider_change");
    greenVal = new GLabel(window, rgbstart+130, guistart+40,80,20);
    greenVal.setText(str(greenv));
    blueText = new GLabel(window, rgbstart, guistart+55,80,20);
    blueText.setText("Blue:");
    blueSlide = new GSlider(window, rgbstart+50, guistart+55, 75,20,10.0);
    blueSlide.setLimits(0,255);
    blueSlide.setValue(bluev);
    blueSlide.addEventHandler(this, "blueSlider_change");
    blueVal = new GLabel(window, rgbstart+130, guistart+55,80,20);
    blueVal.setText(str(bluev));
    
    //greyscale controls
    greyCheck=new GCheckbox(window,rgbstart,guistart+80,80,20,"Greyscale");
    greyCheck.addEventHandler(this, "greyCheck_clicked");
    greyCheck.setSelected(false);
    if(greyscale==true){greyCheck.setSelected(true);}
    
    //dilate controls
    dilCheck=new GCheckbox(window,rgbstart+90,guistart+80,80,20,"Dilate");
    dilCheck.addEventHandler(this, "dilCheck_clicked");
    dilCheck.setSelected(false);
    if(dilate==true){dilCheck.setSelected(true);}
    
    //cropping controls
    cropping=new GLabel(window,cropstart,guistart-25,200,20);
    cropping.setText("2. Image Cropping");
    cropping.setTextBold();
    btnCircleCrop = new GButton(window, cropstart, guistart, 140, 20, "Circular");
    btnSquareCrop = new GButton(window, cropstart, guistart+25, 140, 20, "Rectangular");
    btnCropConfirm = new GButton(window, cropstart, guistart+50, 65, 20, "Confirm");
    btnCropCancel = new GButton(window, cropstart+75, guistart+50, 65, 20, "Clear");
    
    //thresholding controls
    thresholding = new GLabel(window,threshstart,guistart-25,150,20);
    thresholding.setText("3. Thresholding*");
    thresholding.setTextBold();
    threshCheck=new GCheckbox(window,threshstart,guistart,100,20,"On/Off");
    threshCheck.addEventHandler(this, "threshCheck_clicked");
    threshCheck.setSelected(false);
    valLabel=new GLabel(window,threshstart,guistart+20,120,20);
    valLabel.setText("Threshold:");
    threshText=new GLabel(window,threshstart+70,guistart+20,50,20);
    threshText.setText(str(threshval));
    threshSlide = new GSlider(window,threshstart,guistart+40, 90, 20, 10.0);
    threshSlide.addEventHandler(this, "threshSlider_change");
    threshSlide.setLimits(0,100);
    threshSlide.setValue(threshval);
    
    //asterisk note
    asterisk = new GLabel(window,threshstart,guistart+125,300,30);
    asterisk.setText("*must be set before counting");
    
    //graident map controls
    distmapping = new GLabel(window,mapstart,guistart-25,150,20);
    distmapping.setText("4. Dist. Map*");
    distmapping.setTextBold();
    mapCheck=new GCheckbox(window,mapstart,guistart,90,20,"On/Off");
    mapCheck.addEventHandler(this, "mapCheck_clicked");
    mapCheck.setSelected(false);
    mapCheck.setEnabled(false);
    resLabel=new GLabel(window,mapstart,guistart+20,120,20);
    resLabel.setText("Resolution:");
    resText=new GLabel(window,mapstart+70,guistart+20,50,20);
    resText.setText(str(resolution));
    resSlide = new GSlider(window,mapstart,guistart+40, 90, 20, 10.0);
    resSlide.addEventHandler(this, "resSlider_change");
    resSlide.setLimits(2,25);
    resSlide.setValue(resolution);
    
    
    //calc watershed/dot counting controls
    watershed = new GLabel(window,watstart,guistart-25,150,20);
    watershed.setText("5. Counting");
    watershed.setTextBold();
    watCount = new GButton(window, watstart, guistart, 100, 20, "Count");
    watCount.setEnabled(false);
    watCheck=new GCheckbox(window,watstart,guistart+25,150,20,"Show Dots?");
    watCheck.addEventHandler(this, "watCheck_clicked");
    watCheck.setSelected(true);
    watCheck.setEnabled(true);
    countTitle = new GLabel(window,watstart, guistart+45,50,20);
    countTitle.setText("Total:");
    countTitle.setTextBold();
    countVal = new GLabel(window,watstart+80, guistart+45,60, 20);
    countVal.setText(str(objCount));
    addSection = new GButton(window, watstart, guistart+70, 100, 20, "Add Section");
    clearSections = new GButton(window, watstart, guistart+95, 100, 20, "Clear Sections");
    exportDat = new GButton(window, watstart, guistart+125, 100, 20, "Export");
    exportDat.setTextBold();
  }
}
