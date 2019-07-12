boolean exportImage=false;
String outfile;

//write out a text file with the parameters used and the resultant counts for total and any sub sections
void writeOutput(File selection){
  if (selection == null) {
  } else {
    //write out a csv of the results
    outfile = selection.getAbsolutePath();
    PrintWriter output = createWriter(outfile+".csv");
    output.println("Filename:,"+outfile);
    output.println("\nTotal Count:,"+str(objCount));
    output.println("\nSection Counts");
    for(int i=0; i<sectionNames.size(); i++){
    output.println(sectionNames.get(i)+":,"+str(sectionCounts.get(i)));
    }
    output.println("\nCount Settings");
    output.println("RGB Filter:,"+str(rgbon));
    output.println("RGB Vals:,"+str(redv)+"-"+str(greenv)+"-"+str(bluev));
    output.println("Greyscale:,"+str(greyscale));
    output.println("Dilate:,"+str(dilate));
    output.println("Image Cropped:,"+str(cropset));
    output.println("Threshold:,"+str(threshval));
    output.println("Resolution:,"+str(resolution));
    output.flush();
    output.close();
    //export image
    exportImage=true;
  }
}
