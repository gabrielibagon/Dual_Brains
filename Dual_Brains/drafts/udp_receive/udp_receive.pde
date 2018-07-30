import hypermedia.net.*;
int PORT_RX=8000; //port
String HOST_IP="127.0.0.1"; //
UDP udp;
String receivedFromUDP = "";

void setup() {
  size(400,400);
  udp= new UDP(this,PORT_RX,HOST_IP);
  //udp.log(true);
  udp.listen(true);
  super.start();
}

void draw() {
}

void receive(byte[] data, String HOST_IP, int PORT_RX) {
  receivedFromUDP ="";
  for (int i = 0; i < data.length; i++) {
    receivedFromUDP += str(data[i]) + " ";
  }
  String txtString = new String(data);
  println(txtString);
}