/* 1MW Chess Robots - Graphics Source Code */
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

import processing.serial.*;

char SERIAL_EN = 1;

Minim origin;
Minim dest;
Minim register;
Minim human_data;
Minim terminator;

AudioPlayer origin_a;
AudioPlayer dest_a;
//AudioPlayer register_a;
AudioPlayer human_data_a;
AudioPlayer terminator_a;

Serial myPort;  // Create object from Serial class
int def_val = '%';
int val = def_val;      // Data received from the serial port

char ID_array[] = {'a','b','c','d','e','f','g','h',
                   'i','j','k','l','m','n','o','p'};
                   
int sp_H_arr[] = {48, 49, 50, 51, 52, 53, 54, 55,
                   56, 57, 58, 59, 60, 61, 62, 63};
                         
int sp_R_arr[] = {0, 1, 2, 3, 4, 5, 6, 7,
                    8, 9, 10, 11, 12, 13, 14, 15};

int H_index;
int R_index;

int Origin = 49;
int Dest = 49;

int ori_c = 0;
int dest_c = 0;

int s_enable = 0;
int blink_ctr = 0;

int b = 0;
int bar_size = 800;
int bar_incr = 200;
int s_ctr = 1;

String s_cell = "z0";

int base_x = 150;
int board_x = 1450;
int board_y = 1000;
int prnt_val = 0;

color red_color = color(255, 0, 0);
color green_color = color(0, 255, 0);
color blue_color = color(0, 0, 255);

char stage;
char a_timer_sym;
int timer = 0;
int t_check = 1;

PFont fontA;
boolean selected = false;
String keyPress = "";
String gridSelected = "";
ChessPiece selectedPiece;
boolean pieceSelected = false;
int indexOfPieceToDie;
int displayMode = 0;

PImage bg;

ChessPiece[] chessPiecesAlive = new ChessPiece[32];


void setup()
{
  smooth(); // Setting anti-aliasing for smooth graphics

  size(board_x, board_y);
  fontA = loadFont("Cambria-48.vlw"); // Importing font style
  textFont(fontA, 32); // Setting font style and size
  
  origin = new Minim(this);
  dest = new Minim(this);
  register = new Minim(this);
  human_data = new Minim(this);
  terminator = new Minim(this);
  
  origin_a = origin.loadFile("origin.wav");
  dest_a = dest.loadFile("dest.wav");
  //register_a = register.loadFile("register.wav");
  human_data_a = human_data.loadFile("human_data.wav");
  terminator_a = terminator.loadFile("terminator.mp3");
  
  if (SERIAL_EN == 1)
  {
  String portName = Serial.list()[13];
  print(portName);
  myPort = new Serial(this, portName, 19200);
  }
  
  setupChessPieces();
  bg = loadImage("bg2.jpg");
  background(bg);
  drawAxes();
  drawGrid();
}

// Method used to setup all Chess pieces' details
// and add them to array of currently alive pieces
// Note: Knight is spelt as Night to different k(N)ight from (K)ing.
void setupChessPieces()
{
  ChessPiece black_rook1 = new ChessPiece("Rook", "a1", 0);
  ChessPiece black_knight1 = new ChessPiece("Night", "b1", 0);
  ChessPiece black_bishop1 = new ChessPiece("Bishop", "c1", 0);
  ChessPiece black_king = new ChessPiece("King", "e1", 0);
  ChessPiece black_queen = new ChessPiece("Queen", "d1", 0);
  ChessPiece black_bishop2 = new ChessPiece("Bishop", "f1", 0);
  ChessPiece black_knight2 = new ChessPiece("Night", "g1", 0);
  ChessPiece black_rook2 = new ChessPiece("Rook", "h1", 0);
  ChessPiece black_pawn1 = new ChessPiece("Pawn", "a2", 0);
  ChessPiece black_pawn2 = new ChessPiece("Pawn", "b2", 0);
  ChessPiece black_pawn3 = new ChessPiece("Pawn", "c2", 0);
  ChessPiece black_pawn4 = new ChessPiece("Pawn", "d2", 0);
  ChessPiece black_pawn5 = new ChessPiece("Pawn", "e2", 0);
  ChessPiece black_pawn6 = new ChessPiece("Pawn", "f2", 0);
  ChessPiece black_pawn7 = new ChessPiece("Pawn", "g2", 0);
  ChessPiece black_pawn8 = new ChessPiece("Pawn", "h2", 0);

  ChessPiece white_pawn1 = new ChessPiece("Pawn", "a7", 1);
  ChessPiece white_pawn2 = new ChessPiece("Pawn", "b7", 1);
  ChessPiece white_pawn3 = new ChessPiece("Pawn", "c7", 1);
  ChessPiece white_pawn4 = new ChessPiece("Pawn", "d7", 1);
  ChessPiece white_pawn5 = new ChessPiece("Pawn", "e7", 1);
  ChessPiece white_pawn6 = new ChessPiece("Pawn", "f7", 1);
  ChessPiece white_pawn7 = new ChessPiece("Pawn", "g7", 1);
  ChessPiece white_pawn8 = new ChessPiece("Pawn", "h7", 1);
  ChessPiece white_rook1 = new ChessPiece("Rook", "a8", 1);
  ChessPiece white_knight1 = new ChessPiece("Night", "b8", 1);
  ChessPiece white_bishop1 = new ChessPiece("Bishop", "c8", 1);
  ChessPiece white_king = new ChessPiece("King", "e8", 1);
  ChessPiece white_queen = new ChessPiece("Queen", "d8", 1);
  ChessPiece white_bishop2 = new ChessPiece("Bishop", "f8", 1);
  ChessPiece white_knight2 = new ChessPiece("Night", "g8", 1);
  ChessPiece white_rook2 = new ChessPiece("Rook", "h8", 1);

  chessPiecesAlive[0] = black_rook1;
  chessPiecesAlive[1] = black_knight1;
  chessPiecesAlive[2] = black_bishop1;
  chessPiecesAlive[3] = black_king;
  chessPiecesAlive[4] = black_queen;
  chessPiecesAlive[5] = black_bishop2;
  chessPiecesAlive[6] = black_knight2;
  chessPiecesAlive[7] = black_rook2;
  chessPiecesAlive[8] = black_pawn1;
  chessPiecesAlive[9] = black_pawn2;
  chessPiecesAlive[10] = black_pawn3;
  chessPiecesAlive[11] = black_pawn4;
  chessPiecesAlive[12] = black_pawn5;
  chessPiecesAlive[13] = black_pawn6;
  chessPiecesAlive[14] = black_pawn7;
  chessPiecesAlive[15] = black_pawn8;

  chessPiecesAlive[16] = white_pawn1;
  chessPiecesAlive[17] = white_pawn2;
  chessPiecesAlive[18] = white_pawn3;
  chessPiecesAlive[19] = white_pawn4;
  chessPiecesAlive[20] = white_pawn5;
  chessPiecesAlive[21] = white_pawn6;
  chessPiecesAlive[22] = white_pawn7;
  chessPiecesAlive[23] = white_pawn8;
  chessPiecesAlive[24] = white_rook1;
  chessPiecesAlive[25] = white_knight1;
  chessPiecesAlive[26] = white_bishop1;
  chessPiecesAlive[27] = white_king;
  chessPiecesAlive[28] = white_queen;
  chessPiecesAlive[29] = white_bishop2;
  chessPiecesAlive[30] = white_knight2;
  chessPiecesAlive[31] = white_rook2;
}

// Method to draw x and y axes i.e. letters A to H and numbers 1 to 8
void drawAxes()
{
  textAlign(CENTER); // Align text to center
  int letter = 65; // Setting ASCII value of letter 'A'
  int number = 1; // Setting y axis numbering starting at 1

    for (int i = base_x; i <= (base_x+1150); i=i+100) // x axis label (top, letters)
  {
    text(char(letter++), i, 80);
  }

  for (int i = (base_x+15); i <= (base_x+1165); i=i+100) // y axis label (left, numbers)
  {
    text(number++, 70, i);
  }
}

// Method to draw entire chess grid
void drawGrid()
{
  int colour = 1; // Setting an integer to represent black/white for use later.

  for (int i = base_x; i < (base_x+800); i=i+100) // y axis loop (Rows)
  {
    for (int j = base_x; j < (base_x+800); j=j+100) // x axis loop (Columns)
    {
      pushMatrix(); // Save the original matrix state onto stack
      translate(j, i); // Translate point of reference to next point for grid
      drawSquare(colour); // Call drawSquare method with corresponding colour
      popMatrix(); // Pop stored matrix (original matrix) to undo translation
      colour = colour * -1; // Invert the colour for the next square
    }
    colour = colour * -1; // Additional inverting of colour for next row
  }
}

// Constantly run method to refresh location of chess pieces on screen
void draw()
{  
  if (t_check == 1 && s_enable == 5) timer_check();
 
    if (SERIAL_EN == 1)
    {
    if (myPort.available() > 0) {  // If data is available,
    int val_1 = myPort.read();         // read it and store it in val
    if (val_1 != 10 && val_1 != 13)
    {
    val = val_1;
    println("Val: " + val);
    
    if (s_enable == 5)
    {
    if (val == '&') // Origin Square Confirmed by Robots
    {
    if (a_timer_sym == '&') timer = 0;
    println("Stage O"); 
    if (Origin == num_to_pos()) 
    {println("OK"); delay(100); set_stage('?');}
    else call_RETRY();
    } 
    
    if (val == '?') // Destination Square Confirmed by Robots
    {
    if (a_timer_sym == '?') timer = 0;
    println("Stage D");
    if (Dest == num_to_pos()) 
    {println("OK"); t_check = 0; set_stage('|');}
    else call_RETRY();
    }
    
    if (val == '|') // Move Registered with Robots
    {
    if (a_timer_sym == '|') timer = 0;
    println("OK"); 
    t_check = 0; s_enable = 6; // Change this to s_enable = 6 i.e. Waiting for Robot Move
    }
    }
    
    if (s_enable == 6)
    {
    /////////// Receive and ACK Robot Move Origin(k) and Destination(l) ////////////
    if (val == '^') // Move Registered with Robots
    {
      int r_kOrl = myPort.read(); // Extract whether its Robot Move's k or l
      if (r_kOrl == 'k') 
      {
        int robot_k = num_to_pos();
        ack_robot_k(robot_k); // Comp -> King ACK Robot k
      }
      else if (r_kOrl == 'l')
      {
        int robot_l = num_to_pos();
        ack_robot_l(robot_l); // Comp -> King ACK Robot l
      }
    }
    }
  } //if (val_1 != 10 && val_1 != 13)
} //if (myPort.available() > 0)
    
} //if SERIAL_EN == 1

  // Iterate through the every chess piece that is still alive
  for (int i = 0; i < 32; i++)
  {
    if (chessPiecesAlive[i].isAlive()) 
    {
      // If it's new x/y is the same as it's old x/y (for animation purposes), ie: it has completed its animation.
      if (chessPiecesAlive[i].xcor == chessPiecesAlive[i].newxcor && chessPiecesAlive[i].ycor == chessPiecesAlive[i].newycor) 
      {
        // A condition to prevent a bug that was preventing switching modes right from the start when a piece was not selected.
        if (!chessPiecesAlive[i].inDefaultPosition()&&pieceSelected==false)
        {
          drawGrid();
        }
        chessPiecesAlive[i].display(); // Display on screen only the ones that are alive
      }
      else // Animation refresh to prevent "shadows"
      {
        drawGrid();
        chessPiecesAlive[i].display();
      }

      // Iterate through every other piece that is not the one currently animating
      for (int j = 0;j<32; j++)
      {
        if (i!=j) // Don't redraw the one moving
        {
          if (chessPiecesAlive[j].isAlive()) 
          {
            chessPiecesAlive[j].display(); // Draw it again to refresh each piece in each frame of animation to clean up after shadows
          }
        }
      }
    }
  }
  
  ////////////// Pressure Bar /////////////////////
  
  fill(255);
  rect(100,prnt_val,bar_size,40);
   
  stroke(0);
  fill(red_color);
  
  if (s_enable == 5)
  {text("Communicating Human Move to Robots...", 480, 30);}
  else if (s_enable == 6)
  {text("Waiting for Robot Move...", 480, 30);}

  else
  {     
  if (b > bar_size) b=bar_size;
  rect(100,prnt_val,b,40);
  }
  
  //////////////// Origin and Destination Printing ///////////////
      
      textFont(fontA, 26);
      
      /* Initial Human Move Acquisition State
         Once the pressure sensor reaches threshold for origin
         s_enable is switched to 1
      */
  
      // Acquire Origin Square of Human Move
      if (s_enable == 0)
      {
      if (s_ctr == 1) {val = def_val; s_ctr = 0;  origin_a.play();}
      
      fill(255);
      rect(920,0,240,40);
  
      stroke(0);
      fill(red_color);
      text("ORIGIN?", 1000, 30);
      
      /*if (human_detect(val) != "z0")
      b = b + bar_incr;*/
      
      if (b >= bar_size) {
      s_enable = 1; 
      b = 0; 
      Origin = get_square_no(s_cell); 
      selectPieceOnGrid(s_cell);
      }
      }
      
      // Display Origin Square of Human Move
      if (s_enable == 1)
      {
      fill(255);
      rect(920,0,240,40);
  
      stroke(0);
      fill(red_color);
      text("ORIGIN = " + Origin + " (" + s_cell + ")", 1040, 30);
      s_cell = "z0";
      ///if ( myPort.available() == 0) 
      s_enable = 2;
      }
      
      // Acquire Destination Square of Human Move
      if (s_enable == 2) 
      {
      if (s_ctr == 0) {val = def_val; s_ctr = 1; dest_a.play();}
      
      fill(255);
      rect(1180,0,240,40);
  
      stroke(0);
      fill(red_color);
      text("DEST?", 1230, 30);
      
      /*if (human_detect(val) != "z0")
      b = b + bar_incr;*/
      
      if (b >= bar_size) {
      s_enable = 3; 
      b = 0; 
      Dest = get_square_no(s_cell); 
      moveSelectedPiece(s_cell);
      ///sp_dest_write(s_cell); // Write and Update Arrays
      ///move_sprite(Dest);
      }
      }
      
      // Display Destination Square of Human Move
      if (s_enable == 3)
      {
      fill(255);
      rect(1180,0,240,40);
  
      stroke(0);
      fill(red_color);
      text("Dest = " + Dest + " (" + s_cell + ")", 1280, 30);
      println("Origin: " + Origin);
      println("Dest: " + Dest);
      s_cell = "z0";
      ///if ( myPort.available() == 0) 
      s_enable = 4;
      }
  
      // Set Stage to Sending Origin and Destination Square to King
      if (s_enable == 4) 
      {
      set_stage('&');
      human_data_a.play();
      terminator_a.play();
      s_enable = 5;  
      }
}

// Method to draw a square chess grid position
// Parameter - int: colour, integer to represent black or white
void drawSquare(int colour)
{
  if (colour==1) // If the passed parameter is 1, make the square white.
  {
    fill(255);
  }
  else // Else, if it is not 1 (likely to be -1), then fill it black.
  {
    fill(0);
  }

  rect(-50, -50, 100, 100); // Draw the rectangle.
}

// Method to see if the clicked mouse position is within the chess grid
boolean isInsideBoard(int mouseXcor, int mouseYcor)
{
  // 100 for mouseX/mouseY refers to the very top left corner of 1a
  // ie: the further legal clickable position
  if (mouseXcor < 100 || mouseYcor < 100 || (mouseXcor < 100 && mouseYcor < 100) || (mouseXcor > 900 && mouseYcor > 900) || (mouseXcor > 900 || mouseYcor > 900))
  {
    System.out.println("Invalid Position");
    return false;
  }
  else
  {
    return true;
  }
}

// Method that is called from mouseClicked() that looks at the position of a mouse click
// and converts that to a notated version of the grid set. If it has a unit on that position, 
// it then highlights the grid and saves the relevant piece/grid information for later use.
// Note: Remember, bulk of method does not activate if:
// a) a piece has already been selected. This is the "choose piece to do something" method.
// b) if the chosen grid has no unit on it.
boolean selectPieceOnGrid(String position)
{
  System.out.println("selectPieceOnGrid -> " + position);
  // If the selected grid position has a unit on it and you haven't already selected a piece
  if (!checkEmpty(position) && pieceSelected==false) 
  {
    selectSquare(position); // Colour the selected piece/grid red
    gridSelected = position; // Save the notated version of clicked position
    selectedPiece = getChessPieceAt(position); // Get the chess piece on that  --------------------------- Consider removing get chess piece at function
    System.out.println("Unit type: " + selectedPiece.getName()); // Print out what type it is
    pieceSelected = true; // Set boolean flag to say that a piece is selected
    return true;
  }
  
  return false;
}

// Method to move a selected piece
void moveSelectedPiece(String position)
{ 
  //System.out.println(position);
  boolean castling = false;
  // If you have already selected a piece (ie: there is a red cell on the chess set)
  if (pieceSelected==true)
  {
    // Castling Conditions
    if (selectedPiece.getName() == "King" && selectedPiece.inDefaultPosition() && selectedPiece!=chessPiecesAlive[indexOfPieceToDie]) // Prevent castling by undoing selection of kind
    {
      // Each quadrant for castling
      if (checkEmpty(position) && position.equals("1c") && checkEmpty("1b") && checkEmpty("1d"))
      {
        chessPiecesAlive[0].updatePosition("1d");
      }
      if (checkEmpty(position) && position.equals("1g") && checkEmpty("1f"))
      {
        chessPiecesAlive[7].updatePosition("1f");
      }
      if (checkEmpty(position) && position.equals("8g") && checkEmpty("8f"))
      {
        chessPiecesAlive[31].updatePosition("8f");
      }
      if (checkEmpty(position) && position.equals("8c") && checkEmpty("8b") && checkEmpty("8d"))
      {
        chessPiecesAlive[24].updatePosition("8d");
      }
    }

    // Check if the destination is occupied
    if (!checkEmpty(position))
    {
      // If it is occupied, get the index array of chessPiecesAlive[] that corresponds to the chess piece
      // that is sitting on the chess grid that you want to move to.
      indexOfPieceToDie = getIndexOfChessPieceAt(position);

      // Check to see if that piece isn't itself and so it doesn't kill itself
      // ie: to allow a user to "unclick" a selected unit
      if (chessPiecesAlive[indexOfPieceToDie]!=selectedPiece)
      {
        System.out.println(chessPiecesAlive[indexOfPieceToDie].getName() + " has died. :(");
        chessPiecesAlive[indexOfPieceToDie].kill();
      }
      else
      {
        // Unselect the piece and decrement its move counter (revert back to what it was before the move)
        System.out.println("Unselected " + selectedPiece.getName());
        selectedPiece.undo();
      }
    }
  }

  // Move select unit to the destination
  selectedPiece.updatePosition(position);
  
  // Pawn/Queen Protion Criteria
  if (selectedPiece.getName() == "Pawn" && selectedPiece.getColour() == 0)
  {
    if (position.charAt(1) == '8')
    {
      selectedPiece.promote();
    }
  }
  if (selectedPiece.getName() == "Pawn" && selectedPiece.getColour() == 1)
  {
    if (position.charAt(1) == '1')
    {
      selectedPiece.promote();
    }
  }

  System.out.println(selectedPiece.getName() + " has moved to " + position);
  pieceSelected = false; // Unselect whatever chess piece has finished its move
  drawGrid(); //  Redraw the grid to refresh cell positions
}

// Default Method for detecting mouse clicks
String clickedCell;
void mouseClicked()
{
  if (!isInsideBoard(mouseX, mouseY)) // Method to check if the selected position is actually on the board
  {
    // Dummy remove this code only for TESTING!! //
    
    if (s_enable == 0) {s_cell = human_detect('W'); b=b+bar_incr;}
    if (s_enable == 2) {s_cell = human_detect('O'); b=b+bar_incr;}
    
    return; // If outside grid, don't do anything
  }

  clickedCell = convertToNotation(mouseX/100, mouseY/100);
  System.out.println("Cell position selected: " + clickedCell);

  if (!pieceSelected) // If the user hasn't selected a piece already
  {
    selectPieceOnGrid(clickedCell); // Run a method that finds the respective piece on that grid position
  }
  else // else, if a piece is selected, move it to the new clicked position
  {
    moveSelectedPiece(clickedCell);
  }
}

// Method that returns the respective chess piece sitting on an notated grid position.
ChessPiece getChessPieceAt(String position)
{
  int indexOfPiece = 0;
  for (int i = 0; i<chessPiecesAlive.length ; i++)
  {
    if (chessPiecesAlive[i].getPosition().equals(position))
    {
      indexOfPiece = i;
    }
  }
  return chessPiecesAlive[indexOfPiece];
}

// Method that returns an int array index from chessPiecesAlive[]
// that is sitting on a notated grid position.
int getIndexOfChessPieceAt(String position)
{
  int indexOfPiece = -1;
  for (int i = 0; i<chessPiecesAlive.length ; i++)
  {
    if (chessPiecesAlive[i].getPosition().equals(position))
    {
      indexOfPiece = i;
    }
  }
  return indexOfPiece;
}

// Method that converts an absolute xy co-ordinate to a notated grid position 
// using ASCII values
String convertToNotation(int x, int y)
{
  String notationPosition = "" +(char(x+96)) + (char(y+48));
  return notationPosition;
}

// Method to check if a notated grid position has a unit sitting on it.
boolean checkEmpty(String position)
{

  for (int i = 0; i<chessPiecesAlive.length ; i++)
  {
    if (chessPiecesAlive[i].getPosition().equals(position))
    {
      System.out.println("Cell Occupied!");
      return false;
    }
  }
  System.out.println("Cell Empty!");
  return true;
}

// Method to highlight a selected square
// where 1 < x||y < 8
void selectSquare(String position)
{
  System.out.println("selectSquare->" + position);
  
  fill(255, 0, 0);
  pushMatrix();
  translate( convertToX(position)+50, convertToY(position)+50 );
  rect(-50, -50, 100, 100);
  popMatrix();
}

// Extracts the x co-ordinate from a cell position
int convertToX(String position)
{
  int xcor = int(position.charAt(0)-96) * 100 ;
  return xcor;
}

// Extracts the y co-ordinate from a cell position
int convertToY(String position)
{
  int ycor = int(position.charAt(1)-48) * 100;
  return ycor;
}

// Methdo to read positions.txt
void readFile()
{
  String fileLine;
  String fileName = dataPath("positions.txt");
  boolean validLine = false;
  String[] splitInput = new String[2];
  int i = -1;
  int j = -1;
  /*try
  {
    System.out.println("Reading positions from file positions.txt");
    System.out.println("Disregarding invalid line format.");
    BufferedReader file = new BufferedReader(new FileReader(fileName));

    while ( (fileLine = file.readLine ())!=null) // Read each line, if it is not empty
    {
      System.out.println("Read line: " + fileLine);
      splitInput = splitTokens(fileLine, ">"); // Tokenise on > character, no serious error checking
      String first_entry = splitInput[0];
      String second_entry = splitInput[1];
      System.out.println(splitInput[0] + " " + splitInput[1]);

      if (!checkEmpty(first_entry)) // Checks to see if the first position has a unit on it and grabs the appropriate square/unit
      {
        selectSquare(first_entry);
        i = getIndexOfChessPieceAt(first_entry);
      }
      if (i!=-1) // Boolean to check if a proper piece has been chosen
      {
        if (!checkEmpty(second_entry)) // Kill the piece if it exists on the destination square before moving and redrawing grid.
        {
          j = getIndexOfChessPieceAt(second_entry);
          chessPiecesAlive[j].kill();
        }
        chessPiecesAlive[i].updatePosition(second_entry);
        drawGrid();
        System.out.println(chessPiecesAlive[i].getName());
      }

    }
  } 
  catch (IOException e)
  {  
    e.printStackTrace();
    fileLine = null;
  }*/
}

// Native methd to detect key presses
void keyPressed()
{

  keyPress = keyPress + key;
  if (keyPress.length() == 2) // Only take keyboard presses in sets of 2
  {
    System.out.println("Keyboard press: " + keyPress);
    if (validPosition(keyPress)) // If the position is a valid position on the board
    {

      if (!pieceSelected) // If the user hasn't selected a piece already
      {
        selectPieceOnGrid(keyPress); // Run a method that finds the respective piece on that grid position
      }
      else // else, if a piece is selected, move it to the new clicked position
      {
        moveSelectedPiece(keyPress);
      }
    }  
    else
    {
      System.out.println("You entered an invalid position");
    }
    keyPress = ""; // Reset the key input
  }

  // Read special key inputs for certain methods
  switch(key)
  {
  case 'r':
  case 'R':
    readFile();
    break;
  case 'm':
  case 'M':
  // Change display Mode
    boolean allDefaultPosition = true;
    for (int i =0; i<32; i++)
    {
      if (!chessPiecesAlive[i].inDefaultPosition())
      {
        allDefaultPosition = false;
      }
      if (allDefaultPosition && !pieceSelected) // needed to prevent odd bug not working at start
      {
        drawGrid();
      }
    }
    switchDisplay(); 
    break;
  }
}

// Returns true if the position is a valid position on the grid
boolean validPosition(String position)
{
  boolean validletter;
  boolean validnumber;
  validnumber = (int(position.charAt(0))-48 >= 1 && position.charAt(0)-48<=8);
  validletter = (int(position.charAt(1))-96 >= 1 && position.charAt(1)-96<=8);
  return (validnumber && validletter);
}

// Method to change display mode
void switchDisplay()
{
  drawGrid(); // Refresh the grid to be able to redraw all other chess pieces
  if (displayMode==0)
  {
    displayMode=1;
  }
  else
  {
    if (displayMode==1)
    {
      displayMode=2;
    }      
    else
    {
      displayMode=0;
    }
  }
  selectSquare(gridSelected); // Reselect the square/piece that was selected before the display change
}

// Class to Represent a ChessPiece
class ChessPiece
{
  String name;
  String position;
  int colour;
  int xcor;
  int ycor;
  int newxcor;
  int newycor;
  PImage chessImg;
  boolean isAlive = true;
  int moves = 0;

  // Default constructor
  public ChessPiece(String name, String position, int colour)
  {
    this.name = name;
    this.position = position;
    this.colour = colour;
    assignTypeImg(name);
    xcor = convertToX(position);
    ycor = convertToY(position);
  }

  // The first run method when creating the visual representation
  void setup()
  {
    size(100, 100);
    display();
  }

  // Method that displays pieces in their position on the screen
  void display()
  {
    assignPieceColour(this.colour);

    newxcor=convertToX(position);
    newycor=convertToY(position);

    pushMatrix();
    translate(xcor, ycor);
    // Display mode 0: Graphics
    if (displayMode==0)
    {
      image(chessImg, -50, -50);
    }

    // Display Mode 1: Text 
    if (displayMode==1)
    {
      if (colour==0)
      {
        fill(70);
      }
      else
      {
        fill(180);
      }
      text(name.charAt(0), 0, 0);
    }

    // Display Mode 2: Half text/half graphics
    if (displayMode==2)
    {
      if (xcor>450)
      {
        image(chessImg, -50, -50);
      }
      else
      {
        if (colour==0)
        {
          fill(70);
        }
        else
        {
          fill(180);
        }
        text(name.charAt(0), 0, 0);
      }
    }

    // For animation purposes: new x/y is the destination, x/y is the old destination. Change co-ordinates based off different.
    if (newxcor == xcor && newycor == ycor)
    {
    }
    else
    {
      if (xcor < newxcor)
      {
        xcor=xcor + 2;
      }
      if (xcor > newxcor)
      {
        xcor=xcor -2;
      }
      if (ycor < newycor)
      {
        ycor=ycor+2;
      }
      if (ycor > newycor)
      {
        ycor=ycor-2;
      }
    }
    popMatrix();
  }

  // Method to assign a graphic given the relevant chess type
  // Uses files inside /data
  // Image source at top of this file.
  void assignTypeImg(String name)
  {
    switch(name.charAt(0))
    {
    case 'P':
      chessImg = loadImage("pawn.png");
      break;
    case 'R':
      chessImg = loadImage("rook.png");
      break;
    case 'N':
      chessImg = loadImage("knight.png");
      break;
    case 'B':
      chessImg = loadImage("bishop.png");
      break;
    case 'Q':
      chessImg = loadImage("queen.png");
      break;
    case 'K':
      chessImg = loadImage("king.png");
      break;
    }
  }

  // Method to colour the graphic for the appropriate player
  void assignPieceColour(int colour)
  {
    if (colour == 0)
    {
      tint(100);
    }
    else
    {
      noTint();
    }
  }

  // Method to kill the chess piece
  void kill()
  {
    isAlive = false;
    position = "";
  }

  // Method to check if the chess piece is alive
  boolean isAlive()
  {
    return isAlive;
  }

  // Method to update position of a ches piece
  void updatePosition(String newPosition)
  {
    moves++;
    this.position = newPosition;
  }

  boolean inDefaultPosition()
  {
    return (moves==0);
  }

  // Method that converts a notated position into it's apropriate global XY co-ordinate
  // ie: 1a will give you 150, 150 - the absolute centre of the grid
  int convertToX(String position)
  {
    return ((int(position.charAt(0))-96) * 100) + 50;
  }
  
  int convertToY(String position)
  {

    return ((int(position.charAt(1))-48) * 100) + 50;
  }

  String getName()
  {
    return this.name;
  }
  String getPosition()
  {
    return position;
  }
  void undo()
  {
    moves--;
  }

  void promote()
  {
    name = "Queen";
    assignTypeImg(this.name);
  }

  int getColour()
  {
    return colour;
  }
}

////////////////////// INSERT PORTED CODE FROM V1 /////////////////////////

////////////////////// Human Detect ////////////////////////

//s_cell -> Selected Cell Variable by Human on Chess Board e.g. a1, 7d, 5f
String human_detect(char v)
{
  String s_local = "z0";
  
  ///////////// ROW 1 ///////////////////
  
  if (v == 'a') {s_local = "a1";}
  if (v == 'b') {s_local = "b1";}
  if (v == 'c') {s_local = "c1";}
  if (v == 'd') {s_local = "d1";}
  if (v == 'e') {s_local = "e1";}
  if (v == 'f') {s_local = "f1";}
  if (v == 'g') {s_local = "g1";}
  if (v == 'h') {s_local = "h1";}
  
  ///////////// ROW 2 ///////////////////
  
  if (v == 'i') {s_local = "a2";}
  if (v == 'j') {s_local = "b2";}
  if (v == 'k') {s_local = "c2";}
  if (v == 'l') {s_local = "d2";}
  if (v == 'm') {s_local = "e2";}
  if (v == 'n') {s_local = "f2";}
  if (v == 'o') {s_local = "g2";}
  if (v == 'p') {s_local = "h2";}
  
  ///////////// ROW 3 ///////////////////
  
  if (v == 'q') {s_local = "a3";}
  if (v == 'r') {s_local = "b3";}
  if (v == 's') {s_local = "c3";}
  if (v == 't') {s_local = "d3";}
  if (v == 'u') {s_local = "e3";}
  if (v == 'v') {s_local = "f3";}
  if (v == 'w') {s_local = "g3";}
  if (v == 'x') {s_local = "h3";}
  
  ///////////// ROW 4 ///////////////////
  
  if (v == 'y') {s_local = "a4";}
  if (v == 'z') {s_local = "b4";}
  if (v == 'A') {s_local = "c4";}
  if (v == 'B') {s_local = "d4";}
  if (v == 'C') {s_local = "e4";}
  if (v == 'D') {s_local = "f4";}
  if (v == 'E') {s_local = "g4";}
  if (v == 'F') {s_local = "h4";}
  
  ///////////// ROW 5 ///////////////////
  
  if (v == 'G') {s_local = "a5";}
  if (v == 'H') {s_local = "b5";}
  if (v == 'I') {s_local = "c5";}
  if (v == 'J') {s_local = "d5";}
  if (v == 'K') {s_local = "e5";}
  if (v == 'L') {s_local = "f5";}
  if (v == 'M') {s_local = "g5";}
  if (v == 'N') {s_local = "h5";}
  
  ///////////// ROW 6 ///////////////////
  
  if (v == 'O') {s_local = "a6";}
  if (v == 'P') {s_local = "b6";}
  if (v == 'Q') {s_local = "c6";}
  if (v == 'R') {s_local = "d6";}
  if (v == 'S') {s_local = "e6";}
  if (v == 'T') {s_local = "f6";}
  if (v == 'U') {s_local = "g6";}
  if (v == 'V') {s_local = "h6";}
  
  ///////////// ROW 7 ///////////////////
  
  if (v == 'W') {s_local = "a7";}
  if (v == 'X') {s_local = "b7";}
  if (v == 'Y') {s_local = "c7";}
  if (v == 'Z') {s_local = "d7";}
  if (v == '1') {s_local = "e7";}
  if (v == '2') {s_local = "f7";}
  if (v == '3') {s_local = "g7";}
  if (v == '4') {s_local = "h7";}
  
  ///////////// ROW 8 ///////////////////
  
  if (v == '8') {s_local = "a8";}
  if (v == '7') {s_local = "b8";}
  if (v == '6') {s_local = "c8";}
  if (v == '5') {s_local = "d8";}
  if (v == '9') {s_local = "e8";}
  if (v == '@') {s_local = "f8";}
  if (v == '#') {s_local = "g8";}
  if (v == '$') {s_local = "h8";}
  
  return s_local;
  
  /*if (s_cell != "z0")
  {
    /// TODO: Add check to see that its human occupied square only - You cannot mess with robot square
  if (s_enable == 0) ///&& selectPieceOnGrid(s_cell))///sp_sel_check(s_cell) == 1) 
  {
  ///sprite_selector();
  b = b + bar_incr;
  }
  
  else if (s_enable == 2) ///&& sp_dest_check(s_cell) == 1) 
  {
  if (pieceSelected)
  {
  ///sprite_selector();
  b = b + bar_incr;
  }
  }
  
  else b = 0;
  }*/
}

///////////// Cell to chess board number mapping /////////////

int get_square_no(String v)
{
  ///////////// ROW 1 ///////////////////
  
  if (v == "a1"){return 0;}
  if (v == "b1"){return 1;}
  if (v == "c1"){return 2;}
  if (v == "d1"){return 3;}
  if (v == "e1"){return 4;}
  if (v == "f1"){return 5;}
  if (v == "g1"){return 6;}
  if (v == "h1"){return 7;}
  
  ///////////// ROW 2 ///////////////////
  
  if (v == "a2"){return 16;}
  if (v == "b2"){return 17;}
  if (v == "c2"){return 18;}
  if (v == "d2"){return 19;}
  if (v == "e2"){return 20;}
  if (v == "f2"){return 21;}
  if (v == "g2"){return 22;}
  if (v == "h2"){return 23;}
  
  ///////////// ROW 3 ///////////////////
  
  if (v == "a3"){return 32;}
  if (v == "b3"){return 33;}
  if (v == "c3"){return 34;}
  if (v == "d3"){return 35;}
  if (v == "e3"){return 36;}
  if (v == "f3"){return 37;}
  if (v == "g3"){return 38;}
  if (v == "h3"){return 39;}
  
  ///////////// ROW 4 ///////////////////
  
  if (v == "a4"){return 48;}
  if (v == "b4"){return 49;}
  if (v == "c4"){return 50;}
  if (v == "d4"){return 51;}
  if (v == "e4"){return 52;}
  if (v == "f4"){return 53;}
  if (v == "g4"){return 54;}
  if (v == "h4"){return 55;}
  
  ///////////// ROW 5 ///////////////////
  
  if (v == "a5"){return 64;}
  if (v == "b5"){return 65;}
  if (v == "c5"){return 66;}
  if (v == "d5"){return 67;}
  if (v == "e5"){return 68;}
  if (v == "f5"){return 69;}
  if (v == "g5"){return 70;}
  if (v == "h5"){return 71;}
  
  ///////////// ROW 6 ///////////////////
  
  if (v == "a6"){return 80;}
  if (v == "b6"){return 81;}
  if (v == "c6"){return 82;}
  if (v == "d6"){return 83;}
  if (v == "e6"){return 84;}
  if (v == "f6"){return 85;}
  if (v == "g6"){return 86;}
  if (v == "h6"){return 87;}
  
  ///////////// ROW 7 ///////////////////
  
  if (v == "a7"){return 96;}
  if (v == "b7"){return 97;}
  if (v == "c7"){return 98;}
  if (v == "d7"){return 99;}
  if (v == "e7"){return 100;}
  if (v == "f7"){return 101;}
  if (v == "g7"){return 102;}
  if (v == "h7"){return 103;}
  
  ///////////// ROW 8 ///////////////////
  
  if (v == "a8"){return 112;}
  if (v == "b8"){return 113;}
  if (v == "c8"){return 114;}
  if (v == "d8"){return 115;}
  if (v == "e8"){return 116;}
  if (v == "f8"){return 117;}
  if (v == "g8"){return 118;}
  if (v == "h8"){return 119;}
  
  return 0;
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

/************** Comp -> King ***************/
/////////////// Send Human Move Origin and Dest to King ///////////////
void send_ori()
{
 String str_send_ori = '&' + str(get_len(Origin)) + Origin;
 println("send_ori() -> " + str_send_ori);
 myPort.write(str_send_ori);
}

void send_dest()
{
 String str_send_dest = '?' + str(get_len(Origin)) + Dest;
 println("send_dest() -> " + str_send_dest);
 myPort.write(str_send_dest);
}

void send_st()
{
 if (SERIAL_EN == 1) myPort.write('|');
}

/////////////// ACK Robot Move Origin(k) and Dest(l) to King ///////////////
void ack_robot_k(int robot_k)
{
  String ack_robot_k_str = "^k" + str(get_len(robot_k)) + str(robot_k);
  myPort.write(ack_robot_k_str);
}

void ack_robot_l(int robot_l)
{
  String ack_robot_l_str = "^l" + str(get_len(robot_l)) + str(robot_l);
  myPort.write(ack_robot_l_str);
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
    
    //println("num_to_pos: " + p_pos);
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

