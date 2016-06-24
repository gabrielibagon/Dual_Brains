float[] dataSet;

void setup(){
  dataSet = new float[125];
  repopulateFakeData();
  size(800,125);
  background(0);
  frameRate(30);
}

void draw(){
  noStroke();
  //copy(sourceX, sourceY, sourceW, sourceH, dx, dy, dw, dh)
  copy(0,0,width,height, 1,0, width, height);
  for(int i = 0; i < 125; i++){
    set(0, i, color((int)map(dataSet[i], 0, 100, 0, 255)));
    println((int)map(dataSet[i], 0, 100, 0, 255));
  }
  repopulateFakeData();
}


void repopulateFakeData(){
  int i = 0;
  for(float num : dataSet){
    dataSet[i] = random(0,100);
    i++;
  }
}
