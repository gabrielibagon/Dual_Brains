class Spectrogram extends Graph {
  int dataPoints;
  float[][] data;
  int numOfReadingsStored;


  Spectrogram(int DATAPOINTS, float UPPER_LIM, float LOWER_LIM, float SAMPLE_RATE, int TIME_WINDOW, float SCALE, float ORIGIN_X, float ORIGIN_Y, boolean IS_ON_LEFT) {
    super(SAMPLE_RATE, TIME_WINDOW, SCALE, ORIGIN_X, ORIGIN_Y, UPPER_LIM, LOWER_LIM, IS_ON_LEFT);
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
    if(debugMode){
      //-----------------------
      //DEBUG MODE RENDER:
      //-----------------------
      //super.render();
      pushMatrix();
      translate(origin.x, origin.y);
      colorMode(RGB, 255,255,255,100);
      noStroke();
      for (int i = 0; i < this.dataPoints; i++) {//for each channel...
        for (int j = 0; j < numOfReadingsStored; j++) {//connect every dataPoint
          //DEBUG UTIL: POINTS MODE

          float alpha = map(data[i][j], upperLim, lowerLim, 0, 100);
          fill(color(255,255,255, alpha));
          ellipse( 4 * scale * j, scale * i , 1, 1);
        }
      }
      popMatrix();
    } else {
      //-----------------------
      //VISUALIZE MODE RENDER:
      //-----------------------
      pushMatrix();
      translate(origin.x, origin.y);
      colorMode(RGB, 255,255,255,100);
      noStroke();
      color[] swatch = {color(#010552), color(#2afd61), color(#fd85fd), color(#5582a5), color(#af1ecd), color(#ffffff), color(#2cfefd), color(#fffd76)};
      for (int i = 0; i < this.dataPoints; i++) {//for each channel...
        for (int j = 1; j < numOfReadingsStored; j++) {//connect every dataPoint
          //DEBUG UTIL: POINTS MODE
          float baseWave = sin(TWO_PI * j/numOfReadingsStored) * cos(millis()*0.0001);
          float alpha = map(data[i][j], upperLim, lowerLim, 20, 100) * (1.0 * (numOfReadingsStored -j)/ numOfReadingsStored);
          strokeWeight(0.5);
          //stroke(color(255,255,255, alpha));
          int colorCode = floor(map(data[i][j], upperLim, lowerLim, 0, 8));
          colorCode = constrain(colorCode, 0, 7);
          stroke(swatch[colorCode]);
          line( (10 * baseWave) + 4 * scale * i, 4 * scale * (j-1), 4 * scale * i, 4 * scale * j);
          line( (10 * baseWave) + 4 * scale * (i+1), 4 * scale * j, 4 * scale * i, 4 * scale * j);
          alpha = map(data[i][j], upperLim, lowerLim, 20, 100) * ((1.0*numOfReadingsStored-j)/numOfReadingsStored);
          fill(color(255,255,255, alpha));
          ellipse( (10 * baseWave) + 4 * scale * i, 4 * scale * j, 1, 1);

          // stroke(color(255,255,255,20));
          // ellipse( 4 * scale * i, 4 * scale * j, 2 * scale, 2 * scale);
          // stroke(color(255,255,255,8));
          // ellipse( 4 * scale * i, 4 * scale * j, 4 * scale, 4 * scale);
        }
      }
      popMatrix();
    }
  }
}
