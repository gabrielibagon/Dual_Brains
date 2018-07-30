import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class quickSpectrogram extends PApplet {

float[] dataSet;

public void setup(){
  dataSet = new float[125];
  repopulateFakeData();
  
  background(0);
  frameRate(30);
}

public void draw(){
  noStroke();
  //copy(sourceX, sourceY, sourceW, sourceH, dx, dy, dw, dh)
  copy(0,0,width,height, 1,0, width, height);
  for(int i = 0; i < 125; i++){
    set(0, i, color((int)map(dataSet[i], 0, 100, 0, 255)));
    println((int)map(dataSet[i], 0, 100, 0, 255));
  }
  repopulateFakeData();
}


public void repopulateFakeData(){
  int i = 0;
  for(float num : dataSet){
    dataSet[i] = random(0,100);
    i++;
  }
}
  public void settings() {  size(800,125); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "quickSpectrogram" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
