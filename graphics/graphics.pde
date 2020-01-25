import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

import processing.serial.*;

Minim origin;
Minim dest;
Minim register;
Minim human_data;

AudioPlayer origin_a;
AudioPlayer dest_a;
AudioPlayer register_a;
AudioPlayer human_data_a;


Serial myPort;  // Create object from Serial class
int def_val = '%';
int val = def_val;      // Data received from the serial port

// 2D Array of objects
Cell[][] grid;
Piece[][] sprite;

// Number of columns and rows in the grid
int cols = 9;
int rows = 9;
int color_select = 0;
int ctr = 0;
char ID_array[] = {'a','b','c','d','e','f','g','h',
                   'i','j','k','l','m','n','o','p'};
                   
int sp_H_arr[] = {48, 49, 50, 51, 52, 53, 54, 55,
                   56, 57, 58, 59, 60, 61, 62, 63};
                         
int sp_R_arr[] = {0, 1, 2, 3, 4, 5, 6, 7,
                    8, 9, 10, 11, 12, 13, 14, 15};

int H_index;
int R_index;

// Origin Flag
int flag_own = 1;

// Dest Flags //
int flag_empty = 1;
int flag_opp = 0;

char ID;
char p_selected;

int spr_x = 0;
int spr_y = 6;

int opp_x = 0;
int opp_y = 0;

int p_dest_x = 0;
int p_dest_y = 0;

int Origin = 49;
int Dest = 49;

int ori_c = 0;
int dest_c = 0;

int ctr_file = 8;

int s_enable = 0;
int blink_ctr = 0;

int b = 0;
int s_ctr = 1;

PFont fontA;

int large = 40;
int small = 20;

int x_cell = 0;
int y_cell = 7;
int s_cell = 100;

color red_color = color(255, 0, 0);
color green_color = color(0, 255, 0);
color blue_color = color(0, 0, 255);

char stage;
char a_timer_sym;
int timer = 0;
int t_check = 1;

void setup() {

  origin = new Minim(this);
  dest = new Minim(this);
  register = new Minim(this);
  human_data = new Minim(this);
  
  origin_a = origin.loadFile("origin.wav");
  dest_a = dest.loadFile("dest.wav");
  register_a = register.loadFile("register.wav");
  human_data_a = human_data.loadFile("human_data.wav");
  
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 19200);
  
  size(400,400);
  //frameRate(60);
  grid = new Cell[cols][rows];
  sprite = new Piece[cols][rows];
  
  fontA = loadFont("Ziggurat-HTF-Black-32.vlw");

  // Set the font and its size (in units of pixels)
  textFont(fontA, 12);
  // The counter variables i and j are also the column and row numbers
  // In this example, they are used as arguments to the constructor for each object in the grid.
  for (int i = 0; i < cols; i ++ ) {
    for (int j = 0; j < rows; j ++ ) {
      // Initialize each object
      if (i < 8 && j < 8)
      {
      if ((i % 2) == 0)
      {
      if ((j%2) == 0) color_select = 1;
      else color_select = 2;
      }
      else
      {
      if ((j%2) == 0) color_select = 2;
      else color_select = 1;
      }
      
      grid[i][j] = new Cell(i*large,j*large,large,large,color_select);
      
      /////////////// DUMMY SPRITES /////////////////////
      //if (j <= 5) 
      //sprite[i][j] = new Piece((i*large + small),(j*large + small),30,30,3,'D');
      
      /////////////// BLUE HUMAN SPRITES ///////////////
      
      if (j > 5) 
      {
      if (j == 6) 
      {
      if (i == 0) ID = 'a';
      if (i == 1) ID = 'b';
      if (i == 2) ID = 'c';
      if (i == 3) ID = 'd';
      if (i == 4) ID = 'e';
      if (i == 5) ID = 'f';
      if (i == 6) ID = 'g';
      if (i == 7) ID = 'h';
      }
      
      if (j == 7) 
      {
      if (i == 0) ID = 'i';
      if (i == 1) ID = 'j';
      if (i == 2) ID = 'k';
      if (i == 3) ID = 'l';
      if (i == 4) ID = 'm';
      if (i == 5) ID = 'n';
      if (i == 6) ID = 'o';
      if (i == 7) ID = 'p';
      }
      
      sprite[i][j] = new Piece((i*large + small),(j*large + small),30,30,3,ID);
      // Color 3 = Blue //
      }
      
      /////////////// GREEN ROBOT SPRITES //////////////
      
      if (j <= 5) 
      {
      if (j == 0) 
      {
      if (i == 0) ID = 'q';
      if (i == 1) ID = 'r';
      if (i == 2) ID = 's';
      if (i == 3) ID = 't';
      if (i == 4) ID = 'u';
      if (i == 5) ID = 'v';
      if (i == 6) ID = 'w';
      if (i == 7) ID = 'x';
      }
      
      if (j == 1) 
      {
      if (i == 0) ID = 'y';
      if (i == 1) ID = 'z';
      if (i == 2) ID = 'A';
      if (i == 3) ID = 'B';
      if (i == 4) ID = 'C';
      if (i == 5) ID = 'D';
      if (i == 6) ID = 'E';
      if (i == 7) ID = 'F';
      }
      
      sprite[i][j] = new Piece((i*large + small),(j*large + small),30,30,2,ID);
      // Color 2 = Green //
      }
      }
      
      else 
      {grid[i][j] = new Cell(i*large,j*large,large,large,3);
      }
    }
  }
  
  // Test Communication
  //Origin = 8;
  //Dest = 4;
  //set_stage('&');
  /*String one = "&2";
  String two = "90";
  myPort.write(one+two);*/
}

void draw() {
 
    if (t_check == 1 && s_enable == 5) timer_check();
 
    if (myPort.available() > 0) {  // If data is available,
    int val_1 = myPort.read();         // read it and store it in val
    if (val_1 != 10 && val_1 != 13)
    {
    val = val_1;
    //println(val);
    
    if (s_enable == 5)
    {
    if (val == '&')
    {
    if (a_timer_sym == '&') timer = 0;
    println("Stage O"); 
    if (ori_c == num_to_pos()) 
    {println("OK"); delay(100); set_stage('?');}
    else call_RETRY();
    } 
    
    if (val == '?')
    {
    if (a_timer_sym == '?') timer = 0;
    println("Stage D");
    if (dest_c == num_to_pos()) {println("OK"); t_check = 0; s_enable = 0;}
    else call_RETRY();
    }
    
    if (val == '|')
    {
    if (a_timer_sym == '|') timer = 0;
    println("OK"); 
    t_check = 0; s_enable = 0;
    }
    
    }}}
  
  background(255);
  for (int i = 0; i < cols; i ++ ) {
  textFont(fontA, 12);
      
    for (int j = 0; j < rows; j ++ ) {
      grid[i][j].display(0);
      if (j > 7)
      {
      textFont(fontA, 14);
      fill(0);
      text(ID_array[i], i*large + small, j*large + small);
      }
      
      /*if (i > 7)
      {
      textFont(fontA, 14);
      fill(0);
      text(ctr_file--, i*large + small, j*large + small);
     
      }*/
    }
  }
   
  //////////////// Origin and Destination ///////////////
      
      textFont(fontA, 14);
      
      if (s_enable == 0)
      {
      if (s_ctr == 1) {val = def_val; s_ctr = 0;  origin_a.play();}
      fill(red_color);
      text("ORIGIN ?", 280, 385);
      }
      
      if (s_enable == 1)
      {
      fill(red_color);
      text("ORIGIN = ", 270, 385);
      text(Origin, 360, 385);
      
      if ( myPort.available() == 0) s_enable = 2;
      }
  
  ////////////// Pressure Bar /////////////////////
  
  fill(255);
  rect(0,385,200,50);
   
  stroke(0);
  fill(red_color);
  
  rect(0,385,b,50);
  
  if (s_enable == 0) 
  {
  human_detect(val);
  if (b > 200) {
  s_enable = 1; 
  b = 0; 
  Origin = s_cell; 
  s_cell = 100;
  }
  }
  
  if (s_enable == 2) 
  {
   if (s_ctr == 0) {val = def_val; s_ctr = 1; dest_a.play();}
   fill(red_color);
   text("DEST ?", 290, 385);
   
  human_detect(val);
  
  if (b > 200) 
  {
   s_enable = 3; 
   b = 0; 
   Dest = s_cell; 

   sp_dest_write(s_cell); // Write and Update Arrays
   move_sprite(Dest);
   print("Origin: ");
   println(Origin);
   
   print("Dest: ");
   println(Dest);
   
   s_cell = 100;
  }
  }
  
  if (s_enable == 3) 
  {
  text(Origin, 290, 390);
      
  if ( myPort.available() == 0) s_enable = 4; // s_enable = 0; 
  }
  
  if (s_enable == 4) 
  {set_stage('&'); 
  s_enable = 5;
  //fill(red_color);
  //text("Communicating ...", 280, 385);    
  }

  sprite_locator();
  display_sprite();
}

///////////////////// Display Sprite ///////////////////////////

void display_sprite()
{
    for (int i = 0; i < cols; i ++ ) {     
    for (int j = 0; j < rows; j ++ ) {
  
    if (i < 8 && j < 8)
    {
    textFont(fontA, 12);
    
    if (s_enable == 1) sprite[spr_x][spr_y].p_color=red_color; // RED
    
    if (j<2 || j>5) sprite[i][j].display(0);
    
    //if (s_enable == 3) sprite[x_cell][y_cell].display(3); // BLUE
    }
    }
    }
}

/////////////////////// Move Sprite ///////////////////////////

void move_sprite(int dest)
{
p_dest_x = dest % 8;
p_dest_y = dest / 8;

sprite_loc_map(p_dest_x, p_dest_y);
}

void sprite_locator()
{
////////// Human Sprite Locator ///////////
if (p_selected == 'a') {spr_x = 0; spr_y = 6;}
if (p_selected == 'b') {spr_x = 1; spr_y = 6;}
if (p_selected == 'c') {spr_x = 2; spr_y = 6;}
if (p_selected == 'd') {spr_x = 3; spr_y = 6;}
if (p_selected == 'e') {spr_x = 4; spr_y = 6;}
if (p_selected == 'f') {spr_x = 5; spr_y = 6;}
if (p_selected == 'g') {spr_x = 6; spr_y = 6;}
if (p_selected == 'h') {spr_x = 7; spr_y = 6;}

if (p_selected == 'i') {spr_x = 0; spr_y = 7;}
if (p_selected == 'j') {spr_x = 1; spr_y = 7;}
if (p_selected == 'k') {spr_x = 2; spr_y = 7;}
if (p_selected == 'l') {spr_x = 3; spr_y = 7;}
if (p_selected == 'm') {spr_x = 4; spr_y = 7;}
if (p_selected == 'n') {spr_x = 5; spr_y = 7;}
if (p_selected == 'o') {spr_x = 6; spr_y = 7;}
if (p_selected == 'p') {spr_x = 7; spr_y = 7;}
}

/////////////////////// Move Human Sprite 2 ///////////////////////////

void sprite_loc_map(int dest_x, int dest_y)
{
sprite[spr_x][spr_y].x = sprite_grid_map_x(dest_x, dest_y);
sprite[spr_x][spr_y].y = sprite_grid_map_y(dest_x, dest_y);

// Restore Color //
sprite[spr_x][spr_y].p_color = blue_color;
}

/////////////////////// Sprite->Grid Map ///////////////////////

float sprite_grid_map_x(int loc_x, int loc_y)
{
return grid[loc_x][loc_y].x + 25;
}

float sprite_grid_map_y(int loc_x, int loc_y)
{
return grid[loc_x][loc_y].y + 25;
}

public void stop() {
  //Sonia.stop();
  super.stop();
}

////////////////////// Human Detect ////////////////////////

void human_detect(int v)
{
  ///////////// ROW 0 ///////////////////
  
  if (v == 'a') {s_cell = 0;}
  if (v == 'b') {s_cell = 1;}
  if (v == 'c') {s_cell = 2;}
  if (v == 'd') {s_cell = 3;}
  if (v == 'e') {s_cell = 4;}
  if (v == 'f') {s_cell = 5;}
  if (v == 'g') {s_cell = 6;}
  if (v == 'h') {s_cell = 7;}
  
  ///////////// ROW 1 ///////////////////
  
  if (v == 'i') {s_cell = 8;}
  if (v == 'j') {s_cell = 9;}
  if (v == 'k') {s_cell = 10;}
  if (v == 'l') {s_cell = 11;}
  if (v == 'm') {s_cell = 12;}
  if (v == 'n') {s_cell = 13;}
  if (v == 'o') {s_cell = 14;}
  if (v == 'p') {s_cell = 15;}
  
  ///////////// ROW 2 ///////////////////
  
  if (v == 'q') {s_cell = 16;}
  if (v == 'r') {s_cell = 17;}
  if (v == 's') {s_cell = 18;}
  if (v == 't') {s_cell = 19;}
  if (v == 'u') {s_cell = 20;}
  if (v == 'v') {s_cell = 21;}
  if (v == 'w') {s_cell = 22;}
  if (v == 'x') {s_cell = 23;}
  
  ///////////// ROW 3 ///////////////////
  
  if (v == 'y') {s_cell = 24;}
  if (v == 'z') {s_cell = 25;}
  if (v == 'A') {s_cell = 26;}
  if (v == 'B') {s_cell = 27;}
  if (v == 'C') {s_cell = 28;}
  if (v == 'D') {s_cell = 29;}
  if (v == 'E') {s_cell = 30;}
  if (v == 'F') {s_cell = 31;}
  
  ///////////// ROW 4 ///////////////////
  
  if (v == 'G') {s_cell = 32;}
  if (v == 'H') {s_cell = 33;}
  if (v == 'I') {s_cell = 34;}
  if (v == 'J') {s_cell = 35;}
  if (v == 'K') {s_cell = 36;}
  if (v == 'L') {s_cell = 37;}
  if (v == 'M') {s_cell = 38;}
  if (v == 'N') {s_cell = 39;}
  
  ///////////// ROW 5 ///////////////////
  
  if (v == 'O') {s_cell = 40;}
  if (v == 'P') {s_cell = 41;}
  if (v == 'Q') {s_cell = 42;}
  if (v == 'R') {s_cell = 43;}
  if (v == 'S') {s_cell = 44;}
  if (v == 'T') {s_cell = 45;}
  if (v == 'U') {s_cell = 46;}
  if (v == 'V') {s_cell = 47;}
  
  ///////////// ROW 6 ///////////////////
  
  if (v == 'W') {s_cell = 48;}
  if (v == 'X') {s_cell = 49;}
  if (v == 'Y') {s_cell = 50;}
  if (v == 'Z') {s_cell = 51;}
  if (v == '1') {s_cell = 52;}
  if (v == '2') {s_cell = 53;}
  if (v == '3') {s_cell = 54;}
  if (v == '4') {s_cell = 55;}
  
  ///////////// ROW 7 ///////////////////
  
  if (v == '8') {s_cell = 56;}
  if (v == '7') {s_cell = 57;}
  if (v == '6') {s_cell = 58;}
  if (v == '5') {s_cell = 59;}
  if (v == '9') {s_cell = 60;}
  if (v == '@') {s_cell = 61;}
  if (v == '#') {s_cell = 62;}
  if (v == '$') {s_cell = 63;}
  
  //print("S_cell: ");
  //println(s_cell);
  
  if (s_cell != 100)
  {
  if (s_enable == 0 && sp_sel_check(s_cell) == 1) 
  {
  sprite_selector();
  b = b + 5;
  }
  
  else if (s_enable == 2 && sp_dest_check(s_cell) == 1) 
  {
  sprite_selector();
  b = b + 5;
  }
  else b = 0;
  }
}

void sprite_selector()
{
  if (s_cell == 48) p_selected = 'a';
  if (s_cell == 49) p_selected = 'b';
  if (s_cell == 50) p_selected = 'c';
  if (s_cell == 51) p_selected = 'd';
  if (s_cell == 52) p_selected = 'e';
  if (s_cell == 53) p_selected = 'f';
  if (s_cell == 54) p_selected = 'g';
  if (s_cell == 55) p_selected = 'h';
  if (s_cell == 56) p_selected = 'i';
  if (s_cell == 57) p_selected = 'j';
  if (s_cell == 58) p_selected = 'k';
  if (s_cell == 59) p_selected = 'l';
  if (s_cell == 60) p_selected = 'm';
  if (s_cell == 61) p_selected = 'n';
  if (s_cell == 62) p_selected = 'o';
  if (s_cell == 63) p_selected = 'p';
}
//////////// DOES A SPRITE EXIST AT PRESSURE POS? ////////////

int sp_sel_check(int sc)
{
  for (int i=0; i<=15; i++)
  if (sc == sp_H_arr[i]) {H_index = i; flag_own = 1;}
  
  if (flag_own == 1) {flag_own = 0; return 1;}
  
  return 0;
}

//////////// IS THE DEST EMPTY OR HAS OPPONENT? ////////////

int sp_dest_check(int sc)
{
  for (int i=0; i<=15; i++)
  {
  // If Dest contains own piece //
  if (sc == sp_H_arr[i]) flag_empty = 0; 
  
  // If Dest contains opponent piece //
  if (sc == sp_R_arr[i]) {R_index = i; flag_opp = 1;}
  }
  
  if ((flag_empty == 1) || (flag_opp == 1)) return 1;
  
  flag_empty = 1;
  return 0;
}

//////////// DEST WRITE AND UPDATE ARRAYS ////////////////

void sp_dest_write(int sc)
{
// Move Legality and Update Arrays //
   // If Empty then update Human array with new pos //
  if (flag_empty == 1 && flag_opp == 0) sp_H_arr[H_index] = sc;
  
  // If Occupied by Opponent throw it out of bounds //
  else if (flag_opp == 1) 
  {sp_H_arr[H_index] = sc; kill_opp();} // Throw Out of Bounds
  
  flag_empty = 1;
  flag_opp = 0;
  
  print_arr();
}

///////////// Kill Opponent /////////////

void kill_opp()
{
  println("Opponent Killed");
  
  sp_R_arr[R_index] = 100;
  
  ////////// Robot Sprite Locator ///////////
  if (R_index == 0) opp_x = 0; opp_y = 0;
  if (R_index == 1) opp_x = 1; opp_y = 0;
  if (R_index == 2) opp_x = 2; opp_y = 0;
  if (R_index == 3) opp_x = 3; opp_y = 0;
  if (R_index == 4) opp_x = 4; opp_y = 0;
  if (R_index == 5) opp_x = 5; opp_y = 0;
  if (R_index == 6) opp_x = 6; opp_y = 0;
  if (R_index == 7) opp_x = 7; opp_y = 0;

  if (R_index == 8) opp_x = 0; opp_y = 1;
  if (R_index == 9) opp_x = 1; opp_y = 1;
  if (R_index == 10) opp_x = 2; opp_y = 1;
  if (R_index == 11) opp_x = 3; opp_y = 1;
  if (R_index == 12) opp_x = 4; opp_y = 1;
  if (R_index == 13) opp_x = 5; opp_y = 1;
  if (R_index == 14) opp_x = 6; opp_y = 1;
  if (R_index == 15) opp_x = 7; opp_y = 1;
  
  move_robot_sprite(65);
  }


void move_robot_sprite(int dest)
{
int o_dest_x = dest % 8;
int o_dest_y = dest / 8;

sprite_r_loc_map(o_dest_x, o_dest_y);
}

void sprite_r_loc_map(int dest_x, int dest_y)
{
sprite[opp_x][opp_y].x = sprite_grid_map_x(dest_x, dest_y);
sprite[opp_x][opp_y].y = sprite_grid_map_y(dest_x, dest_y);
}

///////////// Print Array /////////////

void print_arr()
{
println("Human Array: ");
for (int i=0; i<15; i++)
{
 print(sp_H_arr[i]);
 print(" ");
}

println();
println("Robot Array: ");
for (int i=0; i<15; i++)
{
 print(sp_R_arr[i]);
 print(" ");
}

println();
}

/////////////// Send Origin and Dest to King ///////////////
void send_ori()
{
 String s_len = "";
 ori_c = OD_conv(Origin);
 myPort.write('&');
 int len = get_len(ori_c);
 s_len = len_to_str(len);
 myPort.write(s_len + ori_c);
}

void send_dest()
{
 String s_len = "";
 dest_c = OD_conv(Dest);
 myPort.write('?');
 int len = get_len(dest_c); 
 s_len = len_to_str(len);
 myPort.write(s_len + dest_c);
}

void send_st()
{
 myPort.write('|');
}

String len_to_str(int len)
{
 String s_len = "";
 if (len == 1) s_len = "1";
 if (len == 2) s_len = "2";
 if (len == 3) s_len = "3";
 
 return s_len;
}

////////////////// CALL_RETRY ////////////////////////

void call_RETRY() {
 println("Retry"); 
 timer = 0;
 delay(1000);
 
 if (stage == '&') send_ori();
 if (stage == '?') send_dest();
 if (stage == '|') send_st();
}
////////////////// SET_STAGE ////////////////////////

void set_stage(char stg)
{
/* HUMAN MOVE STAGE */
  if (stg == '&') {stage = '&'; attach_timer('&'); send_ori();}
  if (stg == '?') {stage = '?'; attach_timer('?'); send_dest();}
  if (stg == '|') {stage = '|'; attach_timer('|'); send_st();}
} 

////////////////// TIMER_FUNCS ////////////////////////

///////// ATTACH A_TIMER ///////////

void attach_timer(char scan_sym)
{
  if (scan_sym == '&') a_timer_sym = '&'; // Origin Move
  if (scan_sym == '?') a_timer_sym = '?'; // Dest Move
}

///////////////// Timer Code ///////////////////

void timer_check()
{
  timer++;
  if (timer > 100)
  call_RETRY();
}

///////////////// Serial Value -> Pos ////////////////////////

 int num_to_pos()
 {
    int p_len = myPort.read();
    int p_pos =0;
    int digit1=0;
    int digit2=0;
    int digit3=0;
     
    if (p_len == 1 || p_len == 2 || p_len == 3)
    {
    digit1 = myPort.read();
    p_pos = digit1;
    }
    
    if (p_len == 2 || p_len == 3)
    {
    digit2 = myPort.read();
    p_pos = digit1 * 10 + digit2;
    }
    
    if (p_len == 3)
    {
    digit3 = myPort.read();
    p_pos = digit1 * 100 + digit2 * 10 + digit3;
    }
    
    println(p_pos);
    return p_pos;
  }

 ///////////////// Pos -> Serial ////////////////////////

 int get_len(int pc_val) 
 {
 int pc_len = 0;
  
 if (pc_val < 10) pc_len = 1;
 if (pc_val >= 10 && pc_val < 100) pc_len = 2;
 if (pc_val >= 100) pc_len = 3;
 
 return pc_len;
 }

//////////////// OD Converter //////////////////////

int OD_conv(int od)
{
  if (od == 0) {return 0;} 
  if (od == 1) {return 1;} 
  if (od == 2) {return 2;} 
  if (od == 3) {return 3;} 
  if (od == 4) {return 4;} 
  if (od == 5) {return 5;} 
  if (od == 6) {return 6;} 
  if (od == 7) {return 7;} 
  
  ///////////// ROW 1 ///////////////////
  
  if (od == 8) {return 16;} 
  if (od == 9) {return 17;} 
  if (od == 10) {return 18;} 
  if (od == 11) {return 19;} 
  if (od == 12) {return 20;} 
  if (od == 13) {return 21;} 
  if (od == 14) {return 22;} 
  if (od == 15) {return 23;} 
  
  ///////////// ROW 2 ///////////////////
  
  if (od == 16) {return 32;} 
  if (od == 17) {return 33;} 
  if (od == 18) {return 34;} 
  if (od == 19) {return 35;} 
  if (od == 20) {return 36;} 
  if (od == 21) {return 37;} 
  if (od == 22) {return 38;} 
  if (od == 23) {return 39;} 
  
  ///////////// ROW 3 ///////////////////
  
  if (od == 24) {return 48;} 
  if (od == 25) {return 49;} 
  if (od == 26) {return 50;} 
  if (od == 27) {return 51;} 
  if (od == 28) {return 52;} 
  if (od == 29) {return 53;} 
  if (od == 30) {return 54;} 
  if (od == 31) {return 55;} 
  
  ///////////// ROW 4 ///////////////////
  
  if (od == 32) {return 64;} 
  if (od == 33) {return 65;} 
  if (od == 34) {return 66;} 
  if (od == 35) {return 67;} 
  if (od == 36) {return 68;} 
  if (od == 37) {return 69;} 
  if (od == 38) {return 70;} 
  if (od == 39) {return 71;} 
  
  ///////////// ROW 5 ///////////////////
  
  if (od == 40) {return 80;} 
  if (od == 41) {return 81;} 
  if (od == 42) {return 82;} 
  if (od == 43) {return 83;} 
  if (od == 44) {return 84;} 
  if (od == 45) {return 85;} 
  if (od == 46) {return 86;} 
  if (od == 47) {return 87;} 
  
  ///////////// ROW 6 ///////////////////
  
  if (od == 48) {return 96;} 
  if (od == 49) {return 97;} 
  if (od == 50) {return 98;} 
  if (od == 51) {return 99;} 
  if (od == 52) {return 100;} 
  if (od == 53) {return 101;} 
  if (od == 54) {return 102;} 
  if (od == 55) {return 103;} 
  
  ///////////// ROW 7 ///////////////////
  
  if (od == 56) {return 112;} 
  if (od == 57) {return 113;} 
  if (od == 58) {return 114;} 
  if (od == 59) {return 115;} 
  if (od == 60) {return 116;} 
  if (od == 61) {return 117;} 
  if (od == 62) {return 118;} 
  if (od == 63) {return 119;} 
  
  return 0;
}
