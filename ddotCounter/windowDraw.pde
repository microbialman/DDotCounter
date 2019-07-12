//function to draw to working window
public void windowDraw(PApplet app, GWinData data){
    app.background(0);
    //white box for the GUI elements
    app.fill(255);
    app.rect(0,window.height-guihei,window.width,guihei);
    app.image(workImg,(window.width-workImg.width)/2,((window.height-guihei)-workImg.height)/2);
    if(waton==true && shedready==true){
     app.image(shedImg,(window.width-workImg.width)/2,((window.height-guihei)-workImg.height)/2);
    }
    //draw crop and section markers if selection mode is active
    if(cropactive==true){
      cropImg(app);
    }
    else if(sectionactive==true){
      selSection(app);
    }
    //draw the sections on if any have been selected
  if(sectionNames.size()>0){
    drawSections(app);
  }
  //export the processed image
  if(exportImage==true){
    int tlx=(winwidth-workImg.width)/2;
    int tly=((window.height-guihei)-workImg.height)/2;
    PImage procImg = app.get(tlx,tly,workImg.width,workImg.height);
    procImg.save(outfile+".jpg");
    exportImage=false;  
}
}

//handler for clicks in the window, required for no GUI events
public void windowMouse(PApplet app, GWinData data, MouseEvent event){
    if(event.getAction() == MouseEvent.CLICK){
      if(cropactive==true&&sectionactive==false){
      croppingCheck(app.mouseX,app.mouseY);}
      else if(sectionactive==true){
      sectionCheck(app.mouseX,app.mouseY,app);}
    }
}

//handler for actions on window close
public void windowClose(GWindow window){
  //reenable file open button
  btnOpenFile.setEnabled(true);
  //reset variables
  resetVars();
}
