import controlP5.*;

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
  Chart leftChart1, leftChart2, leftChart3, leftChart4, leftChart5, leftChart6;
  Chart rightChart1, rightChart2, rightChart3, rightChart4, rightChart5, rightChart6;
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

    //for (int i = 1; i <=6; i++) {
    //  String leftString = "leftChart"+ Integer.toString(i);
    //  String rightString = "rightChart"+ Integer.toString(i);
    //}
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
      //previewGraph();
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

        leftChart1.push("L1", subj1_eeg[5]);
        leftChart2.push("L2", subj1_eeg[4]);
        leftChart3.push("L3", subj1_eeg[3]);
        leftChart4.push("L4", subj1_eeg[2]);
        leftChart5.push("L5", subj1_eeg[1]);
        leftChart6.push("L6", subj1_eeg[0]);


        rightChart1.push("R1", subj2_eeg[5]);
        rightChart2.push("R2", subj2_eeg[4]);
        rightChart3.push("R3", subj2_eeg[3]);
        rightChart4.push("R4", subj2_eeg[2]);
        rightChart5.push("R5", subj2_eeg[1]);
        rightChart6.push("R6", subj2_eeg[0]);
      }
      //leftChart1.push("incoming", (sin(frameCount*0.2)*10));
      //adjLeftGlobalVals = cp5.getController("LGS").getValue();
      //adjRightGlobalVals = cp5.getController("RGS").getValue();
      println("left global adjuster" + adjLeftGlobalVals);
      println("right global adjuster" + adjRightGlobalVals);
    }
  }
  
  public void LGS (float newVal){
    adjLeftGlobalVals = newVal;
    println("left global adjuster" + adjLeftGlobalVals);
  }
  
    public void RGS (float newVal){
    adjRightGlobalVals = newVal;
    println("right global adjuster" + adjRightGlobalVals);
  }
  
  private void buildLeftCharts() {

    leftChart1 = cp5.addChart("L1")
      .setPosition(boxX, boxY + 115)
      .setSize(120, 30)
      .setRange(-50, 50)
      .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
      .setStrokeWeight(3)
      .setColorBackground(#1450C8)
      .setColorForeground(color(0))
      .setColorCaptionLabel(color(255))
      ;
    leftChart1.addDataSet("L1");
    leftChart1.setData("L1", new float[100]);
    leftChart1.setColors("L1", color(255));

    leftChart2 = cp5.addChart("L2")
      .setPosition(boxX, boxY + 150)
      .setSize(120, 30)
      .setRange(-50, 50)
      .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
      .setStrokeWeight(3)
      .setColorBackground(#1450C8)
      .setColorForeground(color(0))
      .setColorCaptionLabel(color(255))
      ;
    leftChart2.addDataSet("L2");
    leftChart2.setData("L2", new float[100]);
    leftChart2.setColors("L2", color(255));

    leftChart3 = cp5.addChart("L3")
      .setPosition(boxX, boxY + 185)
      .setSize(120, 30)
      .setRange(-50, 50)
      .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
      .setStrokeWeight(3)
      .setColorBackground(#1450C8)
      .setColorForeground(color(0))
      .setColorCaptionLabel(color(255))
      ;
    leftChart3.addDataSet("L3");
    leftChart3.setData("L3", new float[100]);
    leftChart3.setColors("L3", color(255));

    leftChart4 = cp5.addChart("L4")
      .setPosition(boxX, boxY + 220)
      .setSize(120, 30)
      .setRange(-50, 50)
      .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
      .setColorBackground(#1450C8)
      .setColorForeground(color(0))
      .setColorCaptionLabel(color(255))
      ;
    leftChart4.addDataSet("L4");
    leftChart4.setData("L4", new float[100]);
    leftChart4.setColors("L4", color(255));

    leftChart5 = cp5.addChart("L5")
      .setPosition(boxX, boxY + 255)
      .setSize(120, 30)
      .setRange(-50, 50)
      .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
      .setStrokeWeight(3)
      .setColorBackground(#1450C8)
      .setColorForeground(color(0))
      .setColorCaptionLabel(color(255))
      ;
    leftChart5.addDataSet("L5");
    leftChart5.setData("L5", new float[100]);
    leftChart5.setColors("L5", color(255));

    leftChart6 = cp5.addChart("L6")
      .setPosition(boxX, boxY + 290)
      .setSize(120, 30)
      .setRange(-50, 50)
      .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
      .setStrokeWeight(3)
      .setColorBackground(#1450C8)
      .setColorForeground(color(0))
      .setColorCaptionLabel(color(0))
      ;
    leftChart6.addDataSet("L6");
    leftChart6.setData("L6", new float[100]);
    leftChart6.setColors("L6", color(255));
  }


  private void buildRightCharts() {

    rightChart1 = cp5.addChart("R1")
      .setPosition(boxX + 220, boxY + 115)
      .setSize(120, 30)
      .setRange(-50, 50)
      .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
      .setStrokeWeight(3)
      .setColorBackground(#1450C8)
      .setColorForeground(color(0))
      .setColorCaptionLabel(color(255))
      ;
    rightChart1.addDataSet("R1");
    rightChart1.setData("R1", new float[100]);
    rightChart1.setColors("R1", color(255));

    rightChart2 = cp5.addChart("R2")
      .setPosition(boxX + 220, boxY + 150)
      .setSize(120, 30)
      .setRange(-50, 50)
      .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
      .setStrokeWeight(3)
      .setColorBackground(#1450C8)
      .setColorForeground(color(0))
      .setColorCaptionLabel(color(255))
      ;
    rightChart2.addDataSet("R2");
    rightChart2.setData("R2", new float[100]);
    rightChart2.setColors("R2", color(255));

    rightChart3 = cp5.addChart("R3")
      .setPosition(boxX + 220, boxY + 185)
      .setSize(120, 30)
      .setRange(-50, 50)
      .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
      .setStrokeWeight(3)
      .setColorBackground(#1450C8)
      .setColorForeground(color(0))
      .setColorCaptionLabel(color(255))
      ;
    rightChart3.addDataSet("R3");
    rightChart3.setData("R3", new float[100]);
    rightChart3.setColors("R3", color(255));

    rightChart4 = cp5.addChart("R4")
      .setPosition(boxX + 220, boxY + 220)
      .setSize(120, 30)
      .setRange(-50, 50)
      .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
      .setStrokeWeight(3)
      .setColorBackground(#1450C8)
      .setColorForeground(color(0))
      .setColorCaptionLabel(color(255))
      ;
    rightChart4.addDataSet("R4");
    rightChart4.setData("R4", new float[100]);
    rightChart4.setColors("R4", color(255));


    rightChart5 = cp5.addChart("R5")
      .setPosition(boxX + 220, boxY + 255)
      .setSize(120, 30)
      .setRange(-50, 50)
      .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
      .setStrokeWeight(3)
      .setColorBackground(#1450C8)
      .setColorForeground(color(0))
      .setColorCaptionLabel(color(255))
      ;
    rightChart5.addDataSet("R5");
    rightChart5.setData("R5", new float[100]);
    rightChart5.setColors("R5", color(255));


    rightChart6 = cp5.addChart("R6")
      .setPosition(boxX + 220, boxY + 290)
      .setSize(120, 30)
      .setRange(-50, 50)
      .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
      .setStrokeWeight(3)
      .setColorBackground(#1450C8)
      .setColorForeground(color(0))
      .setColorCaptionLabel(color(0))
      ;
    rightChart6.addDataSet("R6");
    rightChart6.setData("R6", new float[100]);
    rightChart6.setColors("R6", color(255));
  }

  public void buildLeftSliders() {
    cp5.addSlider("LGS")
      .setPosition(boxX + 125, boxY)
      .setSize(20, 110)
      .setRange(0.0, 8.0)
      .setValue(1.0)
      ;
    cp5.getController("LGS").getValueLabel().align(ControlP5.LEFT, ControlP5.RIGHT).setPaddingX(0);
  }

  public void buildRightSliders() {
    cp5.addSlider("RGS")
      .setPosition(boxX + 195, boxY)
      .setSize(20, 110)
      .setRange(0.0, 8.0)
      .setValue(1.0)
      ;
    cp5.getController("RGS").getValueLabel().align(ControlP5.LEFT, ControlP5.RIGHT).setPaddingX(0);
  }
}  // end class
