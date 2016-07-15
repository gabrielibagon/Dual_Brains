class Point {
  PVector loc;
  PVector tLoc;
  //PImage sprt;
  float speed;
  float sizeX;
  float sizeY;
  color c;
  float opac;
  boolean alive;
  boolean driftsLeft;

  //TODO
  //Add color init
  //Add sprite;
  Point(float locx, float locy, float sizeX, float sizeY, float speed, boolean driftsLeft){
    this.loc = new PVector(locx, locy);
    if(driftsLeft){
      this.tLoc = new PVector(-0.1*width, locy * sq((height-locy)/height));
    } else {
      this.tLoc = new PVector(1.1*width, locy * sq((height-locy)/height));
    }
    this.sizeX = sizeX;
    this.sizeY = sizeY;
    this.speed = speed;
    this.driftsLeft = driftsLeft;
    this.opac = 0;
    this.alive = true;
  }

  void move(){
    loc.x = lerp(loc.x, tLoc.x, speed);
    tLoc.y = tLoc.y + random(-5,5) + 5 * cos(millis()*0.1);
    loc.y = lerp(loc.y, tLoc.y, speed);
    //lerp for left drifters
    if(driftsLeft && loc.x > -0.1*width){
      sizeX = lerp(sizeX, 4, 0.03);
      sizeY = lerp(sizeY, 4, 0.03);
    }
    if(driftsLeft && loc.x > -0.1*width){
      //c = lerpColor(c, color(255,255,255,0), 10);
      opac = lerp(opac, 90, 0.05);
    }

    //lerp for right drifters
    if(!driftsLeft && loc.x < width*1.1){
      sizeX = lerp(sizeX, 4, 0.03);
      sizeY = lerp(sizeY, 4, 0.03);
    }
    if(!driftsLeft && loc.x < width*1.1){
      //c = lerpColor(c, color(0,0,0,0.001), .01);
      opac = lerp(opac, 90, 0.05);
    }

    if(driftsLeft && loc.x < -0.1*width){
      alive = false;
    }

    if(!driftsLeft && loc.x > width*1.1){
      alive = false;
    }
  }

  void show(){

    //println("Drawing to " + loc.x + ", " + loc.y);
    pushMatrix();
      translate(this.loc.x, this.loc.y, 10);
      rotate(random(0,PI*0.05));
      noStroke();

      color temp = color(230,230,250,opac*0.1);
      fill(temp);
      ellipse(5 * cos(millis()*0.005), 0, sizeX, sizeY);

      temp = color(230,230,250,opac*0.1);
      fill(temp);
      ellipse(3 * cos(millis()*0.005), 0, sizeX*0.8, sizeY*0.8);

      temp = color(255,255,255,opac);
      fill(temp);
      ellipse(0, 3 * cos(millis()*0.005), sizeX*0.05, sizeY*0.05);


    popMatrix();
  }

  void render(){
    move();
    show();
  }
}
