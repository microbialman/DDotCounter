//cross hair sizer
int cs=20;

//crop coords
int crop1x;
int crop1y;
int crop2x;
int crop2y;


//set control vars
boolean cropset=false;
boolean inArea=false;
boolean drawCrop=false;
//circular crop is true
boolean cropShape=true;

//controlling vars
boolean midCrop=false;

//function for cropping image
public void cropImg(PApplet app){
  int mx = app.mouseX;
  int my = app.mouseY;
   
  //get the croppable area
  int imgXend=workImg.width+((winwidth-workImg.width)/2);
  int imgXstart=(winwidth-workImg.width)/2;
  int imgYend=workImg.height+((winheight-workImg.height)/2);
  int imgYstart=(winheight-workImg.height)/2;
  
  //only active if cursor is in the croppable area
  if(mx>imgXstart && mx<imgXend && my>imgYstart && my<imgYend){
    //draw cropping cross-hair
    app.noCursor();
    app.stroke(125);
    app.line(mx-cs,my,mx+cs,my);
    app.line(mx,my-cs,mx,my+cs);
    //set area status
    inArea=true;
    //set cropping preview positions
    if(midCrop==true){
      crop2x=mx;
      crop2y=my;
    }
  }
  else{
    app.cursor();
    inArea=false;
  }
  
  //draw the croppable area
  if(drawCrop==true){
    app.noFill();
    app.stroke(125);
    //circle
    if(cropShape==true){
      app.ellipseMode(CENTER);
      app.circle(crop1x,crop1y,dist(crop1x,crop1y,crop2x,crop2y)*2);
    }//rect
    else{
      app.rectMode(CORNERS);
      app.rect(crop1x,crop1y,crop2x,crop2y);
      app.rectMode(CORNER);
    }
  }
  
}

//function to action cropping on mouse clicks
public void croppingCheck(int xpos, int ypos){
  if(inArea==true){
    if(midCrop==false){
      crop1x=xpos;
      crop1y=ypos;
      drawCrop=true;
      midCrop=true;
    }
    else{
      midCrop=false;
    }
  }
}

//function to carry out cropping (make pixels outside selected area black)
public void drawCrop(){
  //translate the global pixels to locations in the image
  int pix1x=crop1x-((winwidth-workImg.width)/2);
  int pix1y=crop1y-((winheight-workImg.height)/2);
  int pix2x=crop2x-((winwidth-workImg.width)/2);
  int pix2y=crop2y-((winwidth-workImg.width)/2);
  
  //rectangular crop
  if(cropShape==false){
   for(int j=0; j<workImg.pixels.length; j++){
    int px = j % workImg.width;
    int py = j / workImg.width;
    if(px<pix1x||px>pix2x||py<pix1y||py>pix2y){
      workImg.pixels[j]=color(0,0,0);
    }
   }
  }
  
  //circular crop
  if(cropShape==true){
    for(int j=0; j<workImg.pixels.length; j++){
    int px = j % workImg.width;
    int py = j / workImg.width;
    if(dist(pix1x,pix1y,px,py)>dist(pix1x,pix1y,pix2x,pix2y)){
       workImg.pixels[j]=color(0,0,0);
    }
   }
  }
  



}
