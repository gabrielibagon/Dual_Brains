/*-----------
 Dual Brains Data Viz - R2
 This sketch should
 1. initialized necessary Graph objects & a UDP object
 2. Parse data read via UDP object and pipe the correct data into the Graph objects
 ------------- */
LineGraph g, g2;
Spectrogram s, s2;
float[][] data_list;
PImage mask;
PImage backgroundImg;

void setup() {
  //size(1080, 768);
  frameRate(24);
  size(640, 480, P3D);
  background(0);
  mask = loadImage("gradientmask.png");
  backgroundImg = loadImage("mockup_640.jpg");


  //Test Graph
  //Graph(float SAMPLE_RATE, int TIME_WINDOW, float SCALE, int ORIGIN_X, int ORIGIN_Y){

  //LineGraph(int CHANNELS, float UPPER_LIM, float LOWER_LIM, float SAMPLE_RATE, int TIME_WINDOW, float SCALE, float ORIGIN_X, float ORIGIN_Y,  boolean IS_ON_LEFT){
  g = new LineGraph(6, 250, -250, 20, 9, 2, width*0, height*1.1, true);
  g2 = new LineGraph(6, 250, -250, 20, 9, 2, width*0.5, height*1.1, false);


  //Spectrogram graph
  // Spectrogram(int DATAPOINTS, float UPPER_LIM, float LOWER_LIM, float SAMPLE_RATE, int TIME_WINDOW, float SCALE, float ORIGIN_X, float ORIGIN_Y) {
  s = new Spectrogram(32, 10, 0, 9, 4, 2.2, width*0, -20, true);
  s2 = new Spectrogram(32, 10, 0, 9, 4, 2.2, width*0.5, -20, false);

  //Set DeBug to False for Gabe FrameRate Test
  g.debugMode = false;
  s.debugMode = false;
  g2.debugMode = false;
  s2.debugMode = false;

}

void draw() {
  image(backgroundImg, 0, 0, width, height);

  if(g.debugMode == false){
    //background(#210e25);
    colorMode(RGB,100);
    fill(red(#210e25),green(#210e25),blue(#210e25),80);
    noStroke();
    rect(0,0,width,height);
  } else {
    //background(0);
    colorMode(RGB,100);
    fill(0,0,0,70);
    noStroke();
    rect(0,0,width,height);
  }


  float [] newData2 = new float[s.dataPoints];

  for (int i = 0; i < s.dataPoints; i++) {
    //newData2[i] = random(0, 11);
    newData2[i] = random(0.0, 10.0);
  }

  float[] newData = {random(-250, 250), random(-250, 250), random(-250, 250), random(-250, 250), random(-250, 250), random(-250, 250)};

  g.update(newData);
  g2.update(newData);

  g.render();
  g2.render();

  s.update(newData2);
  s2.update(newData2);

  s.render();
  s2.render();
  tint(255,255);
  //image(mask, 0, 0, width, height);

  fill(color(#FFFFFF));
  text(frameRate, 20, 20);
}

void mousePressed(){
  g.debugMode = !g.debugMode;
  s.debugMode = !s.debugMode;
  g2.debugMode = !g2.debugMode;
  s2.debugMode = !s2.debugMode;
}
