class Event {
  float x, y;
  int zone;
  int minute, second;
  int playerId, teamId;
  boolean isGoal;
  
  Event(JSONObject o) {
    x = pitchWidth * o.getFloat("x") / 100.0;
    y = pitchHeight * (100 - o.getFloat("y")) / 100.0;
    zone = o.getInt("zone");
    minute = o.getInt("minute");
    second = o.getInt("second");
    playerId = o.getInt("player_id");
    teamId = o.getInt("team_id");
    isGoal = o.getBoolean("is_goal");
  }
}