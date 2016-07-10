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
  size(1200, 1050);
  mask = loadImage("gradientmask.png");

  //Test Graph
  //Graph(float SAMPLE_RATE, int TIME_WINDOW, float SCALE, int ORIGIN_X, int ORIGIN_Y){

  //LineGraph(int CHANNELS, float UPPER_LIM, float LOWER_LIM, float SAMPLE_RATE, int TIME_WINDOW, float SCALE, float ORIGIN_X, float ORIGIN_Y){
  g = new LineGraph(6, 250, -250, 20, 10, 3, width*0.05, height*0.95);
  g2 = new LineGraph(6, 250, -250, 20, 10, 3, width*0.55, height*0.95);


  //Spectrogram graph
  // Spectrogram(int DATAPOINTS, float UPPER_LIM, float LOWER_LIM, float SAMPLE_RATE, int TIME_WINDOW, float SCALE, float ORIGIN_X, float ORIGIN_Y) {
  s = new Spectrogram(50, 0, 10, 10, 5, 3, width*0.05, 20);
  s2 = new Spectrogram(50, 0, 10, 10, 5, 3, width*0.55, 20);

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
  image(mask, 0, 0, width, height);

  fill(color(#FFFFFF));
  text(frameRate, 20, 20);
}

void mousePressed(){
  g.debugMode = !g.debugMode;
  s.debugMode = !s.debugMode;
  g2.debugMode = !g2.debugMode;
  s2.debugMode = !s2.debugMode;
}
