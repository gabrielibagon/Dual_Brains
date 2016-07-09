/*-----------
 Dual Brains Data Viz - R2
 This sketch should
 1. initialized necessary Graph objects & a UDP object
 2. Parse data read via UDP object and pipe the correct data into the Graph objects
 ------------- */
LineGraph g;
Spectrogram s;
float[][] data_list;
void setup() {
  size(1200, 750);

  //Test Graph
  //Graph(float SAMPLE_RATE, int TIME_WINDOW, float SCALE, int ORIGIN_X, int ORIGIN_Y){
  //LineGraph(int CHANNELS, float UPPER_LIM, float LOWER_LIM, float SAMPLE_RATE, int TIME_WINDOW, float SCALE, float ORIGIN_X, float ORIGIN_Y){
  g = new LineGraph(6, 250, -250, 20, 5, 3, width*0.15, height*0.75);


  //Spectrogram graph
  // Spectrogram(int DATAPOINTS, float UPPER_LIM, float LOWER_LIM, float SAMPLE_RATE, int TIME_WINDOW, float SCALE, float ORIGIN_X, float ORIGIN_Y) {
  s = new Spectrogram(512, 0, 10, 20, 1, 10, width*0.75, height*0.75);

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

  s.update(newData2);
  s.render();
  text(frameRate, 20, 20);
}

void mousePressed(){
  g.debugMode = !g.debugMode;
}

void mousePressed() {
}
