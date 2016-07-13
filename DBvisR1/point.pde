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
    this.tLoc = new PVector(width*0.5, locy);
    this.sizeX = sizeX;
    this.sizeY = sizeY;
    this.speed = speed;
    this.driftsLeft = driftsLeft;
    this.opac = 255;
    this.c = color(255,255,255, 40);
    this.alive = true;
    //this.render();
  }

  void move(){
    loc.x = lerp(loc.x, tLoc.x, speed);
    tLoc.y = tLoc.y + random(-5,5);
    loc.y = lerp(loc.y, tLoc.y, speed);
    //lerp for left drifters
    if(driftsLeft && loc.x > width*0.2){
      sizeX = lerp(sizeX, 4, 0.03);
      sizeY = lerp(sizeY, 4, 0.06);
    }
    if(driftsLeft && loc.x > width*0.45){
      c = lerpColor(c, color(0,0,0,0), .01);
      opac = lerp(opac, 0, 0.01);
    }

    //lerp for right drifters
    if(!driftsLeft && loc.x < width*0.8){
      sizeX = lerp(sizeX, 4, 0.03);
      sizeY = lerp(sizeY, 4, 0.06);
    }
    if(!driftsLeft && loc.x < width*0.55){
      c = lerpColor(c, color(0,0,0,0), .01);
      opac = lerp(opac, 0, 0.01);
    }

    if(driftsLeft && loc.x > width*0.48){
      alive = false;
    }

    if(!driftsLeft && loc.x < width*0.52){
      alive = false;
    }
  }

  void show(){
    noStroke();
    colorMode(RGB, 100);
    fill(c);
    //ellipse(this.loc.x, this.loc.y, sizeX, sizeY);
    //println("Drawing to " + loc.x + ", " + loc.y);
    pushMatrix();
    translate(this.loc.x, this.loc.y);
    rotate(random(0,PI*0.1));
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

  void render(){
    move();
    show();
  }
}
