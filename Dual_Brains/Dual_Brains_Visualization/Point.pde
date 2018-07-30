class Point {
  PVector loc;
  PVector tLoc;
  float speed;
  float sizeX;
  float sizeY;
  color c;
  float opac;
  boolean alive;
  boolean driftsLeft;

  Point(float locx, float locy, float sizeX, float sizeY, float speed, boolean driftsLeft){
    this.loc = new PVector(locx, locy);
    if(driftsLeft){
      this.tLoc = new PVector(-0.2*width, -locy*(locy/height));
    } else {
      this.tLoc = new PVector(1.2*width,-locy*(locy/height));
    }
    this.sizeX = sizeX;
    this.sizeY = sizeY;
    this.speed = speed;
    this.opac = 0;
    this.alive = true;
  }

  void move(){
    this.loc.x = lerp(this.loc.x, this.tLoc.x, this.speed);
    this.loc.y = lerp(this.loc.y, this.tLoc.y, abs(this.loc.y-this.tLoc.y)*0.001* this.speed);

    this.sizeY = this.sizeX = lerp(this.sizeX, 4, 0.03);
    this.opac = lerp(this.opac, 90, 0.05);
    
    if( this.loc.y < UPPER_BORDER || this.loc.x < LEFT_BORDER || this.loc.x > RIGHT_BORDER ) {
      this.alive = false;
    }
  }

  void show(){
    pushMatrix();
      translate(this.loc.x, this.loc.y, 10);
      noStroke();

      fill(color(230,230,250,opac*0.1));
      ellipse(5 * cos(millis()*0.005), 0, sizeX, sizeY);

      fill(color(230,230,250,opac*0.1));
      ellipse(3 * cos(millis()*0.005), 0, sizeX*0.8, sizeY*0.8);

      fill(color(255,255,255,opac));
      ellipse(0, 3 * cos(millis()*0.005), sizeX*0.05, sizeY*0.05);
    popMatrix();
  }

  void render(){
    move();
    show();
  }
}