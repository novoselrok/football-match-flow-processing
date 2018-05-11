JSONObject json;

int eventIdx = 0;
int wait = 50;
int time;

PlayerSidebar ps;
GameInfo gameInfo;
Event[] events;
JSONObject idToName;

Pitch pitch;
Controls controls;
PImage ball;
boolean playing = true;
boolean reset = false;

int numColumns = 5;
int numRows = 5;
int pitchX, pitchY, pitchWidth, pitchHeight;
int playerMode = 1;

void setup() {
  size(1024, 768);
  
  pitchX = width / numColumns;
  pitchY = height / numRows;
  pitchWidth = pitchX * 3;
  pitchHeight = pitchY * 3;
  ball = loadImage("ball.png");
  ball.resize(0, 20);

  json = loadJSONObject("events-cm.json");
  idToName = json.getJSONObject("id_to_name");
  JSONArray jsonEvents = json.getJSONArray("events");
  events = new Event[jsonEvents.size()];
  for (int i = 0; i < jsonEvents.size(); i++) {
    events[i] = new Event(jsonEvents.getJSONObject(i));
  }

  setupGame();

  time = millis();
}

void setupGame() {
  eventIdx = 0;
  ps = new PlayerSidebar(json.getJSONArray("home_player_ids"), json.getJSONArray("away_player_ids"));
  gameInfo = new GameInfo(json.getString("home_team_name"), json.getString("away_team_name"), json.getInt("home_team"), json.getInt("away_team"));
  pitch = new Pitch(pitchX, pitchY, pitchWidth, pitchHeight);
  pitch.setupZones();
  controls = new Controls(pitchX, pitchY*4, pitchX*3, pitchY);
}

void draw() {
  ps.updateIntegrators();

  if (eventIdx >= events.length || !playing) {
    fill(255);
    rect(0, 0, width, height);
    ps.drawPlayers();    
    pitch.drawPitch();    
    gameInfo.drawGameInfo();
    controls.drawControls();
    return;
  }

  if(millis() - time >= wait && playing) {
    // Clear the screen before rendering
    fill(255);
    rect(0, 0, width, height);
    // Add a new event
    ps.addEvent();
    pitch.addEvent();
    gameInfo.addEvent();
    
    ps.drawPlayers();

    pitch.drawPitch();
    pitch.drawEvent(events[eventIdx], color(255, 255, 255));
    
    gameInfo.drawGameInfo();
    
    controls.drawControls();
    
    eventIdx++;
    time = millis();
  }
}

float euclid(float x1, float y1, float x2, float y2) {
  return (float) Math.sqrt(Math.pow(x1 - x2, 2) + Math.pow(y1 - y2, 2)); 
}

void mouseMoved() {
  ps.mouseMoved();
}

void mouseClicked() {
  ps.mouseClicked();
  controls.mouseClicked();
}

void keyReleased() {
  if (key == 49) {
    playerMode = 1;
  } else if (key == 50) {
    playerMode = 2;
  }
}