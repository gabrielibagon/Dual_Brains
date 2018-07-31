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

  public void settings() {
    size(500, 400, P2D);
    smooth();
  }
  public void setup() { 

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
    if (win == null) {
      dataSource = PREVIEW_DATA;
      win = new PWindow();
    } 
  }
}
