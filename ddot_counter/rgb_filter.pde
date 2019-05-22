//function to carry out basic RGB filtering of the image
public PImage rgbFilter(PImage img,int rval,int gval,int bval){
  for (int x = 0; x < img.width; x++) {
  for (int y = 0; y < img.height; y++ ) {
    // Calculate the 1D pixel location
    int loc = x + y*img.width;
    //get current values
    float cr = red (img.pixels[loc]);
    float cg = green (img.pixels[loc]);
    float cb = blue (img.pixels[loc]);
    if(cr>rval){cr=rval;}
    if(cg>gval){cg=gval;}
    if(cb>bval){cb=bval;}
    // Make a new color and set pixel in the window
    color c = color(cr,cg,cb);
    img.pixels[loc] = c;
    }
  }
  return(img);
}
