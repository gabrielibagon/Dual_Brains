/*
Visualizations for Dual Brain

*/

ArrayList <Point> leftPoints;
ArrayList <Point> rightPoints;
PImage sprt;
PImage sprt2;
PImage colorOverlay;
PImage backgroundImg;

void setup(){
  size(800, 600);
  //sprt = loadImage("data/particle.png");
  //sprt = loadImage("data/particle-light.png");
  sprt2 = loadImage("data/particle-red.jpg");
  colorOverlay = loadImage("data/bokeh.jpg");
  backgroundImg = loadImage("data/background.png");
  leftPoints = new ArrayList<Point>();
  rightPoints = new ArrayList<Point>();
  background(0);
  frameRate(30);
  spawnLeft();
  spawnRight();
}

void draw(){
  //image(backgroundImg, width*0.5, height*0.5);
  colorMode(RGB,100);
  fill(0,0,0,7);
  rect(0,0,width,height);



  noStroke();
  if(frameCount % 20 == 0){
    spawnLeft();
    spawnRight();
  }
  for(Point pt : leftPoints){
    pt.render();
  }
  for(Point pt : rightPoints){
    pt.render();
  }
  prune();

}


void spawnLeft(){
  int interval = 10;
  for(int i = 0; i < height; i += 10){
    //Point(float locx, float locy, float sizeX, float sizeY, float speed, bool driftsLeft){
    float sizeX = random(20,120);
    Point pt = new Point(-width*0.1, i, sizeX, sizeX*0.5, random(0.01, 0.02), true);
    leftPoints.add(pt);
  }
}

void spawnRight(){
  int interval = 10;
  for(int i = 0; i < height; i += 10){
    //Point(float locx, float locy, float sizeX, float sizeY, float speed, bool driftsLeft){
    float sizeX = random(20,120);
    Point pt = new Point(width*1.1, i, sizeX, sizeX*0.5, random(0.01, 0.02), false);
    rightPoints.add(pt);
  }
}


void prune(){
  for(int i = leftPoints.size()-1; i > 0; i--){
    Point pt = leftPoints.get(i);
    if(pt.alive == false){
      leftPoints.remove(pt);
    }
  }
  for(int i = rightPoints.size()-1; i > 0; i--){
    Point pt = rightPoints.get(i);
    if(pt.alive == false){
      rightPoints.remove(pt);
    }
  }
}
