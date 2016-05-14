import java.util.Map;
import processing.video.*;

Movie myMovie;

int pixelSize = 10;
int step_width = 10;
int step_height = 10;

HashMap<Integer, String> characters = new HashMap<Integer, String>();



void setup() {
  //Each entry has an integer "weight", and a corresponding character.
  //The lower the number, the darker the value and therefore the bolder the character.
  characters.put(0, "@");
  characters.put(20, "X");
  characters.put(40, "#");
  characters.put(60, "N");
  characters.put(80, "$");
  characters.put(100, "8");
  characters.put(120, "&");
  characters.put(180, "£");
   
  PFont font;
  
  //Load the font.
  font = loadFont("ProggyCleanTT-48.vlw");
  textFont(font, 20);
  
  //Loop the video.
  myMovie = new Movie(this, "lain.mp4");
  myMovie.loop();
  size(400, 600);
  frameRate(30);
}


void draw() {
  background(0);
  
  for (int x = 0; x < myMovie.width; x += step_width) {
    for (int y = 0; y < myMovie.height; y += step_height) {
      //Get the average of this step.
      int average = getAverage(x, y);
      //Get the colour at this X and Y.
      fill(myMovie.get(x, y));
      //Set the ASCII character here to the nearest character.
      text(nearestChar(average), x, y);
    }
  }
  
  //saveFrame("frames/line-######.png");
}

void movieEvent(Movie m) {
  m.read();
}

/* 
Takes an x and a y value, and then iterates
through a section of the video defined by step_width and step_height.
It adds up all the colours within this section, and divides it
by (step_width * step_height) to find the average colour of the section (or step).
*/
public int getAverage(int x, int y) {
  int count = 0;
  color col;
  int realColor;
  
  for (int i = x - step_width; i < x; i++) {
    for (int n = y - step_height; n < y; n++) {
      col = myMovie.get(x, y);
      realColor = int((red(col) + green(col) + blue(col)) / 3);
      count += realColor;
    }
  }
  
  return int(count / (step_width * step_height));
      
}

/*
Takes an int "weight", which is how dark a particular step is.
It then iterates through the characters hashmap, and finds the character closest
To this weight.
*/
public String nearestChar(int weight) {
  int minDifference = Integer.MAX_VALUE;
  int nearest = -1;
    
  for (Map.Entry keys : characters.entrySet()) {
    int difference = abs(weight - (Integer) keys.getKey());
      
    if (difference < minDifference) {
      nearest = (Integer) keys.getKey();
      minDifference = difference;
    }
  }
    
  return characters.get(nearest);
}