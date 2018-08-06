import controlP5.*; //<>// //<>//
ControlP5 cp5;

final int NO_DATA = 0;
final int STREAM_DATA = 1;
final int RANDOM_DATA = 2;
final int PREVIEW_DATA = 3;
int dataSource = NO_DATA;
//float leftGS= 1.0, rightGS= 1.0;

class Controls extends PApplet {
  //JFrame frame;

  Textlabel label;
  Textarea leftTextarea;
  Textarea rightTextarea;
  Chart[] leftCharts, rightCharts;
  String [] L = {"L1", "L2", "L3", "L4", "L5", "L6"};
  String [] R = {"R1", "R2", "R3", "R4", "R5", "R6"};

  public Controls() {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  String prevData1[], prevData2[]; //, prevData3[], prevData4[];
  boolean showData = false;
  int boxX, boxY, interval;

  public void settings() {
    size(550, 400, P2D);
    smooth();
  }

  public void setup() { 
    prevData1 = new String[6];
    prevData2 = new String[6];
    //prevData3 = new String[6];
    //prevData4 = new String[6];
    leftCharts = new Chart[6];
    rightCharts = new Chart[6];
    boxX = width/2-102;
    boxY = 40;
    interval = 30;

    surface.setTitle("Controls");
    cp5 = new ControlP5(this);

    label = cp5.addTextlabel("label")
      .setText("")
      .setPosition(35, 15)
      .setColorValue(0xffffffff)
      ;

    cp5.addBang("randomData")
      .setPosition(35, 40)
      .setSize(100, 40)
      .setLabel("Random")
      ;

    cp5.addBang("noData")
      .setPosition(35, 100)
      .setSize(100, 40)
      .setLabel("No Data")
      ;  

    cp5.addBang("streamData")
      .setPosition(35, 160)
      .setSize(100, 40)
      .setLabel("Stream")
      ;

    cp5.addBang("touchHand")
      .setPosition(35, 320)
      .setSize(100, 40)
      .setLabel("Touching Hands")
      ;

    cp5.addBang("preview")
      .setPosition(35, 220)
      .setSize(100, 40)
      .setLabel("Preview stream")
      ;

    leftTextarea = cp5.addTextarea("left")
      .setPosition(boxX, boxY)
      .setSize(120, 110)
      .setFont(createFont("arial", 12))
      .setLineHeight(14)
      .setColor(color(255))
      .setColorBackground(color(#1450C8))
      .setColorForeground(color(255))
      .setTitle("Left Data") 
      .hideScrollbar();
    ;
    leftTextarea.setText("Left Data");

    rightTextarea = cp5.addTextarea("right")
      .setPosition(boxX + 220, boxY)
      .setSize(120, 110)
      .setFont(createFont("arial", 12))
      .setLineHeight(14)
      .setColor(color(255))
      .setColorBackground(color(#1450C8))
      .setColorForeground(color(255))
      .hideScrollbar();
    ;
    rightTextarea.setText("Right Data");

    buildLeftCharts();
    buildRightCharts();
    buildLeftSliders();
    buildRightSliders();
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
      previewData();
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
  }

  public void previewData() {
    if (dataSource == PREVIEW_DATA && isReceivingData) {

      if (frameCount % interval == 0 ) {
        for (int i = 0; i < 6; i++) {
          prevData1[i] = str(subj1_eeg[i]);
          prevData2[i] = str(subj2_eeg[i]);
          //prevData3[i] = str(subj1_fft[i]);
          //prevData4[i] = str(subj2_fft[i]);
        }

        String leftText = "Left data EEG:\n";
        String rightText = "Right data EEG: \n";

        for (int i = 5; i >=0; i--) {  //I THINK I have the data feeds right here...
          leftText += prevData1[i] + "\n";
          rightText += prevData2[i] + "\n";
        }
        leftTextarea.setText(leftText);
        rightTextarea.setText(rightText);

        for (int i = 0, j = 5; i < leftCharts.length; i++, j--) {
          leftCharts[i].push(L[i], subj1_eeg[j]);
        }

        for (int i = 0, j = 5; i < rightCharts.length; i++, j--) {
          rightCharts[i].push(R[i], subj2_eeg[j]);
        }
      }
    }
  }

  public void LGS (float newVal) {
    adjLeftGlobalVals = newVal;
    // println("left global adjuster" + adjLeftGlobalVals);
  }

  public void RGS (float newVal) {
    adjRightGlobalVals = newVal;
    //println("right global adjuster" + adjRightGlobalVals);
  }
  private void buildLeftCharts() {
    for (int i = 0; i < L.length; i++) {
      leftCharts[i] = cp5.addChart(L[i])
        .setPosition(boxX, boxY + 115 + (i * 35))
        .setSize(120, 30)
        .setRange(-50, 50)
        .setView(Chart.LINE)
        .setStrokeWeight(3)
        .setColorBackground(#1450C8)
        .setColorForeground(color(0))
        .setColorCaptionLabel(color(255))
        ;
      leftCharts[i].addDataSet(L[i]);
      leftCharts[i].setData(L[i], new float[100]);
      leftCharts[i].setColors(L[i], color(255));
    }
  }

  private void buildRightCharts() {
    for (int i = 0; i < R.length; i++) {
      rightCharts[i] = cp5.addChart(R[i])
        .setPosition(boxX + 220, boxY + 115 + (i * 35))
        .setSize(120, 30)
        .setRange(-50, 50)
        .setView(Chart.LINE)
        .setStrokeWeight(3)
        .setColorBackground(#1450C8)
        .setColorForeground(color(0))
        .setColorCaptionLabel(color(255))
        ;
      rightCharts[i].addDataSet(R[i]);
      rightCharts[i].setData(R[i], new float[100]);
      rightCharts[i].setColors(R[i], color(255));
    }
  }

  public void buildLeftSliders() {
    cp5.addSlider("LGS")
      .setPosition(boxX + 125, boxY)
      .setSize(20, 110)
      .setRange(0.0, 10.0)
      .setValue(1.0)
      ;
    cp5.getController("LGS").getValueLabel().align(ControlP5.LEFT, ControlP5.RIGHT).setPaddingX(0);
  }

  public void buildRightSliders() {
    cp5.addSlider("RGS")
      .setPosition(boxX + 195, boxY)
      .setSize(20, 110)
      .setRange(0.0, 10.0)
      .setValue(1.0)
      ;
    cp5.getController("RGS").getValueLabel().align(ControlP5.LEFT, ControlP5.RIGHT).setPaddingX(0);
  }
}  // end class
