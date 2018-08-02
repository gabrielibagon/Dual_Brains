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

//Preview
//PWindow win;

// Controls
Controls controls;

// Visualization
boolean handsTouching;
boolean DEBUG = false;

float LEFT_BORDER;
float RIGHT_BORDER;
float UPPER_BORDER;

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

int dataLength;

float[] newDataLeft;
float[] newData2Left;
float[] newData3Left;
float[] newDataRight;
float[] newData2Right;
float[] newData3Right;

float fountain_interval;
float fountain_min_interval;
float fountain_increment;

float curTime, lastTime, randInterval;
float randLimit = 150;
float rand2Limit = 10.5;

int curOutputScreen = 1;

float adjLeftGlobalVals = 1.0;
float adjRightGlobalVals = 1.0;

void settings() {
  // If you have a second screen
  //fullScreen(P3D, 2);
  // If you have only one screen
  fullScreen(P3D);
  smooth();
}

void setup() {
  
  frameRate(20);
  background(0);
  backgroundImg = loadImage("GradientBackground-640.jpg");

  LEFT_BORDER = -.1*width;
  RIGHT_BORDER = 1.1*width;
  UPPER_BORDER = -.01*height;

  println(LEFT_BORDER, RIGHT_BORDER, UPPER_BORDER);


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
  udp= new UDP(this, PORT_RX, HOST_IP);
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
  
  dataLength = 8;
  
  newDataLeft = new float[dataLength];
  newData2Left = new float[s.dataPoints];
  newData3Left = new float[1];
  
  newDataRight = new float[dataLength];
  newData2Right = new float[s2.dataPoints];
  newData3Right = new float[1];

  fountain_interval = 40.0;
  fountain_min_interval = 15.0;
  fountain_increment = 0.15;
  
  
  for (int i = 0; i < newDataLeft.length; i++) {
      newDataLeft[i] = 0;
      newDataRight[i] = 0;
    }
    for (int i = 0; i < newData2Left.length; i++) {
      newData2Left[i] = 0;
      newData2Right[i] = 0;
    }
    newData3Left[0] = 0;
    newData3Right[0] = 0;
}

void draw() {
  pushStyle();
  tint(255, 5);
  image(backgroundImg, 0, 0, width, height);
  popStyle();

  if (g.debugMode == false) {
    //background(#210e25);
    //colorMode(RGB,100);
    if (handsTouching) {
      //fill(color(red(#000606),green(#000606),blue(#000606),15));
      fill(637535750);
    } else {
      //fill(color(red(#210e25),green(#210e25),blue(#210e25),35));
      fill(1495338533);
    }
    noStroke();
    rect(0, 0, width, height);
  } else {
    //background(0);
    //colorMode(RGB,100);
    //fill(0,0,0,70);
    fill(-1308622848);
    noStroke();
    rect(0, 0, width, height);
  }


  //POPULATE RANDOM DATA
  if (dataSource == RANDOM_DATA) {
    float prevVal;
    float tmpVal;
    float newVal;
    for (int i = 0; i < newDataLeft.length; i++) {
      prevVal = newDataLeft[i];
      tmpVal = random(prevVal - randLimit, prevVal + randLimit);
      newVal = constrain (tmpVal, -250, 250);
      newDataLeft[i] = newVal;
    }
    for (int i = 0; i < newData2Left.length; i++) {
      prevVal = newData2Left[i];
      tmpVal = random(prevVal - rand2Limit, prevVal + randLimit);
      newVal = constrain (tmpVal, 0.0, 12.0);
      newData2Left[i] = newVal;
      //newData2Left[i] = random(0.0, 12.0);
    }
    newData3Left[0] = random(-250, 250);
    
    for (int i = 0; i < newDataRight.length; i++) {
      prevVal = newDataRight[i];
      tmpVal = random(prevVal - randLimit, prevVal + randLimit);
      newVal = constrain (tmpVal, -250, 250);
      newDataRight[i] = newVal;
    }
    for (int i = 0; i < newData2Right.length; i++) {
      prevVal = newData2Right[i];
      tmpVal = random(prevVal - rand2Limit, prevVal + randLimit);
      newVal = constrain (tmpVal, 0.0, 12.0);
      newData2Right[i] = newVal;
      //newData2Left[i] = random(0.0, 12.0);
    }
    newData3Right[0] = random(-250, 250);
  }
    
  //OLD RANDOM DATA POPULATOR
  //  for (int i = 0; i < newDataLeft.length; i++) {
  //    newDataLeft[i] = random(-250, 250);
  //  }
  //  for (int i = 0; i < newData2Left.length; i++) {
  //    newData2RLeft[i] = random(0.0, 12.0);
  //  }
  //  newData3Left[0] = random(-250, 250);
  //}
  //  for (int i = 0; i < newDataRight.length; i++) {
  //    newDataRight[i] = random(-250, 250);
  //  }
  //  for (int i = 0; i < newData2Right.length; i++) {
  //    newData2Right[i] = random(0.0, 12.0);
  //  }
  //  newData3Right[0] = random(-250, 250);
  //}

  //POPULATE NO DATA
  if (dataSource == NO_DATA) {
    for (int i = 0; i < newDataLeft.length; i++) {
      newDataLeft[i] = 0;
      newDataRight[i] = 0;
    }
    for (int i = 0; i < newData2Left.length; i++) {
      newData2Left[i] = 0;
      newData2Right[i] = 0;
    }
    newData3Left[0] = 0;
    newData3Right[0] = 0;
  }

//----TODO-----
// newData3Left and newData3Right need to use heart or EMG rather than random or null
// use heartrate? 7th channel? Then this gets passed to the spawnL and R routines to
// more accurately show the effect of handholding

  if (handsTouching && frameCount % floor(fountain_interval) == 0) {
    spawnLeft(newData3Left, -250, 250);
    spawnRight(newData3Right, -250, 250);
  }

  // If data is pulled from UDP, pass it to the drawing board
  if (dataSource == STREAM_DATA && isReceivingData) {
    g.update(subj1_eeg);
    g2.update(subj2_eeg);
    s.update(subj1_fft);
    s2.update(subj2_fft);
  } else {
    g.update(newDataLeft);
    g2.update(newDataRight);
    s.update(newData2Left);
    s2.update(newData2Right);
  }

  if (handsTouching) {
    pushStyle();
    noFill();
    strokeWeight(0.5);
    stroke(color(255, 0, 255, 10));
    for (int i = 0; i < width; i += (width*0.1)) {
      beginShape(TRIANGLE_STRIP);
      for (int j = 0; j <= height; j += (height*0.1)) {
        vertex(i - (height*0.05) * sin(millis()*0.001), j + (height*0.05) * cos(millis()*0.001));
        vertex(i + (width*0.1) + (height*0.05) * cos(millis()*0.001), j);
      }
      endShape();
    }
    popStyle();

    if (fountain_interval > fountain_min_interval) {
      fountain_interval -= fountain_increment;
    }
  } else {
    fountain_interval = 50.0;
  }

  g.render();
  g2.render();
  s.render();
  s2.render();

  for (Point pt : leftPoints) {
    pt.render();
  }
  for (Point pt : rightPoints) {
    pt.render();
  }

  prune();
  isReceivingData = false;
}

void mousePressed(){
  //curOutputScreen = (curOutputScreen == 1? 2: 1);
  //fullScreen(curOutputScreen);
    //fullScreen(P3D, 2);

//  g.debugMode = !g.debugMode;
//  s.debugMode = !s.debugMode;
//  g2.debugMode = !g2.debugMode;
//  s2.debugMode = !s2.debugMode;
}


void spawnLeft(float[] heart, float lowerLim, float upperLim) {
  int interval = floor(map(heart[0], lowerLim, upperLim, 40, 5));
  for (int i = 0; i < height; i += interval) {
    //Point(float locx, float locy, float sizeX, float sizeY, float speed, bool driftsLeft){
    float sizeX = random(20, 120);
    Point pt = new Point(width/2, i, sizeX, sizeX, random(0.01, 0.02), true);
    leftPoints.add(pt);
  }
}

void spawnRight(float[] heart, float lowerLim, float upperLim) {
  int interval = floor(map(heart[0], lowerLim, upperLim, 40, 5));
  for (int i = 0; i < height; i += interval) {
    //Point(float locx, float locy, float sizeX, float sizeY, float speed, bool driftsLeft){
    float sizeX = random(20, 120);
    Point pt = new Point(width/2, i, sizeX, sizeX, random(0.01, 0.02), false);
    rightPoints.add(pt);
  }
}


void prune() {
  //println("Left Points before prune:" + leftPoints.size());
  for (int i = leftPoints.size()-1; i > 0; i--) {
    Point pt = leftPoints.get(i);
    if (pt.alive == false) {
      leftPoints.remove(pt);
    }
  }
  //println("Left Points after prune:" + leftPoints.size());

  for (int i = rightPoints.size()-1; i > 0; i--) {
    Point pt = rightPoints.get(i);
    if (pt.alive == false) {
      rightPoints.remove(pt);
    }
  }
}


// **********************************************************
// NETWORKING

void receive(byte[] received_data) {
  isReceivingData = true;
  String data = new String(received_data);
  String[] items = data.replaceAll("\\[", "").replaceAll("\\]", "").split(",");

  /*
 * Mapping to the input DATA FORMAT
   * First 18 values are from the raw voltage
   */

  // 0-5: subj 1 eeg
  for (int i = 0; i<6; i++) {
    subj1_eeg[i] = Float.parseFloat(items[i]) * adjLeftGlobalVals;
  }
  // 6: subj 1 ecg
  subj1_heart[0] = Float.parseFloat(items[6]);

  // 8-13: subj2 eeg
  for (int i =0; i<6; i++) {
    subj2_eeg[i] = Float.parseFloat(items[i+8]) * adjRightGlobalVals;
  }
  // 14: subj2 ecg
  subj2_heart[0] = Float.parseFloat(items[14]);

  // 16-2080: channels 0-5 and 8-13 fft data (129 points per channel)
  for (int i=0; i<32; i++) {
    subj1_fft[i] = Float.parseFloat(items[i+16]);
  }
  for (int i=0; i<32; i++) {
    subj2_fft[i] = Float.parseFloat(items[i+48]);
  }
}
