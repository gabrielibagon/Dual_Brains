/*--------------------
 DUAL Brains
 ----------------------
 Graph class
 SUBCLASSES:
 -- LineGraph
 -- Spectrogram
 --------------------*/

class Graph {
  boolean show; //hide or show
  boolean debugMode;
  boolean screenLeft;//is it from the person to the left
  float sampleRate; //number of new data samples sent per second
  int timeWindow; //number of seconds of history to display
  float scale; //scale of graph in pixels per second
  PVector origin;
  float upperLim;
  float lowerLim;
  Graph(float SAMPLE_RATE, int TIME_WINDOW, float SCALE, float ORIGIN_X, float ORIGIN_Y, float UPPER_LIM, float LOWER_LIM, boolean IS_ON_LEFT) {
    this.show = true;
    this.debugMode = true;
    this.screenLeft = IS_ON_LEFT;
    this.sampleRate = SAMPLE_RATE;
    this.timeWindow = TIME_WINDOW;
    this.scale = SCALE;
    this.origin = new PVector(ORIGIN_X, ORIGIN_Y);
    this.upperLim = UPPER_LIM;
    this.lowerLim = LOWER_LIM;
  }

  void render() {
    pushMatrix();
    noFill();
    strokeWeight(1);
    stroke(255);
    translate(origin.x, origin.y);
    //draw the axis
    line(0, 0, 0, -1 * sampleRate * timeWindow * scale);
    line(0, 0, sampleRate * timeWindow * scale, 0);
    popMatrix();
  }
}
