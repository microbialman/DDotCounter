//variables to control interface when selecting a new section
boolean midSection = false;
boolean drawSection = false;

//store the section coordinates, names and dot counts
ArrayList<int[]> sectionList = new ArrayList<int[]>();
ArrayList<String> sectionNames = new ArrayList<String>();
ArrayList<Integer> sectionCounts = new ArrayList<Integer>();

//coordinates when selections sections
int sec1x;
int sec2x;
int sec1y;
int sec2y;

//store the section data
public void makeSection(){
  int maxsec = sectionNames.size();
  int[] coords = {sec1x,sec1y,sec2x,sec2y};
  sectionList.add(coords);
  sectionNames.add("Sec_"+str(maxsec+1));
  sectionCounts.add(0);
  drawSection=false;
  sectionactive=false;
  if(objCount>0){
    countSecs(sectionNames.size()-1);
  }
}

//count number of dots in a section
public void countSecs(int sec){
  //convert coordinates to image space (from window space)
  int[] coords = sectionList.get(sec);
  int pix1x=coords[0]-((winwidth-workImg.width)/2);
  int pix1y=coords[1]-((winheight-workImg.height)/2);
  int pix2x=coords[2]-((winwidth-workImg.width)/2);
  int pix2y=coords[3]-((winheight-workImg.height)/2);
  
  //list to store what dots we see in the section
  ArrayList<Integer> dots = new ArrayList<Integer>();
  
  //parse the pixels in the section and count unique dots
  for(int i=min(pix1x,pix2x); i<max(pix1x,pix2x);i++){
    for(int j=min(pix1y,pix2y); j<max(pix1y,pix2y);j++){
      int loc = i + j*workImg.width;
      int val = catchmentDefs[loc];
      if(dots.contains(val)){}
     else if(val!=-2){dots.add(val);}
    }
  }
  
  //add count to list
  sectionCounts.set(sec,dots.size());
}

//draw the borders of defined sections onto the image
public void drawSections(PApplet app){
   for(int i=0; i<sectionNames.size(); i++){
     String name = sectionNames.get(i);
     int count = sectionCounts.get(i);
     int[] coords = sectionList.get(i);
     app.noFill();
     app.stroke(180);
     app.rectMode(CORNERS);
     app.rect(coords[0],coords[1],coords[2],coords[3]);
     app.rectMode(CORNER);
     app.fill(180);
     app.textSize(12);
     app.text(name+" "+str(count),min(coords[0],coords[2]),min(coords[1],coords[3])+10);
   }
}

//clear all sections
public void clearSecs(boolean fullwipe){
if(fullwipe==false){
for(int i=0; i<sectionCounts.size();i++){
  sectionCounts.set(i,0);
}
}
else{
sectionList = new ArrayList<int[]>();
sectionNames = new ArrayList<String>();
sectionCounts = new ArrayList<Integer>();
}
midSection = false;
drawSection = false;
sectionactive=false;
}

//function for selection of sections of image
public void selSection(PApplet app){
  int mx = app.mouseX;
  int my = app.mouseY;
   
  //get the area of the image in the window space
  int imgXend=workImg.width+((winwidth-workImg.width)/2);
  int imgXstart=(winwidth-workImg.width)/2;
  int imgYend=workImg.height+((winheight-workImg.height)/2);
  int imgYstart=(winheight-workImg.height)/2;
  
  //only active if cursor is in the image area
  if(mx>imgXstart && mx<imgXend && my>imgYstart && my<imgYend){
    //draw cross-hair
    app.noCursor();
    app.stroke(125);
    app.line(mx-cs,my,mx+cs,my);
    app.line(mx,my-cs,mx,my+cs);
    //set area status
    inArea=true;
    //set preview positions
    if(midSection==true){
      sec2x=mx;
      sec2y=my;
    }
  }
  //turn the cursor on and off with the cross hair
  else{
    app.cursor();
    inArea=false;
  }
  //if active draw where the section would be to current mouse position
  if(drawSection==true){
    app.noFill();
    app.stroke(125);
    app.rectMode(CORNERS);
    app.rect(sec1x,sec1y,sec2x,sec2y);
    app.rectMode(CORNER); 
  }
}


//function to action section selection on mouse clicks
public void sectionCheck(int xpos, int ypos, PApplet app){
  if(inArea==true){
    //if in middle of section definition
    if(midSection==false){
      sec1x=xpos;
      sec1y=ypos;
      drawSection=true;
      midSection=true;
    }
    else{
      makeSection();
      midSection=false;
      app.cursor();
    }
  }
}
