//the watershed function is used to find the 'dots' in the image - using the pointer based algorithm from Bieniek & Moga 2000
//this is based on using a gradient map of the distances between black and white pixels and finding the local minima by following pointers between neighbouring pixels
int[] point;
int[] catchmentDefs;
int objCount =0;

//control overall watershed calculation
public void watershedRun(){
  point=new int[workImg.pixels.length];
  firstPass(whitePixels);
  secondPass(whitePixels);
  thirdPass(whitePixels);
  fourthPass(whitePixels);
  //relabel pixels to their dots
  catchmentDefs=reLabel(point);
  //get total dot count
  objCount=max(catchmentDefs);
  shedready=true;
  //if sections have been defined, count their dots
  if(sectionNames.size()>0){
    for(int i=0; i<sectionNames.size();i++){
      countSecs(i);
    }
  }
}

//function to generate the final labels numbered 1 to n dots
public int[] reLabel(int[] curlab){
  IntDict mapping = new IntDict();
  int[] newlabs = new int[curlab.length];
  int label=1;
  for(int i=0; i<curlab.length; i++){
    if(whitePixels.hasValue(i)==false){
      newlabs[i]=-2;
    }
    else{
      int cur=curlab[i];
      if(mapping.hasKey(str(cur))){
        newlabs[i]=mapping.get(str(cur));
      }
      else{
        newlabs[i]=label;
        mapping.set(str(cur),label);
        label+=1;
      }
    }
  }
  return(newlabs);
}


//run a rainfall algorithm for watershed segmentation (Bieniek & Moga 2000, Kornilov & Safonov 2018)
//first pass to set pointers for each pixel to lowest neighbouring pixel
public void firstPass(IntList whitePixels){
  for(int j=0; j<whitePixels.size(); j++){
    int p = whitePixels.get(j);
    int q=p;
    IntList neis = getNeighbours(workImg,p);
    for(int k=0; k<neis.size();k++){
      if(red(workImg.pixels[neis.get(k)])<red(workImg.pixels[p])){
        if(red(workImg.pixels[neis.get(k)])<red(workImg.pixels[q])){
          q=neis.get(k);
        }
      }
    }
    if(q!=p){point[p]=q;}
    else{point[p]=-1;}
  }
}

//second pass to remove non-minimal plateaus
public void secondPass(IntList whitePixels){
  IntList fifo = new IntList();
  //add plateau neighbouts with matching vals to the fifo
  for(int j=0; j<whitePixels.size(); j++){
    int p = whitePixels.get(j);
    //if a plateau parse
    if(point[p]==-1){
      IntList neis=getNeighbours(workImg,p);
      for(int k=0; k<neis.size();k++){
        //if not a plateu and same value as p
        if(point[neis.get(k)]!=-1 && red(workImg.pixels[neis.get(k)])==red(workImg.pixels[p])){
          fifo.append(neis.get(k));
          break;
      }
    }
  }
  }
  
  //fifo parsing
  while(fifo.size()!=0){
    int pf=fifo.remove(0);
    IntList neisf=getNeighbours(workImg,pf);
    for(int k=0; k<neisf.size(); k++){
      if(point[neisf.get(k)]==-1 && workImg.pixels[neisf.get(k)]==workImg.pixels[pf]){
        point[neisf.get(k)]=pf;
        fifo.append(neisf.get(k));
      }
    }
  }
}

//third pass mark the minimum plateaus to point to self
public void thirdPass(IntList whitePixels){
  for(int j=0; j<whitePixels.size(); j++){
    int p = whitePixels.get(j);
    if(point[p]==-1){
      point[p]=p;
      IntList neis=getNeighbours(workImg,p);
      for(int k=0; k<neis.size(); k++){
        //add an additional rule here that must be same altitude (greyscale value) (this is missing in the Bieniek & Moga pseudocode)
        if(neis.get(k)<p && red(workImg.pixels[neis.get(k)])==red(workImg.pixels[p])){
          int r=find(p);
          int r2=find(neis.get(k));
          int minv = min(r,r2);
          point[r]=minv;
          point[r2]=minv;
        }
      }
    }
  }
}

//final scan
public void fourthPass(IntList whitePixels){
  for(int j=0; j<whitePixels.size(); j++){
    int p = whitePixels.get(j);
    point[p]=find(p);
  }
}

//function that follows the path of pointers to find minima
public int find(int u){
  int r=u;
  while(point[r]!=r){
    r=point[r];
  }
  int w=u;
  int tmp=point[w];
  while(w!=r){
    tmp=point[w];
    point[w]=r;
    w=tmp;
  }
  return(r);
}

//function to grab the neighbouring pixels (8 surrounding)
public IntList getNeighbours(PImage i, int loc){
  IntList neis = new IntList();
  int lx = loc % i.width;
  int ly = loc / i.width;
  for(int j=lx-1; j<lx+2; j++){
    for(int k=ly-1; k<ly+2; k++){
      //dont include starting point in the neighbour list
      if(lx==j && ly==k){}
      //account for edge cases
      else if(j>=0 && j<i.width && k>=0 && k<i.height){
        int nloc=j+(k*i.width);
        if(whitePixels.hasValue(nloc)){
        neis.append(nloc);}
      }
    }
  }
  neis.sort();
  return(neis);
}
