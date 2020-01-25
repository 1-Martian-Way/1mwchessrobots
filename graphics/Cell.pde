// A Cell object

class Cell {

  // A cell object knows about its location in the grid as well as its size with the variables x, y, w, h.
  float x,y;   // x,y location
  float w,h;   // width and height
  
  color red_color = color(255, 0, 0);
  color green_color = color(0, 255, 0);
  color blue_color = color(0, 0, 255);
  color black_color = color(0,0,0);
  color white_color = color(200,200,200);
  color sq_color;
  
  // Cell Constructor
  Cell(float tempX, float tempY, float tempW, float tempH, int w_color) {
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;
    
    if (w_color == 1) sq_color = black_color;
    if (w_color == 2) sq_color = white_color;
    if (w_color == 3) sq_color = green_color;
    if (w_color == 4) sq_color = blue_color;
  }
  
  void display(int w_color) {
    if (w_color == 1) sq_color = black_color;
    if (w_color == 2) sq_color = white_color;
    if (w_color == 3) sq_color = green_color;
    if (w_color == 4) sq_color = blue_color;
    
    stroke(255);
    // Color calculated using sine wave
    fill(sq_color);
    rect(x,y,w,h);
  }
  
}
