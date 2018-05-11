class Player {
  ArrayList<Event> events;
  int playerId;
  int teamId;
  String name;
  
  Player(int playerId, String name) {
    this.playerId = playerId;
    this.name = name;
    this.events = new ArrayList<Event>();
  }
  
  @Override
  public boolean equals(Object obj) {
    if (obj == null) return false;
    
    Player p = (Player) obj;
    return p.playerId == playerId;
  }
}