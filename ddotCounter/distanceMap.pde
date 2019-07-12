IntList whitePixels = new IntList();

//function to return the image as a greyscale map of eucledian distances of white pixels from nearest black pixel
public PImage distanceMap(PImage threshedImg){
  PImage i = threshedImg;
  int white = color(255,255,255);
  int black = color(0,0,0);
  //find all the white and black pixels
  whitePixels = getCol(i,white);
  IntList blackPixels = getCol(i,black);
  float[] map = new float[whitePixels.size()];
  //find distances 
  for (int j = 0; j < map.length; j++) {
        map[j]=getDist(i,whitePixels.get(j),black);
  }
  //scale pixels greyscale value based on their distances, using the resolution parameter to determine number of different levels between the min and max
  float maxobs = max(map);
  float minobs = min(map);
  for(int j =0; j<map.length; j++){
    map[j]=round(map(map[j],minobs,maxobs,0,resolution));
  }
  maxobs = max(map);
  minobs = min(map);
  for(int j =0; j<map.length; j++){
    float val= round(map(map[j],minobs,maxobs,254,0));
    int ploc = whitePixels.get(j);
    i.pixels[ploc]=color(val,val,val);
  }
  for(int j=0; j<blackPixels.size(); j++){
    i.pixels[blackPixels.get(j)]=white;
  }
return(i);
}

//function to fetch all pixels of a given color (also used in watershed sort)
public IntList getCol(PImage i, int col){
  IntList pix = new IntList();
  for(int j=0; j < i.pixels.length; j++){
    if(i.pixels[j]==col){
      pix.append(j);
    }
  }
  return(pix);
}


//function to find the nearest black pixel, maintains speed by iteratively expanding a search square around a pixel
public float getDist(PImage i, int start_point, int col){
  float d = 0.0;
  int sx = start_point % i.width;
  int sy = start_point / i.width;
  
  boolean whitefound = false;
  boolean scanend = false;
  //will scan all pixels within a grid with scansize*2 size sides
  int scansize = 5;
  int lastscan = 0;
  
  while(whitefound == false||scanend ==false){
    scanend=false;
    for(int nx=sx-scansize; nx<sx+scansize+1; nx++){
      //skip previously scanned pixels if extended since last scan
      if(nx<sx-lastscan||nx>sx+lastscan){
        for(int ny=sy-scansize; ny<sy+scansize+1; ny++){
          if(ny<sy-lastscan||ny>sy+lastscan){
            if(nx>=0&&nx<i.width&&ny>=0&&ny<i.height){
              int nloc=nx+(ny*i.width);
              if(i.pixels[nloc]==col){
                if(whitefound==false){
                  d=dist(sx,sy,nx,ny);
                  whitefound=true;
                }else{
                  float td=dist(sx,sy,nx,ny);
                  if(td<d){d=td;}
                }
              }
            }
          }
        }
      }
    }
    scanend=true;
    lastscan=scansize;
    //exapand scan area if no pixel found
    scansize+=10;
  }
  
  return(d);
  
}
