//function to draw to working window
public void windowDraw(PApplet app, GWinData data){
    app.background(0);
    //white box for the GUI elements
    app.fill(255);
    app.rect(0,window.height-guihei,window.width,guihei);
    //draw the working image in the main space
    app.image(workImg,(window.width-workImg.width)/2,((window.height-guihei)-workImg.height)/2);
    //draw crop markers if active
    if(cropactive==true){
      cropImg(app);
    }
}

//handler for clicks in the window, required for no GUI events
public void windowMouse(PApplet app, GWinData data, MouseEvent event){
    if(event.getAction() == MouseEvent.CLICK){
      croppingCheck(app.mouseX,app.mouseY);
    }
}
