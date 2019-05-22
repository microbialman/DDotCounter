//function to set variables to defaults for example if loading another image
public void resetVars(){
  //rgb
  rgbon=false;
  rgbCheck.setSelected(false);
  
  //greyscale
  greyscale=false;
  greyCheck.setSelected(false);
  
  //dilate
  dilate=false;
  dilCheck.setSelected(false);
    
  //thresholding
  threshon=false;
  threshCheck.setSelected(false);
  
  //gradient mapping
  mapon=false;
  mapCheck.setSelected(false);
  
  //watershed
  watCount.setText("Count");
  shedready=false;
  objCount=0;  
  
}
