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
      if(screenLeft){ //IF ON SCREEN RIGHT
        pushMatrix();
        translate(origin.x, origin.y);
        colorMode(RGB, 255,255,255,100);
        noStroke();
        //Swatch from Mockup
        color[] swatch = {color(#010552), color(#2afd61), color(#fd85fd), color(#5582a5), color(#af1ecd), color(#ffffff), color(#2cfefd), color(#fffd76)};
        //Swatch from
        //color[] swatch = {color(#8f435c), color(#db854c), color(#e8d889), color(#ec6232), color(#facb65), color(#6b9080), color(#efd937), color(#a48269)};

        //TEST QUAD
        beginShape(QUAD_STRIP);
        float widthScale = width * 0.58 / dataPoints;
        for (int j = 0; j < numOfReadingsStored; j++) {//for each channel...
          for (int i = 0; i < this.dataPoints; i++) {//connect every dataPoint
            float baseWave = sin(TWO_PI * j/numOfReadingsStored) * cos(millis()*0.0001);
            float alpha = map(data[i][j], upperLim, lowerLim, 20, 100) * (1.0 * (dataPoints - i)/ dataPoints);
            if(data[i][j] == 0.0){
              alpha = 0;
            }
            //stroke(color(255,255,255, alpha));
            int colorCode = floor(map(data[i][j], lowerLim, upperLim, 0, 8));
            colorCode = constrain(colorCode, 0, 7);

            //Add alpha value to swatch color
            color c = color(red(swatch[colorCode]) * (numOfReadingsStored-j)/numOfReadingsStored,
                            green(swatch[colorCode]) * (numOfReadingsStored-j)/numOfReadingsStored,
                            blue(swatch[colorCode]) * (numOfReadingsStored-j)/numOfReadingsStored,
                            alpha*0.5);
            //fill(c);
            noStroke();
            fill(c);
            float displacement = scale * 5 * cos(PI * (numOfReadingsStored-j)/numOfReadingsStored);
            vertex( displacement + widthScale * i + 3 * cos(millis()*0.0001), scale * j + 3 * cos(millis()*0.001));
            vertex( displacement + widthScale * i + 3 * cos(millis()*0.0001), scale * j + 3 * cos(millis()*0.001) + sq((scale * (numOfReadingsStored-j)/numOfReadingsStored))*0.5);
          }
        }
        endShape(CLOSE);
      } else { //IF ON SCREEN RIGHT
        pushMatrix();
        translate(origin.x, origin.y);
        colorMode(RGB, 255,255,255,100);
        noStroke();
        //Swatch from Mockup
        color[] swatch = {color(#010552), color(#2afd61), color(#fd85fd), color(#5582a5), color(#af1ecd), color(#ffffff), color(#2cfefd), color(#fffd76)};
        //Swatch from
        //color[] swatch = {color(#8f435c), color(#db854c), color(#e8d889), color(#ec6232), color(#facb65), color(#6b9080), color(#efd937), color(#a48269)};

        //TEST QUAD
        beginShape(QUAD_STRIP);
        float widthScale = width * 0.58 / dataPoints;
        for (int j = 0; j < numOfReadingsStored; j++) {//for each channel...
          for (int i = 0; i < this.dataPoints; i++) {//connect every dataPoint
            float baseWave = sin(TWO_PI * j/numOfReadingsStored) * cos(millis()*0.0001);
            float alpha = map(data[i][j], upperLim, lowerLim, 20, 100) * (1.0 * (dataPoints - i)/ dataPoints);
            if(data[i][j] == 0.0){
              alpha = 0;
            }
            //stroke(color(255,255,255, alpha));
            int colorCode = floor(map(data[i][j], lowerLim, upperLim, 0, 8));
            colorCode = constrain(colorCode, 0, 7);

            //Add alpha value to swatch color
            color c = color(red(swatch[colorCode]) * (numOfReadingsStored-j)/numOfReadingsStored,
                            green(swatch[colorCode]) * (numOfReadingsStored-j)/numOfReadingsStored,
                            blue(swatch[colorCode]) * (numOfReadingsStored-j)/numOfReadingsStored,
                            alpha*0.5);
            //fill(c);
            noStroke();
            fill(c);

            float displacement = scale * -5 * cos(PI * (numOfReadingsStored-j)/numOfReadingsStored);
            vertex( displacement + widthScale * (dataPoints-i-1) + 3 * cos(millis()*0.0001), scale * j + 3 * cos(millis()*0.001));
            vertex( displacement + widthScale * (dataPoints-i-1) + 3 * cos(millis()*0.0001), scale * j + 3 * cos(millis()*0.001) + sq((scale * (numOfReadingsStored-j)/numOfReadingsStored))*0.5);
          }
        }
        endShape(CLOSE);
      }


      // for (int i = 0; i < this.dataPoints; i++) {//for each channel...
      //   for (int j = 1; j < numOfReadingsStored; j++) {//connect every dataPoint
      //     //DEBUG UTIL: POINTS MODE
      //     float baseWave = sin(TWO_PI * j/numOfReadingsStored) * cos(millis()*0.0001);
      //     float alpha = map(data[i][j], upperLim, lowerLim, 20, 100) * (1.0 * (numOfReadingsStored -j)/ numOfReadingsStored);
      //     if(data[i][j] == 0.0){
      //       alpha = 0;
      //     }
      //
      //     //stroke(color(255,255,255, alpha));
      //     int colorCode = floor(map(data[i][j], lowerLim, upperLim, 0, 8));
      //     colorCode = constrain(colorCode, 0, 7);
      //
      //     //Add alpha value to swatch color
      //     color c = color(red(swatch[colorCode]), green(swatch[colorCode]), blue(swatch[colorCode]), alpha*0.2);
      //
      //     stroke(c);
      //
      //     strokeWeight(20 * (alpha*0.05));
      //
      //     line( 5 * scale * (i-1) + 3 * cos(millis()*0.0001),
      //           4 * scale * (j-1) + 3 * cos(millis()*0.0001),
      //           5 * scale * i + 3 * sin(millis()*0.0001),
      //           (4 * scale * j + 3 * cos(millis()*0.0001)) * ((numOfReadingsStored-j)/numOfReadingsStored) );
      //     c = color(red(swatch[colorCode]) * alpha/100, blue(swatch[colorCode])  * alpha/100, green(swatch[colorCode]), alpha*0.1);
      //     //HORIZONTAL LINE
      //     strokeWeight(0.5);
      //     stroke(#FFFFFF);
      //     //line( (10 * baseWave) + 4 * scale * (i+1), 4 * scale * j, 4 * scale * i, 4 * scale * j);
      //     // c = color(red(swatch[colorCode]), blue(swatch[colorCode]), green(swatch[colorCode]), alpha);
      //     // stroke(c);
      //     // strokeWeight(0.5);
      //     // line( (10 * baseWave) + 4 * scale * i, 4 * scale * (j-1), 4 * scale * i, 4 * scale * j);
      //     // line( (10 * baseWave) + 4 * scale * (i+1), 4 * scale * j, 4 * scale * i, 4 * scale * j);
      //     // alpha = map(data[i][j], upperLim, lowerLim, 20, 100) * ((1.0*numOfReadingsStored-j)/numOfReadingsStored);
      //     // fill(color(255,255,255, alpha));
      //     // ellipse( (10 * baseWave) + 4 * scale * i, 4 * scale * j, 1, 1);
      //
      //   }//end j
      // }//end i
      popMatrix();
    }
  }
}
