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

  void render(){

    if(debugMode){
      super.render();
      //-----------------------
      //DEBUG MODE RENDER:
      //-----------------------
      pushMatrix();
        translate(origin.x, origin.y);
        noFill();
        strokeWeight(0.5);
        stroke(#FF0000);
        for(int i = 0; i < this.channels; i++){//for each channel...
          for(int j = 1; j < numOfReadingsStored; j++){//connect every point

            //DEBUG UTIL: POINTS MODE
              // ellipse((sampleRate * timeWindow * scale)/numOfReadingsStored * (j-1) ,
              //     (-1 * sampleRate * timeWindow * scale) / (channels+1) * (i+1) + map(data[i][j], upperLim, lowerLim, 5 * scale, -5 * scale),1,1);

            //DEBUG UTIL: LINE MODE
              line((sampleRate * timeWindow * scale)/numOfReadingsStored * (j-1) ,
                  (-1 * sampleRate * timeWindow * scale) / (channels+1) * (i+1) + map(data[i][j-1], upperLim, lowerLim, 5 * scale, -5 * scale) ,
                  (sampleRate * timeWindow * scale)/numOfReadingsStored * j,
                  (-1 * sampleRate * timeWindow * scale) / (channels+1) * (i+1) + map(data[i][j], upperLim, lowerLim, 5 * scale, -5 * scale) );
            }
        }
      popMatrix();
    } else {
      //-----------------------
      //VISUALIZE MODE RENDER
      //-----------------------
      //blendMode(DIFFERENCE);
      pushMatrix();
        translate(origin.x, origin.y);
        noFill();
        strokeWeight(3);
        color[] cs = {color(#A4036F), color(#048BA8), color(#16DB93), color(#EFEA5A), color(#F29E4C), color(#50D0ED)};
        for(int i = this.channels-1; i >= 0; i--){//for each channel...
          for(int j = 1; j < numOfReadingsStored; j++){//connect every point

            //DEBUG UTIL: POINTS MODE
              // ellipse((sampleRate * timeWindow * scale)/numOfReadingsStored * (j-1) ,
              //     (-1 * sampleRate * timeWindow * scale) / (channels+1) * (i+1) + map(data[i][j], upperLim, lowerLim, 5 * scale, -5 * scale),1,1);

            //DEBUG UTIL: LINE MODE
              float baseWave = sin(TWO_PI * j/numOfReadingsStored) * cos(millis()*0.0001);
              colorMode(RGB, 255,255,255,100);

              strokeWeight(20);
              stroke(color(255,255,255,5));
              line(scale * (j-1) ,
                  (-1 * numOfReadingsStored * scale) / (channels+1) * (i+1) + (baseWave * i * 10) + map(data[i][j-1], upperLim, lowerLim, 1 * scale, -1 * scale) ,
                  scale * j,
                  (-1 * sampleRate * timeWindow * scale) / (channels+1) * (i+1) + (baseWave * i * 10) + map(data[i][j], upperLim, lowerLim, 1 * scale, -1 * scale) );

              strokeWeight(12);
              stroke(color(255,255,255,10));
              line(scale * (j-1) ,
                  (-1 * numOfReadingsStored * scale) / (channels+1) * (i+1) + (baseWave * i * 10) + map(data[i][j-1], upperLim, lowerLim, 1 * scale, -1 * scale) ,
                  scale * j,
                  (-1 * sampleRate * timeWindow * scale) / (channels+1) * (i+1) + (baseWave * i * 10) + map(data[i][j], upperLim, lowerLim, 1 * scale, -1 * scale) );

              strokeWeight(3);
              stroke(color(255,255,255,40));
              line((sampleRate * timeWindow * scale)/numOfReadingsStored * (j-1) ,
                  (-1 * sampleRate * timeWindow * scale) / (channels+1) * (i+1) + (baseWave * i * 10) + map(data[i][j-1], upperLim, lowerLim, 1 * scale, -1 * scale) ,
                  (sampleRate * timeWindow * scale)/numOfReadingsStored * j,
                  (-1 * sampleRate * timeWindow * scale) / (channels+1) * (i+1) + (baseWave * i * 10) + map(data[i][j], upperLim, lowerLim, 1 * scale, -1 * scale) );


              //noStroke();
              //fill(color(255,255,255,10));
              // ellipse((sampleRate * timeWindow * scale)/numOfReadingsStored * (j-1) ,
              //     (-1 * sampleRate * timeWindow * scale) / (channels+1) * (i+1) + (baseWave * i * 10) + map(data[i][j-1], upperLim, lowerLim, 1 * scale, -1 * scale), 30, 30);

              strokeWeight(1);
              stroke(cs[i]);
              stroke(#FFFFFF);
              line((sampleRate * timeWindow * scale)/numOfReadingsStored * (j-1) ,
                  (-1 * sampleRate * timeWindow * scale) / (channels+1) * (i+1) + (baseWave * i * 10) + map(data[i][j-1], upperLim, lowerLim, 1 * scale, -1 * scale) ,
                  (sampleRate * timeWindow * scale)/numOfReadingsStored * j,
                  (-1 * sampleRate * timeWindow * scale) / (channels+1) * (i+1) + (baseWave * i * 10) + map(data[i][j], upperLim, lowerLim, 1 * scale, -1 * scale) );
            }
        }
      popMatrix();
    }
  }


}
