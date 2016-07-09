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
  PVector origin;
  int timeWindow; //number of seconds of history to display
  float sampleRate; //number of new data samples sent per second
  float scale; //scale of graph in pixels per second

  Graph(float SAMPLE_RATE, int TIME_WINDOW, float SCALE, float ORIGIN_X, float ORIGIN_Y){
    this.show = true;
    this.debugMode = true;
    this.timeWindow = TIME_WINDOW;
    this.sampleRate = SAMPLE_RATE;
    this.scale = SCALE;
    this.origin = new PVector(ORIGIN_X, ORIGIN_Y);
  }

  void render(){
    pushMatrix();
      noFill();
      strokeWeight(1);
      stroke(255);
      translate(origin.x, origin.y);
      line(0,0,0,-1 * sampleRate * timeWindow * scale);
      line(0,0,sampleRate * timeWindow * scale,0);
    popMatrix();
  }

}
