class Controls {
  
  int x, y, w, h, controlsStart;
  PImage play, pause, stop;

  Controls(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    
    controlsStart = w/3+25;
    play = loadImage("play.png");
    pause = loadImage("pause.png");
    stop = loadImage("stop.png");
  }

  
  void drawControls() {
    pushMatrix();
    pushStyle();
     
    translate(x, y);
    imageMode(CENTER);
    image(play, w/2-50, h/3);
    image(pause, w/2, h/3);
    image(stop, w/2+50, h/3);
    
    rectMode(CENTER);
    textAlign(CENTER);
    
    if (playerMode == 1) {
      fill(color(255, 255, 255));
      rect(w/2, h/3*2, 220, 25);
      fill(color(0, 102, 153));
      text("Toggle histogram numbers", w/2, h/3*2 + 5);
    } else {
      fill(color(0, 102, 153));
      rect(w/2, h/3*2, 220, 25);
      fill(color(255, 255, 255));
      text("Toggle histogram numbers", w/2, h/3*2 + 5);
    }
    
    popStyle();
    popMatrix();
  }
  
  void mouseClicked() {
    int clickY = mouseY - y - h/3 + 50;
    if (clickY > h/3 - 25 && clickY < h/3 + 25) {
      int clickX = mouseX - x - w/2 + 75;
      int control = clickX / 50;
      if (control == 0) {
        playing = true;
        reset = false;
      } else if (control == 1) {
        playing = false;
      } else if (control == 2) {
        playing = false;
        reset = true;
        setupGame();
      }
    } else if (clickY > h/3*2 - 12 && clickY < h/3*2 + 12) {
      if (playerMode == 1) {
        playerMode = 2; 
      } else {
        playerMode = 1;
      }
    }
  }
}