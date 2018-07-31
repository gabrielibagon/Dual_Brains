import controlP5.*;

ControlP5 cp5;
Textlabel label;

final int NO_DATA = 0;
final int STREAM_DATA = 1;
final int RANDOM_DATA = 2;
final int PREVIEW_DATA = 3;
int dataSource = NO_DATA;

class Controls extends PApplet {
  //JFrame frame;

  public Controls() {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  String prevData1[], prevData2[], prevData3[], prevData4[];
  boolean showData = false;
  int boxX, boxY, interval;

  public void settings() {
    size(500, 400, P2D);
    smooth();
  }
  public void setup() { 

    prevData1 = new String[6];
    prevData2 = new String[6];
    prevData3 = new String[6];
    prevData4 = new String[6];
    boxX = width/2-50;
    boxY = 30;
    interval = 60;

    surface.setTitle("Controls");
    cp5 = new ControlP5(this);

    label = cp5.addTextlabel("label")
      .setText("")
      .setPosition(50, 15)
      .setColorValue(0xffffffff)
      ;

    cp5.addBang("randomData")
      .setPosition(50, 40)
      .setSize(100, 40)
      .setLabel("Random")
      ;

    cp5.addBang("noData")
      .setPosition(50, 100)
      .setSize(100, 40)
      .setLabel("No Data")
      ;  

    cp5.addBang("streamData")
      .setPosition(50, 160)
      .setSize(100, 40)
      .setLabel("Stream")
      ;

    cp5.addBang("touchHand")
      .setPosition(50, 300)
      .setSize(100, 40)
      .setLabel("Touching Hands")
      ;

    cp5.addBang("preview")
      .setPosition(50, 220)
      .setSize(100, 40)
      .setLabel("Preview stream")
      ;
  }

  public void draw() {

    background(0);
    switch(dataSource) {
    case NO_DATA: 
      label.setText("Sending No Data");
      break;
    case STREAM_DATA: 
      label.setText("Sending Stream Data");
      break;
    case RANDOM_DATA: 
      label.setText("Sending Random Data");
      break;
    case PREVIEW_DATA: 
      label.setText("Testing Stream Data");
      break;
    }
    if (showData) {
      pushStyle();
      fill(20, 80, 200);
      stroke(0);
      strokeWeight(4);
      rect(boxX, boxY, width/2 +40, height - 20);
      line(boxX + 145, boxY, boxX + 145, height);
      fill (255);
      textSize(12);
      text("Subject 1: ", boxX + 10, boxY + 15);
      text("Subject 2: ", boxX + 155, boxY + 15);
      previewData();
      popStyle();
    }
    label.draw(this);
  }

  public void randomData() { 
    dataSource = RANDOM_DATA;
  }
  public void noData() { 
    dataSource = NO_DATA;
  }
  public void streamData() { 
    dataSource = STREAM_DATA;
  }
  public void touchHand() { 
    handsTouching = !handsTouching;
  }
  public void preview() { 
    showData = !showData;
    dataSource = PREVIEW_DATA;
    //win = new PWindow();
  }
  public void previewData() {
    
    //fill (#FFFF00);
    text("Data stream activity: ", boxX + 50, 15);
    pushStyle();
    strokeWeight(1);
    stroke(255);
    noFill();
    rect (boxX + 180, 8, 15,15);
    popStyle();
     
    if (dataSource == PREVIEW_DATA && isReceivingData) {
      pushStyle();
      noStroke();
      fill(#FFFF00);
      rect (boxX + 180, 8, 15,15);
     popStyle();
      if (frameCount % interval == 0 ) {
        for (int i = 0; i < 6; i++) {
          prevData1[i] = str(subj1_eeg[i]);
          prevData2[i] = str(subj2_eeg[i]);
          prevData3[i] = str(subj1_fft[i]);
          prevData4[i] = str(subj2_fft[i]);
        }
      }
      for (int i = 0; i < 6; i++) {
        text("eeg: " + prevData1[i], boxX + 10, boxY + 30 + (i*13));
        text("eeg: " + prevData2[i], boxX + 155, boxY + 30 + (i*13));
        text("fft: " + prevData3[i], boxX + 10, boxY + 200 + (i*13));
        text("fft: " + prevData4[i], boxX + 155, boxY + 200 + (i*13));
      }
    } 
   
  }
}
