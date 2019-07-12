//function to set variable on off status to defaults for example if loading another image
//dont reset values though, might want to carry settings across to another image
public void resetVars(){
     
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
  
  //sections
  clearSecs(false);
  
}
