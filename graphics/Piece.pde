// A Piece object

class Piece {

  // A cell object knows about its location in the grid as well as its size with the variables x, y, w, h.
  float x,y;   // x,y location
  float w,h;   // width and height
  int x_off = 7;
  int y_off = 5;
  char ID;
  color red_color = color(255, 0, 0);
  color green_color = color(0, 255, 0);
  color blue_color = color(0, 0, 255);
  color p_color;
  
  // Piece Constructor
  Piece(int tempX, int tempY, int tempW, int tempH, int w_color, char tempID) {
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;
    ID = tempID;
   
    if (w_color == 1) p_color = red_color;
    if (w_color == 2) p_color = green_color;
    if (w_color == 3) p_color = blue_color;
  }
  
  void display(int w_color) {
    if (w_color == 1) p_color = red_color;
    if (w_color == 2) p_color = green_color;
    if (w_color == 3) p_color = blue_color;
   
    stroke(255);
  
    fill(p_color);
    ellipse(x,y,w,h);
    fill(0);
    
    /////////////// BLUE HUMAN SPRITES ///////////////
    
    if (ID == 'a') text("P1", x-x_off, y+y_off);
    if (ID == 'b') text("P2", x-x_off, y+y_off);
    if (ID == 'c') text("P3", x-x_off, y+y_off);
    if (ID == 'd') text("P4", x-x_off, y+y_off);
    if (ID == 'e') text("P5", x-x_off, y+y_off);
    if (ID == 'f') text("P6", x-x_off, y+y_off);
    if (ID == 'g') text("P7", x-x_off, y+y_off);
    if (ID == 'h') text("P8", x-x_off, y+y_off);
    if (ID == 'i') text("R1", x-x_off, y+y_off);
    if (ID == 'j') text("N1", x-x_off, y+y_off);
    if (ID == 'k') text("B1", x-x_off, y+y_off);
    if (ID == 'l') text("Q", x-x_off, y+y_off);
    if (ID == 'm') text("K", x-x_off, y+y_off);
    if (ID == 'n') text("B2", x-x_off, y+y_off);
    if (ID == 'o') text("N2", x-x_off, y+y_off);
    if (ID == 'p') text("R2", x-x_off, y+y_off);
    
    /////////////// GREEN ROBOT SPRITES //////////////
      
    if (ID == 'q') text("r2", x-x_off, y+y_off);
    if (ID == 'r') text("n2", x-x_off, y+y_off);
    if (ID == 's') text("b2", x-x_off, y+y_off);
    if (ID == 't') text("k", x-x_off, y+y_off);
    if (ID == 'u') text("q", x-x_off, y+y_off);
    if (ID == 'v') text("b1", x-x_off, y+y_off);
    if (ID == 'w') text("n1", x-x_off, y+y_off);
    if (ID == 'x') text("r1", x-x_off, y+y_off);
    if (ID == 'y') text("p8", x-x_off, y+y_off);
    if (ID == 'z') text("p7", x-x_off, y+y_off);
    if (ID == 'A') text("p6", x-x_off, y+y_off);
    if (ID == 'B') text("p5", x-x_off, y+y_off);
    if (ID == 'C') text("p4", x-x_off, y+y_off);
    if (ID == 'D') text("p3", x-x_off, y+y_off);
    if (ID == 'E') text("p2", x-x_off, y+y_off);
    if (ID == 'F') text("p1", x-x_off, y+y_off);
    
    ///////////// DUMMY PIECE ///////////////
    if (ID == 'D') text("D", x-x_off, y+y_off);
  }
  
}
