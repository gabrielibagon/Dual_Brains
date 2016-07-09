class LineGraph extends Graph {
  int channels;
  float[][] data;
  int numOfReadingsStored;


  LineGraph(int CHANNELS, float UPPER_LIM, float LOWER_LIM, float SAMPLE_RATE, int TIME_WINDOW, float SCALE, float ORIGIN_X, float ORIGIN_Y) {
    super(SAMPLE_RATE, TIME_WINDOW, SCALE, ORIGIN_X, ORIGIN_Y, UPPER_LIM, LOWER_LIM);
    this.channels = CHANNELS;
    this.numOfReadingsStored = int(SAMPLE_RATE * TIME_WINDOW);
    data = new float[CHANNELS][numOfReadingsStored];
  }

  void update(float[] newData) { //Read in new data
    //push new data into each channel stack

    //copy data backwards
    for (int i = 0; i < this.channels; i++) { //for each channel...
      for (int j = numOfReadingsStored-1; j > 0; j--) {//iterate from last value to the second (index 1)
        data[i][j] = data[i][j-1];
      }
      data[i][0] = newData[i]; //store new value for corresponding channel
    }
  }

  void render() {
    //super.render();
    pushMatrix();
    translate(origin.x, origin.y);
    noFill();
    strokeWeight(0.5);
    stroke(#FF0000);
    for (int i = 0; i < this.channels; i++) {//for each channel...
      for (int j = 1; j < numOfReadingsStored; j++) {//connect every point

        //DEBUG UTIL: LINE MODE
        line((sampleRate * timeWindow * scale)/numOfReadingsStored * (j-1), 
          (-1 * sampleRate * timeWindow * scale) / (channels+1) * (i+1) + map(data[i][j-1], upperLim, lowerLim, 5 * scale, -5 * scale), 
          (sampleRate * timeWindow * scale)/numOfReadingsStored * j, 
          (-1 * sampleRate * timeWindow * scale) / (channels+1) * (i+1) + map(data[i][j], upperLim, lowerLim, 5 * scale, -5 * scale) );
      }
    }
    popMatrix();
  }
}