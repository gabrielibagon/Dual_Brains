import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class DBvisR1 extends PApplet {

/*
Visualizations for Dual Brain

*/

ArrayList <Point> leftPoints;
ArrayList <Point> rightPoints;
PImage sprt;
PImage sprt2;
PImage colorOverlay;
PImage backgroundImg;

public void setup(){
  
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

public void draw(){
  //image(backgroundImg, width*0.5, height*0.5);
  colorMode(RGB,100);
  fill(0,0,0,70);
  noStroke();
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


public void spawnLeft(){
  int interval = 10;
  for(int i = 0; i < height; i += 10){
    //Point(float locx, float locy, float sizeX, float sizeY, float speed, bool driftsLeft){
    float sizeX = random(20,120);
    Point pt = new Point(-width*0.1f, i, sizeX, sizeX*0.5f, random(0.01f, 0.02f), true);
    leftPoints.add(pt);
  }
}

public void spawnRight(){
  int interval = 10;
  for(int i = 0; i < height; i += 10){
    //Point(float locx, float locy, float sizeX, float sizeY, float speed, bool driftsLeft){
    float sizeX = random(20,120);
    Point pt = new Point(width*1.1f, i, sizeX, sizeX*0.5f, random(0.01f, 0.02f), false);
    rightPoints.add(pt);
  }
}


public void prune(){
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
class Point {
  PVector loc;
  PVector tLoc;
  //PImage sprt;
  float speed;
  float sizeX;
  float sizeY;
  int c;
  float opac;
  boolean alive;
  boolean driftsLeft;

  //TODO
  //Add color init
  //Add sprite;
  Point(float locx, float locy, float sizeX, float sizeY, float speed, boolean driftsLeft){
    this.loc = new PVector(locx, locy);
    this.tLoc = new PVector(width*0.5f, locy);
    this.sizeX = sizeX;
    this.sizeY = sizeY;
    this.speed = speed;
    this.driftsLeft = driftsLeft;
    this.opac = 255;
    this.c = color(255,255,255, 40);
    this.alive = true;
    //this.render();
  }

  public void move(){
    loc.x = lerp(loc.x, tLoc.x, speed);
    tLoc.y = tLoc.y + random(-5,5);
    loc.y = lerp(loc.y, tLoc.y, speed);
    //lerp for left drifters
    if(driftsLeft && loc.x > width*0.2f){
      sizeX = lerp(sizeX, 4, 0.03f);
      sizeY = lerp(sizeY, 4, 0.06f);
    }
    if(driftsLeft && loc.x > width*0.45f){
      c = lerpColor(c, color(0,0,0,0), .01f);
      opac = lerp(opac, 0, 0.01f);
    }

    //lerp for right drifters
    if(!driftsLeft && loc.x < width*0.8f){
      sizeX = lerp(sizeX, 4, 0.03f);
      sizeY = lerp(sizeY, 4, 0.06f);
    }
    if(!driftsLeft && loc.x < width*0.55f){
      c = lerpColor(c, color(0,0,0,0), .01f);
      opac = lerp(opac, 0, 0.01f);
    }

    if(driftsLeft && loc.x > width*0.48f){
      alive = false;
    }

    if(!driftsLeft && loc.x < width*0.52f){
      alive = false;
    }
  }

  public void show(){
    noStroke();
    colorMode(RGB, 100);
    fill(c);
    //ellipse(this.loc.x, this.loc.y, sizeX, sizeY);
    //println("Drawing to " + loc.x + ", " + loc.y);
    pushMatrix();
    translate(this.loc.x, this.loc.y);
    rotate(random(0,PI*0.1f));
    //tint(opac);
    //blendMode(ADD);
    imageMode(CENTER);
    //image(sprt, 0, 0, sizeX, sizeY);
    //image(sprt2, 0, 0, sizeX, sizeY);
    strokeCap(PROJECT);
    strokeWeight(60);
    colorMode(ARGB, 255,255,255,100);
    stroke(color(255,255,255,5*random(0,1)));
    line(-5,0,5,0);
    //image(sprt, this.loc.x, this.loc.y, sizeX, sizeY);
    popMatrix();
  }

  public void render(){
    move();
    show();
  }
}
  public void settings() {  size(800, 600); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "DBvisR1" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
