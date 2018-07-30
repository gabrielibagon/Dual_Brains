// temp control to test data stream
//TODO: integrate this into the controlP5 window

class PWindow extends PApplet {
  PWindow() {
    super();
    PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
  }

  boolean showData = false;
  String s1[], s2[], s3[], s4[];

  void settings() {
    size(500, 300);
    //frame.setLocation(500, 300);
  }

  void setup() {
    s1 = new String[6];
    s2 = new String[6];
    s3 = new String[6];
    s4 = new String[6];
    background(150);
  }

  void draw() {
    if (showData) {
      pushStyle();
      background(100);
      fill (150);
      rect(15,30, 175,225); 
      rect(210,30, 175,225); 

      fill (255);
      textSize(15);
      text("Subject 1: ", 25, 55);
      text("Subject 2: ", 225, 55);

      if (dataSource == PREVIEW_DATA && isReceivingData) {
        text("Data source: STREAM!", 5, 20);
        for (int i = 0; i < 6; i++) {
          s1[i] = str(subj1_eeg[i]);
          s2[i] = str(subj2_eeg[i]);
          s3[i] = str(subj1_fft[i]);
          s4[i] = str(subj2_fft[i]);
        }
      } 
      for (int i = 0; i < 6; i++) {
        text("eeg: " + s1[i], 25, 75 + (i*13));
        text("eeg: " + s2[i], 225, 75 + (i*13));
        text("fft: " + s3[i], 25, 170 + (i*13));
        text("fft: " + s4[i], 225, 170 + (i*13));
      }


      popStyle();
    } else {
      background(150);
      textSize(25);
      text("Click anywhere for data stream test...", 20, 100);
    }
  }

  void mousePressed() {
    showData = (showData == true? false: true);
  }
}
