import org.gwoptics.graphics.*;
import org.gwoptics.graphics.graph2D.*;
import org.gwoptics.graphics.graph2D.Graph2D;
import org.gwoptics.graphics.graph2D.LabelPos;
import org.gwoptics.graphics.graph2D.traces.Blank2DTrace;
import org.gwoptics.graphics.graph2D.backgrounds.*;
import java.awt.Color;
import java.util.Arrays;
import java.util.Queue;
//import LSLProcessing;
//import LSL;
//import edu.ucsd.sccn.LSL;


boolean new_data;
float[][] current_data = new float[12][400];
//new_data = false;
int count = 0;


void draw()
{
  // We need to read in all the avilable data so graphing doesn't lag behind
  //while (g_serial.available() >= 2*6+2)
  //{
  //  processSerialData();
  //}
  background(0);
  if (data_list!=null){
    if (new_data == true){
      current_data = data_list;
      new_data = false;
    }
   update_values(current_data);

    //if (current_data[599]!= null){
    //  update_values(current_data);
    //}else{
    //  for (int i=0;i<12;i++){
    //    for (int j=count*200;j<count*200 + 200;j++){
    //      current_data[i][j] = 
    //    }
    //  }
  }
}
  //if (data_list!=null){
  //  if (k > 400 || k == 0){
  //    current_data = data_list;
  //    k=0;
  //  }
  //  float[] toPlot = Arrays.copyOfRange(current_data[0],k,k+200);
  //  update_values(toPlot);
  //  k=k+15;

  //if (new_data == true){
  // update_values(data_list[0]);
  // new_data = false;
  // k=0;
  //}

//data_list is where data is stored
float[][] data_list;
void setup(){
  size(1200,750);
  background(0);
  frameRate(250);
  strokeWeight(2);
  //color(255);
  stroke(255);
  
  //***********************************
  //NETWORKING
  //THIS MUST BE INCLUDED IN YOUR SETUP
  udp= new UDP(this,PORT_RX,HOST_IP);
  udp.log(true);
  udp.listen(true);
  super.start();
  //***********************************
}


public void update_values(float[][] data) {
  for (int k = 0;k<data.length;k++){
    float[] channel = data[k];
    if (k<6){
      //(channel);
      stroke(k*30 + 75);
      for (int i =0; i<399;i++){
        float xi = map(i,0,399,100,(width)/2 - 20);
        float yi = map(channel[i],-250,250,height-1 + k*75,0);
        float xii = map(i+1,0,399,100,(width)/2 - 20);
        float yii = map(channel[i+1],-250,250,height-1 + k*75,0);
        if (i >= 100) {
          stroke(k*30 + 75, k*30 + 75, k*30 + 75, map(i, 200, 399, 255, 0));
        }
        line(xi, yi,xii,yii); 
      }
    }else{
      int l = k-6;
      stroke(l*30 + 75);
      for (int i =0; i<399;i++){
        float xi = map(i,399,0,(width)/2,width-100);
        float yi = map(channel[i],-250,250,height-1 + l*75,0);
        float xii = map(i+1,399,0,(width)/2,(width-100));
        float yii = map(channel[i+1],-250,250,height-1 + l*75,0);
       if (i >= 100) {
          stroke(l*30 + 75, l*30 + 75, l*30 + 75, map(i, 200, 399, 255, 0));
        }
        line(xi, yi,xii,yii); 
      }
    }
      
  }
}

void mousePressed() {
  text(mouseX + " " +  mouseY, 100, 100);
}

// **********************************************************
// NETWORKING

import hypermedia.net.*;
import java.util.Scanner;
int PORT_RX=6100; //port
String HOST_IP="127.0.0.1"; //
UDP udp;
String receivedFromUDP = "";

void receive(byte[] received_data) {
  receivedFromUDP ="";
  String data = new String(received_data);
  String[] items = data.replaceAll("\\[","").replaceAll("\\]","").split(",");
  data_list = new float[12][items.length/12];
  for (int i=0;i<12;i++){
    for (int j = 0; j<400;j++){
      data_list[i][j] = Float.parseFloat(items[100*i + j]);

    }
  }
   //(data_list[0]);
 new_data = true;
}


//void receive(){