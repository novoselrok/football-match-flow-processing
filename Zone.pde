class Zone {
  float x;
  float y;
  float w;
  float h;
  
  int count = 0;
  boolean clicked = false;
  
  Zone(float x1, float y1, float x2, float y2) {
    // println("zone", pitch);
    float zWidth = x2 - x1;
    float zHeight = y2 - y1;
    x = pitch.w * x1 / 100;
    y = pitch.h * (100 - y1 - zHeight) / 100;
    w = pitch.w * zWidth / 100;
    h = pitch.h * zHeight / 100;  
  }
  
  void drawZone() {
    noFill();
    rect(x, y, w, h);
    fill(#FFFFFF);
    if (isPointInZone(mouseX, mouseY)) {
      drawText();
    }
  }
  
  void drawText() {
    fill(#000000);
    textSize(32);
    textAlign(CENTER);
    fill(0, 102, 153);
    text("" + count, x + w / 2, y + h / 2); 
  }
  
  boolean isPointInZone(double pX, double pY) {
    return pX > (pitch.x + x) + 10 && 
           pX < (pitch.x + x) + w - 10 &&
           pY > (pitch.y + y) + 10 && 
           pY < (pitch.y + y) + h - 10;
  }
}