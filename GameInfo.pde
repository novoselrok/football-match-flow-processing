class GameInfo {
  String homeTeamName;
  String awayTeamName;
  
  int homeTeamId;
  int awayTeamId;
  
  int homeTeamScore = 0;
  int awayTeamScore = 0;
  
  int minute = 0;
  int second = 0;
  
  PImage homeTeamImage;
  PImage awayTeamImage;
  
  GameInfo(String homeTeamName, String awayTeamName, int homeTeamId, int awayTeamId) {
    this.homeTeamName = homeTeamName;
    this.awayTeamName = awayTeamName;
    this.homeTeamId = homeTeamId;
    this.awayTeamId = awayTeamId;
    
    // Load images
    homeTeamImage = loadImage("images/" + homeTeamId + ".png");
    awayTeamImage = loadImage("images/" + awayTeamId + ".png");
    homeTeamImage.resize(0, 75);
    awayTeamImage.resize(0, 75);
  }
  
  void addEvent() {
    Event e = events[eventIdx];
    if (e.isGoal) {
      if (e.teamId == homeTeamId) {
        homeTeamScore++; 
      } else {
        awayTeamScore++; 
      }
    }
    
    minute = e.minute;
    second = e.second;    
  }
  
  void drawGameInfo() {
    pushMatrix();
    
    translate(pitch.x, 0);
    
    int infoWidth = (width / numColumns) * (numColumns - 2);
    
    int namesY = height / numRows / 4;
    int scoreY = namesY * 3;
    int timeY = (int) (namesY * 2);
    
    textSize(16);
    textAlign(CENTER);
    fill(0, 102, 153);
    
    imageMode(CENTER);
    image(homeTeamImage, infoWidth/4, namesY * 1.5);
    image(awayTeamImage, infoWidth/4 * 3, namesY * 1.5);

    text(homeTeamScore, infoWidth / 4, scoreY);
    text(awayTeamScore, infoWidth / 4 * 3, scoreY); 
    
    fill(0, 0, 0);
    text(minute < 10 ? "0" + minute: "" + minute, infoWidth / 2 - 20, timeY);
    text(":", infoWidth / 2, timeY); 
    text(second < 10 ? "0" + second: "" + second, infoWidth / 2 + 20, timeY); 
   
    popMatrix();
    
    int legend = pitch.y - 15;
    pushStyle();
    textSize(10);
    textAlign(LEFT);
    text("Low action area", pitch.x, legend - 5);
    textAlign(RIGHT);
    text("High action area", pitch.x + pitch.w, legend - 5);
    popStyle();
    for (int i = 0; i < pitch.w; i++) {
      float percent = norm(map(i, 0, pitch.w, 0, pitch.maxDist), 0.0, pitch.maxDist);
      int c = lerpColor(#00FF00, #FF0000, percent, HSB);
      set(pitch.x + i, legend, c);
      set(pitch.x + i, legend + 1, c);
      set(pitch.x + i, legend + 2, c);
      set(pitch.x + i, legend + 3, c);
      set(pitch.x + i, legend + 4, c);
    }
  }
}