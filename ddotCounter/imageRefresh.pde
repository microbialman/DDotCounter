//function controlling what is displayed as the work image 
//order of events is important here e.g. watershed must be calculated on the thresholded image
public void imageRefresh(){
  workImg=loadImage(startImg);
  if(workImg.width>winwidth){
    workImg.resize(winwidth,0);
  }
  if(workImg.height>winheight){
    workImg.resize(0,winheight);
  }
  if(cropset==true){
    drawCrop();
  }
  shedImg=new PImage(workImg.width,workImg.height);
  if(rgbon==true){
    workImg=rgbFilter(workImg,redv,greenv,bluev);
  }
  if(dilate==true){
    workImg.filter(DILATE);
  }
  if(greyscale==true){
    workImg.filter(GRAY);
  }
  if(threshon==true){
    workImg.filter(THRESHOLD, threshval/100.0);
  }
  if(mapon==true){
    workImg=distanceMap(workImg);
  }
  //only draw dots if the watershed calculation has completed
  if(waton==true && shedready==true){
    drawShed();
  }
}
