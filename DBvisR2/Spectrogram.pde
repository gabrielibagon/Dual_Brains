class Spectrogram extends Graph {
  int dataPoints;
  float[][] data;
  int numOfReadingsStored;


  Spectrogram(int DATAPOINTS, float UPPER_LIM, float LOWER_LIM, float SAMPLE_RATE, int TIME_WINDOW, float SCALE, float ORIGIN_X, float ORIGIN_Y) {
    super(SAMPLE_RATE, TIME_WINDOW, SCALE, ORIGIN_X, ORIGIN_Y, UPPER_LIM, LOWER_LIM);
    this.dataPoints = DATAPOINTS;
    this.numOfReadingsStored = int(SAMPLE_RATE * TIME_WINDOW);
    data = new float[DATAPOINTS][numOfReadingsStored];
  }

  void update(float[] newData2) { //Read in new data
    //push new data into each channel stack

    //copy data backwards
    for (int i = 0; i < this.dataPoints; i++) { //for each point...
      for (int j = numOfReadingsStored-1; j > 0; j--) {//iterate from last value to the second (index 1)
        data[i][j] = data[i][j-1];
      }
      data[i][0] = newData2[i]; //store new value for corresponding dataPoints
    }
  }

  void render() {
    //super.render();
    pushMatrix();
    translate(origin.x, origin.y);
    noFill();
    strokeWeight(0.5);
    stroke(#FF0000);
    for (int i = 0; i < this.dataPoints; i++) {//for each channel...
      for (int j = 1; j < numOfReadingsStored; j++) {//connect every dataPoint

        //DEBUG UTIL: POINTS MODE
        ellipse((sampleRate * timeWindow * scale)/numOfReadingsStored * (j-1), 
          (-1 * sampleRate * timeWindow * scale) / (dataPoints+1) * (i+1) + map(data[i][j], upperLim, lowerLim, 5 * scale, -5 * scale), 1, 1);
      }
    }
    popMatrix();
  }
}