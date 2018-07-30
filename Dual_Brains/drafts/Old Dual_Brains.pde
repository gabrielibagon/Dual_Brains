/*-----------
 Dual Brains Data Viz - R2
 This sketch should
 1. initialized necessary Graph objects & a UDP object
 2. Parse data read via UDP object and pipe the correct data into the Graph objects
 ------------- */

// Networking 
import hypermedia.net.*;
import java.util.Scanner;
int PORT_RX=6100; //port
String HOST_IP="127.0.0.1"; //
UDP udp;
boolean isReceivingData = false;

// Controls
Controls controls;

// Visualization
boolean handsTouching;
boolean DEBUG = false;

LineGraph g, g2;
Spectrogram s, s2;
float[][] data_list;
PImage backgroundImg;
ArrayList <Point> leftPoints;
ArrayList <Point> rightPoints;

float[] subj1_eeg;
float[] subj1_heart;
float[] subj1_fft;

float[] subj2_eeg;
float[] subj2_fft;
float[] subj2_heart;

float[] newData;
float[] newData2;
float[] newData3;




void settings() {
  fullScreen(P3D, 2);
  //change for single screen display: 
  //fullScreen(P3D);
  smooth();
}

void setup() {
  frameRate(20);
  background(0);
  backgroundImg = loadImage("GradientBackground-640.jpg");
  
  controls = new Controls();

  handsTouching = false;
  //Setting up array list for Points
  leftPoints = new ArrayList<Point>();
  rightPoints = new ArrayList<Point>();


  //Test Graph
  //Graph(float SAMPLE_RATE, int TIME_WINDOW, float SCALE, int ORIGIN_X, int ORIGIN_Y){
  //LineGraph(int CHANNELS, float UPPER_LIM, float LOWER_LIM, float SAMPLE_RATE, int TIME_WINDOW, float SCALE, float ORIGIN_X, float ORIGIN_Y,  boolean IS_ON_LEFT){
  g = new LineGraph(6, 250, -250, 20, 9, width*0.003, width*0 - 20, height*1.05, true);
  g2 = new LineGraph(6, 250, -250, 20, 9, width*0.003, width*0.5 - 20, height*1.05, false);

  //Spectrogram graph
  // Spectrogram(int DATAPOINTS, float UPPER_LIM, float LOWER_LIM, float SAMPLE_RATE, int TIME_WINDOW, float SCALE, float ORIGIN_X, float ORIGIN_Y) {
  s = new Spectrogram(32, 10, 0, 9, 4, width*0.0125, width*0-(width*0.035), -20, true);
  s2 = new Spectrogram(32, 10, 0, 9, 4, width*0.0125, width*0.5-(width*0.035), -20, false);

  //Set DeBug to False for Gabe FrameRate Test
  g.debugMode = DEBUG;
  s.debugMode = DEBUG;
  g2.debugMode = DEBUG;
  s2.debugMode = DEBUG;

  //***********************************
  //NETWORKING
  //THIS MUST BE INCLUDED IN YOUR SETUP
  udp= new UDP(this,PORT_RX,HOST_IP);
  udp.log(false);
  udp.listen(true);
  super.start();
  //***********************************

  subj1_eeg = new float[6];
  subj1_heart = new float[1];
  subj2_eeg = new float[6];
  subj2_heart = new float[1];
  subj1_fft = new float[32];
  subj2_fft = new float[32];
  
  newData = new float[8];
  newData2 = new float[s.dataPoints];
  newData3 = new float[1];
}

void draw() {
  pushStyle();
    tint(255,5);
    image(backgroundImg, 0, 0, width, height);
  popStyle();

  if(g.debugMode == false){
    //background(#210e25);
    //colorMode(RGB,100);
    if(handsTouching){
      //fill(color(red(#000606),green(#000606),blue(#000606),15));
      fill(637535750);
    } else {
      //fill(color(red(#210e25),green(#210e25),blue(#210e25),35));
      fill(1495338533);
    }
    noStroke();
    rect(0,0,width,height);
  } else {
    //background(0);
    //colorMode(RGB,100);
    //fill(0,0,0,70);
    fill(-1308622848);
    noStroke();
    rect(0,0,width,height);
  }

  
  //POPULATE RANDOM DATA
  if (dataSource == RANDOM_DATA) {
    for (int i = 0; i < newData.length; i++) {
      newData[i] = random(-250, 250);
    }
    for (int i = 0; i < newData2.length; i++) {
      newData2[i] = random(0.0, 10.0);
    }
    newData3[0] = random(-250,250);
  }
  
  //POPULATE NO DATA
  if (dataSource == NO_DATA) {
    for (int i = 0; i < newData.length; i++) {
      newData[i] = 0;
    }
    for (int i = 0; i < newData2.length; i++) {
      newData2[i] = 0;
    }
    newData3[0] = 0;
  }

  if(handsTouching && frameCount % 10 == 0){
    spawnLeft(newData3, -250, 250);
    spawnRight(newData3, -250, 250);
  }

  // If data is pulled from UDP, pass it to the drawing board
  if (dataSource == STREAM_DATA && isReceivingData) {
    g.update(subj1_eeg);
    g2.update(subj2_eeg);
    s.update(subj1_fft);
    s2.update(subj2_fft);
  } else {
    g.update(newData);
    g2.update(newData);
    s.update(newData2);
    s2.update(newData2);
  }

  g.render();
  g2.render();
  s.render();
  s2.render();


  for(Point pt : leftPoints){
    pt.render();
  }
  for(Point pt : rightPoints){
    pt.render();
  }

  if(handsTouching){
    pushStyle();

      noFill();
      strokeWeight(0.5);
      stroke(color(255,0,255,10));
      //change the iteration to every 0.5 from 0.1
      for(int i = 0; i < width; i += (width*0.5)){
        beginShape(TRIANGLE_STRIP);
        for(int j = 0; j <= height; j += (height*0.1)){
          vertex(i - (height*0.05) * sin(millis()*0.001) ,j + (height*0.05) * cos(millis()*0.001));
          vertex(i + (width*0.1) + (height*0.05) * cos(millis()*0.001), j);
        }
        endShape();
      }
    popStyle();
  }

  prune();
  isReceivingData = false;
}

//void mousePressed(){
//  g.debugMode = !g.debugMode;
//  s.debugMode = !s.debugMode;
//  g2.debugMode = !g2.debugMode;
//  s2.debugMode = !s2.debugMode;
//}

//void keyPressed(){
//  if (key == ' ') {
//    handsTouching = !handsTouching;
//  }
//}


void spawnLeft(float[] heart, float lowerLim, float upperLim){
  int interval = floor(map(heart[0],lowerLim, upperLim,40,5));
  for(int i = 0; i < height; i += interval){
    //Point(float locx, float locy, float sizeX, float sizeY, float speed, bool driftsLeft){
    float sizeX = random(20,120);
    Point pt = new Point(width*0.52, i, sizeX, sizeX, random(0.01, 0.02), true);
    leftPoints.add(pt);
  }
}

void spawnRight(float[] heart, float lowerLim, float upperLim){
  int interval = floor(map(heart[0],lowerLim, upperLim,40,5));
  for(int i = 0; i < height; i += interval){
    //Point(float locx, float locy, float sizeX, float sizeY, float speed, bool driftsLeft){
    float sizeX = random(20,120);
    Point pt = new Point(width*0.48, i, sizeX, sizeX, random(0.01, 0.02), false);
    rightPoints.add(pt);
  }
}


void prune(){
  println(leftPoints.size());
  for(int i = leftPoints.size()-1; i > 0; i--){
    Point pt = leftPoints.get(i);
    if(pt.alive == false){
      leftPoints.remove(pt);
    }
  }
  println(rightPoints.size());
  for(int i = rightPoints.size()-1; i > 0; i--){
    Point pt = rightPoints.get(i);
    if(pt.alive == false){
      rightPoints.remove(pt);
    }
  }
}


// **********************************************************
// NETWORKING

void receive(byte[] received_data) {
  isReceivingData = true;
  String data = new String(received_data);
  String[] items = data.replaceAll("\\[","").replaceAll("\\]","").split(",");
  
/*
 * Mapping to the input DATA FORMAT
 * First 18 values are from the raw voltage
 */
 
  // 0-5: subj 1 eeg
  for (int i = 0; i<6;i++){
    subj1_eeg[i] = Float.parseFloat(items[i]);
  }
  // 6: subj 1 ecg
  subj1_heart[0] = Float.parseFloat(items[6]);
  
  // 8-13: subj2 eeg
  for (int i =0;i<6;i++){
    subj2_eeg[i] = Float.parseFloat(items[i+8]);
  }
  // 14: subj2 ecg
  subj2_heart[0] = Float.parseFloat(items[14]);
  
  // 16-2080: channels 0-5 and 8-13 fft data (129 points per channel)
  for (int i=0;i<32;i++){
    subj1_fft[i] = Float.parseFloat(items[i+16]);
  }
  for (int i=0;i<32;i++){
    subj2_fft[i] = Float.parseFloat(items[i+48]);
  }
}