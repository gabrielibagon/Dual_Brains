float[] dataSet; //random values
void draw(){
  return;
}
//data_list is where data is stored
float[] data_list;

void setup(){
  dataSet = new float[125];
  size(800,125);
  background(0);
  frameRate(30);
  //***********************************
  //NETWORKING
  //THIS MUST BE INCLUDED IN YOUR SETUP
  udp= new UDP(this,PORT_RX,HOST_IP);
  udp.log(true);
  udp.listen(true);
  super.start();

}

void drawStuff(float[] data_list){
  println(data_list);
  noStroke();
  //copy(sourceX, sourceY, sourceW, sourceH, dx, dy, dw, dh)
  copy(0,0,width,height, 1,0, width, height);
  //for(int i = 0; i < 5; i++){
  //  //println(data_list[0]);
  //  rect(0, i, color((int)map(data_list[i], -20, 20, 0, 255)));
    //println((int)map(dataSet[i], 0, 100, 0, 255));
  //}
}

// //Populate dataSet with with random Values
// void data_to_draw(float[] data){
//   int i = 0;
//   println(dataSet);
//   for(float num : dataSet){
//     dataSet[i] = random(0,100);
//     i++;
//   }
// }

// **********************************************************
// NETWORKING

import hypermedia.net.*;
import java.util.Scanner;
int PORT_RX=8000; //port
String HOST_IP="127.0.0.1"; //
UDP udp;
String receivedFromUDP = "";

void receive(byte[] received_data, String HOST_IP, int PORT_RX) {
  receivedFromUDP ="";
  String datatat = new String(received_data);
  String[] items = datatat.replaceAll("\\[","").replaceAll("\\]","").split(",");
  data_list = new float[items.length];

  for (int i=0;i<items.length;i++){
    data_list[i] = Float.parseFloat(items[i]);
  }

  // SEND THIS BAD BOY OVER TO YR FUNCTIONS!
  drawStuff(data_list);
}