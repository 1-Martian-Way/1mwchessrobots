import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.spi.*; 
import ddf.minim.signals.*; 
import ddf.minim.*; 
import ddf.minim.analysis.*; 
import ddf.minim.ugens.*; 
import ddf.minim.effects.*; 
import processing.serial.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class chessGraphics extends PApplet {

/* 1MW Chess Robots - Graphics Source Code */









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

int b = 500;
int bar_size = 800;
int s_ctr = 1;

int base_x = 150;
int board_x = 1350;
int board_y = 1000;
int prnt_val = 0;

int red_color = color(255, 0, 0);
int green_color = color(0, 255, 0);
int blue_color = color(0, 0, 255);

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

public void setup()
{
  smooth(); // Setting anti-aliasing for smooth graphics

  size(board_x, board_y);
  fontA = loadFont("Cambria-48.vlw"); // Importing font style
  textFont(fontA, 32); // Setting font style and size
  
  origin = new Minim(this);
  dest = new Minim(this);
  register = new Minim(this);
  human_data = new Minim(this);
  
  origin_a = origin.loadFile("origin.wav");
  dest_a = dest.loadFile("dest.wav");
  register_a = register.loadFile("register.wav");
  human_data_a = human_data.loadFile("human_data.wav");
  
  String portName = Serial.list()[11];
  print(portName);
  myPort = new Serial(this, portName, 19200);
  
  setupChessPieces();
  bg = loadImage("bg.jpg");
  background(bg);
  drawAxes();
  drawGrid();
}

// Method used to setup all Chess pieces' details
// and add them to array of currently alive pieces
// Note: Knight is spelt as Night to different k(N)ight from (K)ing.
public void setupChessPieces()
{
  ChessPiece black_rook1 = new ChessPiece("Rook", "1a", 0);
  ChessPiece black_knight1 = new ChessPiece("Night", "1b", 0);
  ChessPiece black_bishop1 = new ChessPiece("Bishop", "1c", 0);
  ChessPiece black_king = new ChessPiece("King", "1e", 0);
  ChessPiece black_queen = new ChessPiece("Queen", "1d", 0);
  ChessPiece black_bishop2 = new ChessPiece("Bishop", "1f", 0);
  ChessPiece black_knight2 = new ChessPiece("Night", "1g", 0);
  ChessPiece black_rook2 = new ChessPiece("Rook", "1h", 0);
  ChessPiece black_pawn1 = new ChessPiece("Pawn", "2a", 0);
  ChessPiece black_pawn2 = new ChessPiece("Pawn", "2b", 0);
  ChessPiece black_pawn3 = new ChessPiece("Pawn", "2c", 0);
  ChessPiece black_pawn4 = new ChessPiece("Pawn", "2d", 0);
  ChessPiece black_pawn5 = new ChessPiece("Pawn", "2e", 0);
  ChessPiece black_pawn6 = new ChessPiece("Pawn", "2f", 0);
  ChessPiece black_pawn7 = new ChessPiece("Pawn", "2g", 0);
  ChessPiece black_pawn8 = new ChessPiece("Pawn", "2h", 0);

  ChessPiece white_pawn1 = new ChessPiece("Pawn", "7a", 1);
  ChessPiece white_pawn2 = new ChessPiece("Pawn", "7b", 1);
  ChessPiece white_pawn3 = new ChessPiece("Pawn", "7c", 1);
  ChessPiece white_pawn4 = new ChessPiece("Pawn", "7d", 1);
  ChessPiece white_pawn5 = new ChessPiece("Pawn", "7e", 1);
  ChessPiece white_pawn6 = new ChessPiece("Pawn", "7f", 1);
  ChessPiece white_pawn7 = new ChessPiece("Pawn", "7g", 1);
  ChessPiece white_pawn8 = new ChessPiece("Pawn", "7h", 1);
  ChessPiece white_rook1 = new ChessPiece("Rook", "8a", 1);
  ChessPiece white_knight1 = new ChessPiece("Night", "8b", 1);
  ChessPiece white_bishop1 = new ChessPiece("Bishop", "8c", 1);
  ChessPiece white_king = new ChessPiece("King", "8e", 1);
  ChessPiece white_queen = new ChessPiece("Queen", "8d", 1);
  ChessPiece white_bishop2 = new ChessPiece("Bishop", "8f", 1);
  ChessPiece white_knight2 = new ChessPiece("Night", "8g", 1);
  ChessPiece white_rook2 = new ChessPiece("Rook", "8h", 1);

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
public void drawAxes()
{
  textAlign(CENTER); // Align text to center
  int letter = 65; // Setting ASCII value of letter 'A'
  int number = 1; // Setting y axis numbering starting at 1

    for (int i = base_x; i <= (base_x+1150); i=i+100) // x axis label (top, letters)
  {
    text(PApplet.parseChar(letter++), i, 80);
  }

  for (int i = (base_x+15); i <= (base_x+1165); i=i+100) // y axis label (left, numbers)
  {
    text(number++, 70, i);
  }
}

// Method to draw entire chess grid
public void drawGrid()
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
public void draw()
{  
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
    if (dest_c == num_to_pos()) 
    {println("OK"); t_check = 0; set_stage('|');/*s_enable = 0;*/}
    else call_RETRY();
    }
    
    if (val == '|')
    {
    if (a_timer_sym == '|') timer = 0;
    println("OK"); 
    t_check = 0; s_enable = 0;
    }
    
    }}}
    
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
  
  //////////////// Origin and Destination ///////////////
      
      textFont(fontA, 26);
      
      if (s_enable == 0)
      {
      if (s_ctr == 1) {val = def_val; s_ctr = 0;  origin_a.play();}
      fill(red_color);
      text("ORIGIN SQUARE?", 1050, 30);
      }
      
      if (s_enable == 1)
      {
      fill(red_color);
      text("ORIGIN = ", 820, prnt_val);
      text(Origin, 860, prnt_val);
      
      if ( myPort.available() == 0) s_enable = 2;
      }
      
  ////////////// Pressure Bar /////////////////////
  
  fill(255);
  rect(100,prnt_val,bar_size,40);
   
  stroke(0);
  fill(red_color);
  
  rect(100,prnt_val,b,40);
  
  /* Initial Human Move Acquisition State
     Once the pressure sensor reaches threshold for origin
     s_enable is switched to 1
  */
     
  if (s_enable == 0) 
  {
  ///human_detect(val);
  if (b > bar_size) {
  s_enable = 1; 
  b = 0; 
  ///Origin = s_cell; 
  ///s_cell = 100;
  }
  }
  
  if (s_enable == 2) 
  {
   if (s_ctr == 0) {val = def_val; s_ctr = 1; dest_a.play();}
   fill(red_color);
   text("DEST ?", 290, prnt_val);
   
  ///human_detect(val);
  
  if (b > 200) 
  {
   s_enable = 3; 
   b = 0; 
   ///Dest = s_cell = 24; 

   ///sp_dest_write(s_cell); // Write and Update Arrays
   ///move_sprite(Dest);
   print("Origin: ");
   println(Origin);
   
   print("Dest: ");
   println(Dest);

   ///s_cell = 100;
  }
  }
  
  if (s_enable == 3) 
  {
  text(Origin, 290, prnt_val);
      
  if ( myPort.available() == 0) s_enable = 4; // s_enable = 0; 
  }
  
  if (s_enable == 4) 
  {set_stage('&'); 
  s_enable = 5;
  //fill(red_color);
  //text("Communicating ...", 280, 385);    
  }
  
}


// Method to draw a square chess grid position
// Parameter - int: colour, integer to represent black or white
public void drawSquare(int colour)
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
public boolean isInsideBoard(int mouseXcor, int mouseYcor)
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
public void selectPieceOnGrid(String position)
{
  // If the selected grid position has a unit on it and you haven't already selected a piece
  if (!checkEmpty(position) && pieceSelected==false) 
  {
    selectSquare(position); // Colour the selected piece/grid red
    gridSelected = position; // Save the notated version of clicked position
    selectedPiece = getChessPieceAt(position); // Get the chess piece on that  --------------------------- Consider removing get chess piece at function
    System.out.println("Unit type: " + selectedPiece.getName()); // Print out what type it is
    pieceSelected = true; // Set boolean flag to say that a piece is selected
  }
}

// Method to move a selected piece
public void moveSelectedPiece(String position)
{
  System.out.println(position);
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
    if (position.charAt(0) == '8')
    {
      selectedPiece.promote();
    }
  }
  if (selectedPiece.getName() == "Pawn" && selectedPiece.getColour() == 1)
  {
    if (position.charAt(0) == '1')
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
public void mouseClicked()
{
  if (!isInsideBoard(mouseX, mouseY)) // Method to check if the selected position is actually on the board
  {
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
public ChessPiece getChessPieceAt(String position)
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
public int getIndexOfChessPieceAt(String position)
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
public String convertToNotation(int x, int y)
{
  String notationPosition = "" + (PApplet.parseChar(y+48)) +(PApplet.parseChar(x+96));
  return notationPosition;
}

// Method to check if a notated grid position has a unit sitting on it.
public boolean checkEmpty(String position)
{

  for (int i = 0; i<chessPiecesAlive.length ; i++)
  {
    if (chessPiecesAlive[i].getPosition().equals(position))
    {
      System.out.println("Cell is occupied!");
      return false;
    }
  }
  System.out.println("Cell is empty!");
  return true;
}

// Method to highlight a selected square
// where 1 < x||y < 8
public void selectSquare(String position)
{
  fill(255, 0, 0);
  pushMatrix();
  translate( convertToX(position)+50, convertToY(position)+50 );
  rect(-50, -50, 100, 100);
  popMatrix();
}

// Extracts the x co-ordinate from a cell position
public int convertToX(String position)
{
  int xcor = PApplet.parseInt(position.charAt(1)-96) * 100 ;
  return xcor;
}

// Extracts the y co-ordinate from a cell position
public int convertToY(String position)
{
  int ycor = PApplet.parseInt(position.charAt(0)-48) * 100;
  return ycor;
}

// Methdo to read positions.txt
public void readFile()
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
public void keyPressed()
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
public boolean validPosition(String position)
{
  boolean validletter;
  boolean validnumber;
  validnumber = (PApplet.parseInt(position.charAt(0))-48 >= 1 && position.charAt(0)-48<=8);
  validletter = (PApplet.parseInt(position.charAt(1))-96 >= 1 && position.charAt(1)-96<=8);
  return (validnumber && validletter);
}

// Method to change display mode
public void switchDisplay()
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
  public void setup()
  {
    size(100, 100);
    display();
  }

  // Method that displays pieces in their position on the screen
  public void display()
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
  public void assignTypeImg(String name)
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
  public void assignPieceColour(int colour)
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
  public void kill()
  {
    isAlive = false;
    position = "";
  }

  // Method to check if the chess piece is alive
  public boolean isAlive()
  {
    return isAlive;
  }

  // Method to update position of a ches piece
  public void updatePosition(String newPosition)
  {
    moves++;
    this.position = newPosition;
  }

  public boolean inDefaultPosition()
  {
    return (moves==0);
  }

  // Method that converts a notated position into it's apropriate global XY co-ordinate
  // ie: 1a will give you 150, 150 - the absolute centre of the grid
  public int convertToX(String position)
  {

    return ((PApplet.parseInt(position.charAt(1))-96) * 100) + 50;
  }

  public int convertToY(String position)
  {
    return ((PApplet.parseInt(position.charAt(0))-48) * 100) + 50;
  }

  public String getName()
  {
    return this.name;
  }
  public String getPosition()
  {
    return position;
  }
  public void undo()
  {
    moves--;
  }

  public void promote()
  {
    name = "Queen";
    assignTypeImg(this.name);
  }

  public int getColour()
  {
    return colour;
  }
}

///////////// Print Array /////////////

public void print_arr()
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
public void send_ori()
{
 String s_len = "";
 ori_c = OD_conv(Origin);
 myPort.write('&');
 int len = get_len(ori_c);
 s_len = len_to_str(len);
 myPort.write(s_len + ori_c);
}

public void send_dest()
{
 String s_len = "";
 dest_c = OD_conv(Dest);
 myPort.write('?');
 int len = get_len(dest_c); 
 s_len = len_to_str(len);
 myPort.write(s_len + dest_c);
}

public void send_st()
{
 myPort.write('|');
}

public String len_to_str(int len)
{
 String s_len = "";
 if (len == 1) s_len = "1";
 if (len == 2) s_len = "2";
 if (len == 3) s_len = "3";
 
 return s_len;
}

////////////////// CALL_RETRY ////////////////////////

public void call_RETRY() {
 println("Retry"); 
 timer = 0;
 delay(1000);
 
 if (stage == '&') send_ori();
 if (stage == '?') send_dest();
 if (stage == '|') send_st();
}
////////////////// SET_STAGE ////////////////////////

public void set_stage(char stg)
{
/* HUMAN MOVE STAGE */
  if (stg == '&') {stage = '&'; attach_timer('&'); send_ori();}
  if (stg == '?') {stage = '?'; attach_timer('?'); send_dest();}
  if (stg == '|') {stage = '|'; attach_timer('|'); send_st();}
} 

////////////////// TIMER_FUNCS ////////////////////////

///////// ATTACH A_TIMER ///////////

public void attach_timer(char scan_sym)
{
  if (scan_sym == '&') a_timer_sym = '&'; // Origin Move
  if (scan_sym == '?') a_timer_sym = '?'; // Dest Move
}

///////////////// Timer Code ///////////////////

public void timer_check()
{
  timer++;
  if (timer > 100)
  call_RETRY();
}

///////////////// Serial Value -> Pos ////////////////////////

 public int num_to_pos()
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

 public int get_len(int pc_val) 
 {
 int pc_len = 0;
  
 if (pc_val < 10) pc_len = 1;
 if (pc_val >= 10 && pc_val < 100) pc_len = 2;
 if (pc_val >= 100) pc_len = 3;
 
 return pc_len;
 }

//////////////// OD Converter //////////////////////

public int OD_conv(int od)
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

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--full-screen", "--bgcolor=#666666", "--stop-color=#cccccc", "chessGraphics" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
