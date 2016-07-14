class LineGraph extends Graph {
  int channels;
  float[][] data;
  int numOfReadingsStored;


  LineGraph(int CHANNELS, float UPPER_LIM, float LOWER_LIM, float SAMPLE_RATE, int TIME_WINDOW, float SCALE, float ORIGIN_X, float ORIGIN_Y,  boolean IS_ON_LEFT) {
    super(SAMPLE_RATE, TIME_WINDOW, SCALE, ORIGIN_X, ORIGIN_Y, UPPER_LIM, LOWER_LIM, IS_ON_LEFT);
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

        strokeCap(PROJECT);
        strokeWeight(3);
        //color[] cs = {color(#A4036F), color(#048BA8), color(#16DB93), color(#EFEA5A), color(#F29E4C), color(#50D0ED)};
        //Swatch from Mockup
        color[] swatch = {color(#010552), color(#2afd61), color(#fd85fd), color(#5582a5), color(#af1ecd), color(#ffffff), color(#2cfefd), color(#fffd76)};
        //color[] swatch = {color(#8f435c), color(#db854c), color(#e8d889), color(#ec6232), color(#facb65), color(#6b9080), color(#efd937), color(#a48269)};

        beginShape();

        for(int i = this.channels-1; i >= 0; i--){//for each channel...
          for(int j = 1; j < numOfReadingsStored; j++){//connect every point

            //DEBUG UTIL: POINTS MODE
              // ellipse((sampleRate * timeWindow * scale)/numOfReadingsStored * (j-1) ,
              //     (-1 * sampleRate * timeWindow * scale) / (channels+1) * (i+1) + map(data[i][j], upperLim, lowerLim, 5 * scale, -5 * scale),1,1);

            //DEBUG UTIL: LINE MODE
              float baseWave = sin(TWO_PI * j/numOfReadingsStored) * cos(millis()*0.0001);
              colorMode(RGB, 255,255,255,100);



              //Calculate alpha
              float alpha = map(data[i][j], upperLim, lowerLim, 0, 100) * ((1.0*numOfReadingsStored-j)/numOfReadingsStored);
              if(data[i][j] == 0.0){
                alpha = 0;
              }
              //stroke(color(255,255,255,5));
              int colorCode = floor(map(data[i][j], lowerLim, upperLim, 0, 8));
              colorCode = constrain(colorCode, 0, 7);
              //Add alpha value to swatch color
              //color c = color(red(swatch[colorCode]), green(swatch[colorCode]), blue(swatch[colorCode]), alpha*0.3);
              //select color by channel
              color c = color(red(swatch[i]), green(swatch[i]), blue(swatch[i]), alpha*0.1);
              stroke(c);
              strokeWeight(55*(channels-i)/channels);
              line(-10 + scale * (j-1) ,
                  (-1 * numOfReadingsStored * scale) / (channels+1) * (i+1) + (baseWave * i * 15) + map(data[i][j-1], upperLim, lowerLim, 1 * scale, -1 * scale) ,
                  scale * j,
                  (-1 * sampleRate * timeWindow * scale) / (channels+1) * (i+1) + (baseWave * i * 15) + map(data[i][j], upperLim, lowerLim, 1 * scale, -1 * scale) );

              strokeWeight(9);
              stroke(color(255,255,255,alpha*0.1));
              //c = color(red(swatch[colorCode]), green(swatch[colorCode]), blue(swatch[colorCode]), alpha*0.3);
              //stroke(c);
              line(scale * (j-1) ,
                  (-1 * numOfReadingsStored * scale) / (channels+1) * (i+1) + (baseWave * i * 10) + map(data[i][j-1], upperLim, lowerLim, 7 * scale, -7 * scale) ,
                  scale * j,
                  (-1 * sampleRate * timeWindow * scale) / (channels+1) * (i+1) + (baseWave * i * 10) + map(data[i][j], upperLim, lowerLim, 7 * scale, -7 * scale) );

              strokeWeight(4);
              //stroke(color(255,255,255,40));
              c = color(red(swatch[colorCode]), green(swatch[colorCode]), blue(swatch[colorCode]), alpha*0.3);
              stroke(c);
              line((sampleRate * timeWindow * scale)/numOfReadingsStored * (j-1) ,
                  (-1 * sampleRate * timeWindow * scale) / (channels+1) * (i+1) + (baseWave * i * 10) + map(data[i][j-1], upperLim, lowerLim, 1 * scale, -1 * scale) ,
                  (sampleRate * timeWindow * scale)/numOfReadingsStored * j,
                  (-1 * sampleRate * timeWindow * scale) / (channels+1) * (i+1) + (baseWave * i * 10) + map(data[i][j], upperLim, lowerLim, 1 * scale, -1 * scale) );


              //noStroke();
              //fill(color(255,255,255,10));
              // ellipse((sampleRate * timeWindow * scale)/numOfReadingsStored * (j-1) ,
              //     (-1 * sampleRate * timeWindow * scale) / (channels+1) * (i+1) + (baseWave * i * 10) + map(data[i][j-1], upperLim, lowerLim, 1 * scale, -1 * scale), 30, 30);

              strokeWeight(1);
              //stroke(cs[i]);
              stroke(color(255,255,255,alpha));
              line((sampleRate * timeWindow * scale)/numOfReadingsStored * (j-1) ,
                  (-1 * sampleRate * timeWindow * scale) / (channels+1) * (i+1) + (baseWave * i * 10) + map(data[i][j-1], upperLim, lowerLim, 6 * scale, -6 * scale) ,
                  (sampleRate * timeWindow * scale)/numOfReadingsStored * j,
                  (-1 * sampleRate * timeWindow * scale) / (channels+1) * (i+1) + (baseWave * i * 10) + map(data[i][j], upperLim, lowerLim, 6 * scale, -6 * scale) );
            }
        }
      popMatrix();
    }
  }


}
