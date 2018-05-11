import java.util.*;

class PlayerSidebar {
  
  final HashMap<Integer, Player> idToPlayer;
  HashMap<Integer, Integrator> idToIntegrator;
  
  Integer[] homePlayers;
  Integer[] awayPlayers;
  int playerHeight;
  int playerWidth;
  Player selectedPlayer;
  
  final int FONT_SIZE = 12;
  final color FONT_COLOR = color(0, 0, 0);
  final int MAX_EVENTS = 130;
  final int PADDING = 10;
  
  PlayerSidebar(JSONArray homePlayers, JSONArray awayPlayers) {
    this.homePlayers = new Integer[homePlayers.size()];
    this.awayPlayers = new Integer[awayPlayers.size()];
    this.idToPlayer = new HashMap<Integer, Player>();
    this.idToIntegrator = new HashMap<Integer, Integrator>();
    
    for (int i = 0; i < homePlayers.size(); i++) {
      this.homePlayers[i] = homePlayers.getInt(i);
      this.awayPlayers[i] = awayPlayers.getInt(i);
      
      idToPlayer.put(this.homePlayers[i], new Player(this.homePlayers[i], idToName.getString(String.valueOf(this.homePlayers[i]))));
      idToPlayer.put(this.awayPlayers[i], new Player(this.awayPlayers[i], idToName.getString(String.valueOf(this.awayPlayers[i]))));
      
      
      idToIntegrator.put(this.homePlayers[i], new Integrator(i));
      idToIntegrator.get(this.homePlayers[i]).target(i);
      idToIntegrator.put(this.awayPlayers[i], new Integrator(i));
      idToIntegrator.get(this.awayPlayers[i]).target(i);
    }

    playerHeight = (int) (height / ((float) this.homePlayers.length));
    playerWidth = width / numColumns;
  }
  
  void drawPlayers() {
    for (int i = 0; i < homePlayers.length; i++) {
      pushStyle();
      pushMatrix();

      Integrator integrator = idToIntegrator.get(homePlayers[i]);
      translate(PADDING, playerHeight * integrator.value);
      Player p = idToPlayer.get(homePlayers[i]);
      
      if (p.equals(selectedPlayer)) {
        fill(color(255, 255, 255));
        rect(0, 0, playerWidth - 2 * PADDING, playerHeight);
      }
      
      textSize(12);
      textAlign(LEFT);
      fill(0, 102, 153);
      text(p.name, PADDING, playerHeight / 3);
      float histSize = map((float) p.events.size(), 0.0, (float) MAX_EVENTS, 0.0, (float) playerWidth - 2 * PADDING);
      rect(PADDING, playerHeight * 0.5, histSize, 15);
       
      if (playerMode == 2) {
        textSize(15);
        text("" + p.events.size(), PADDING + histSize + 5, playerHeight * 0.5 + 13);
      }
      
      popMatrix();
      popStyle();
    }
    
    for (int i = 0; i < awayPlayers.length; i++) {
      pushStyle();
      pushMatrix();
      // Move to appropriate place
      Integrator integrator = idToIntegrator.get(awayPlayers[i]);
      translate(playerWidth * (numColumns - 1) + PADDING, playerHeight * integrator.value);
      Player p = idToPlayer.get(awayPlayers[i]);
      
      if (p.equals(selectedPlayer)) {
        fill(color(255, 255, 255));
        rect(0, 0, playerWidth - 2 * PADDING, playerHeight);
      }
      
      textSize(12);
      textAlign(RIGHT);
      fill(0, 102, 153);
      text(p.name, playerWidth - 2 * PADDING, playerHeight / 3);
      
      float histSize = map((float) p.events.size(), 0.0, (float) MAX_EVENTS, 0.0, (float) playerWidth - 2 * PADDING);
      rect(playerWidth - 2 * PADDING - histSize, playerHeight * 0.5, histSize, 15);
       
      if (playerMode == 2) {
        textSize(15);
        text("" + p.events.size(), playerWidth - 2 * PADDING - histSize - 5, playerHeight * 0.5 + 13);
      } 
       
      popMatrix();
      popStyle();
    }
  }
  
  void addEvent() {
    Event e = events[eventIdx];
    Player p = idToPlayer.get(e.playerId);
    p.events.add(e);
    
    sortPlayers();
    targetIntegrators();
  }
  
  private void targetIntegrators() {
     for (int i = 0; i < homePlayers.length; i++) {
       int homePlayer = homePlayers[i];
       int awayPlayer = awayPlayers[i];
       
       idToIntegrator.get(homePlayer).target(i);
       idToIntegrator.get(awayPlayer).target(i);
     }
  }
  
  public void updateIntegrators() {
     for (int i = 0; i < homePlayers.length; i++) {
       int homePlayer = homePlayers[i];
       int awayPlayer = awayPlayers[i];
       
       idToIntegrator.get(homePlayer).update();
       idToIntegrator.get(awayPlayer).update();
     }
  }
  
  private void sortPlayers() {
    Arrays.sort(homePlayers, new Comparator<Integer> () {
      @Override
      public int compare(Integer p1, Integer p2) {
        return Integer.compare(idToPlayer.get(p2).events.size(), idToPlayer.get(p1).events.size());
      }
    });
    
    Arrays.sort(awayPlayers, new Comparator<Integer> () {
      @Override
      public int compare(Integer p1, Integer p2) {
        return Integer.compare(idToPlayer.get(p2).events.size(), idToPlayer.get(p1).events.size());
      }
    });
  }
  
  Player getPlayerOnMouseAction() {
     // If hovering over a player, draw his events on the pitch
    Integer[] players;
    
    if (mouseX <= playerWidth) {
      players = homePlayers;
    } else if (mouseX >= 4 * playerWidth) {
      players = awayPlayers;
    } else {
      return null;
    }
           
    int playerIdx = (int) (mouseY / playerHeight);
    if (playerIdx >= players.length) {
      return null;
    }
    return idToPlayer.get(players[playerIdx]);
  }
  
  void mouseMoved() {
    pitch.hoveredPlayer = getPlayerOnMouseAction();
  }
  
  void mouseClicked() {
    Player p = getPlayerOnMouseAction();
    
    if (p != null) {
      if (p.equals(pitch.selectedPlayer)) {
        pitch.selectedPlayer = null;
        selectedPlayer = null;
      } else {
        pitch.selectedPlayer = p;
        selectedPlayer = p; 
      }
    }
  }
}