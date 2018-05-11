class Pitch {
  int x, y, w, h;
  float maxDist;
  float[][] averages;
  Zone[] zoneObjs;
  Player hoveredPlayer;
  Player selectedPlayer;

  Pitch(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.maxDist = (float) Math.sqrt(Math.pow(w, 2) + Math.pow(h, 2));
   
    zoneObjs = new Zone[zones.length];
    averages = new float[w][h];
  }
  
  void setupZones() {
    for (int i = 0; i < zones.length; i++) {
      int[] zone = zones[i];  
      zoneObjs[i] = new Zone(zone[0], zone[1], zone[2], zone[3]);
    }
  }
  
  void addEvent() {
    Event event = events[eventIdx];
    for (int x = 0; x < w; x++) {
      for (int y = 0; y < h; y++) {
        float dist = euclid(x, y, event.x, event.y);
        if (eventIdx == 0) {
          // Initializing
          averages[x][y] = dist;
        } else {
          averages[x][y] = (eventIdx * averages[x][y] + dist) / (eventIdx + 1);
        }
      }
    }
    zoneObjs[event.zone].count++;
  }
  
  void drawPitch() {  
    drawHeatMap();
  
    if (hoveredPlayer != null) {
      // Draw hoveredPlayer events
      for (Event event : hoveredPlayer.events) {
        drawEvent(event, color(0, 0, 255));
      }
    }
    if (selectedPlayer != null) {
      for (Event event : selectedPlayer.events) {
        drawEvent(event, color(12, 144, 123));
      }
    }

    drawZones();
  }
  
  void drawEvent(Event e, color c) {
    pushStyle();
    pushMatrix();
    translate(x, y);
    if (e.isGoal) {
      fill(color(255, 255, 255));
      rect(e.x, e.y, 20.0, 20.0); 
      imageMode(CORNERS);
      image(ball, e.x, e.y);
    } else {
      fill(c);
      ellipse(e.x,e.y, 10.0, 10.0); 
    }
    popStyle();
    popMatrix();
  }

  void drawZones() {
    pushMatrix();
    translate(x, y);
    for (Zone zone : zoneObjs) {
      zone.drawZone();
    }
    popMatrix();
  }

  void drawHeatMap() {
    pushMatrix();
    translate(x, y);
    for (int x = 0; x < w; x++) {
      for (int y = 0; y < h; y++) { 
        if (reset) {
          set(this.x + x, this.y + y, color(0, 255, 0));
        } else {
          float percent = norm(averages[x][y], 0.0, maxDist);
          int c = lerpColor(#FF0000, #00FF00, percent, HSB);
          set(this.x + x, this.y + y, c);
        }
      }
    }
    popMatrix();
  }

  
int[][] zones = {
    {0, 0, 25, 20},
    {25, 0, 50, 20},
    {50, 0, 75, 20},
    {75, 0, 100, 20},

    {0, 80, 25, 100},
    {25, 80, 50, 100},
    {50, 80, 75, 100},
    {75, 80, 100, 100},

    {25, 20, 50, 80},
    {50, 20, 75, 80},

    {20, 20, 25, 80},
    {75, 20, 80, 80},

    {5, 35, 20, 65},
    {80, 35, 95, 65},

    {0, 35, 5, 65},
    {95, 35, 100, 65},

    {0, 20, 20, 35},
    {0, 65, 20, 80},
    {80, 20, 100, 35},
    {80, 65, 100, 80}
};

}