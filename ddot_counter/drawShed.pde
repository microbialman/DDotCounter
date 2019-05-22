color c0 = #003DFF;
color c1 = #FF0000;
color c2 = #FFC000;
color c3 = #E0FF00;
color c4 = #7EFF00;
color c5 = #21FF00;
color c6 = #00FF41;
color c7 = #00FF9F;
color c8 = #00FDFF;
color c9 = #009FFF;
color[] cols = {c0,c1,c2,c3,c4,c5,c6,c7,c8,c9};
int maxcol=cols.length;

//function to take the 'dots' found in the watershed algorithm and plot them with unique colors from the pallete above
public void drawShed(){  int curcol=0;
  IntDict colmap = new IntDict();
  for(int i=0; i<shedImg.pixels.length; i++){
    int pcatch=catchmentDefs[i];
    if(pcatch!=-2){
    if(colmap.hasKey(str(pcatch))){
      shedImg.pixels[i]=cols[colmap.get(str(pcatch))];
    }
    else{
      shedImg.pixels[i]=cols[curcol];
      colmap.set(str(pcatch),curcol);
      curcol+=1;
      if(curcol==maxcol){
        curcol=0;
      }  
    }
  }
  else{
    shedImg.pixels[i]=color(0,0,0);
  }
  }
}
