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
void setup() {
  size(1080, 768);
  mask = loadImage("gradientmask.png");

  //Test Graph
  //Graph(float SAMPLE_RATE, int TIME_WINDOW, float SCALE, int ORIGIN_X, int ORIGIN_Y){

  //LineGraph(int CHANNELS, float UPPER_LIM, float LOWER_LIM, float SAMPLE_RATE, int TIME_WINDOW, float SCALE, float ORIGIN_X, float ORIGIN_Y,  boolean IS_ON_LEFT){
  g = new LineGraph(6, 250, -250, 20, 9, 3, width*0, height*1, true);
  g2 = new LineGraph(6, 250, -250, 20, 9, 3, width*0.5, height*1, false);


  //Spectrogram graph
  // Spectrogram(int DATAPOINTS, float UPPER_LIM, float LOWER_LIM, float SAMPLE_RATE, int TIME_WINDOW, float SCALE, float ORIGIN_X, float ORIGIN_Y) {
  s = new Spectrogram(34, 0, 10, 9, 5, 4, width*0, 20, true);
  s2 = new Spectrogram(34, 0, 10, 9, 5, 4, width*0.5, 20, false);

  //Set DeBug to False for Gabe FrameRate Test
  g.debugMode = false;
  s.debugMode = false;
  g2.debugMode = false;
  s2.debugMode = false;

}

void draw() {

  background(0);

  float [] newData2 = new float [512];

  for (int i =0; i<512; i++) {
    newData2[i] = random(0, 10);
  }

  float[] newData = {random(-250, 250), random(-250, 250), random(-250, 250), random(-250, 250), random(-250, 250), random(-250, 250)};
  g.update(newData);
  g.render();
  g2.update(newData);
  g2.render();

  s.update(newData2);
  s.render();
  s2.update(newData2);
  s2.render();
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
