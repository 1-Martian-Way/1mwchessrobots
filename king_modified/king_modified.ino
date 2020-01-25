#define W while

int M=136,S=128,I=8000,C=799,Q,O,K,N, step_size, step_vector, ss_cnt;   
int k=16;
int d_lim = 100;
unsigned char sr;

char L,*P,
w[]={0,1,1,-1,3,3,5,9},                      
o[]={-16,-15,-17,0,1,16,0,1,16,15,17,0,14,18,31,33,0,
     7,-1,6,11,8,3,6,                          
     6,4,5,7,3,5,4,6},                         
b[129],

n[]=".?+knbrq?*?KNBRQ",
n_test[]=".?+knbrq?*?KNBRQ",

c[9];

int draw_flag = 1;
int call_auto = 0;

//////////// Piece Current Position Variables ///////////////

int c_pos[16] = {96, 97, 98, 99, 100, 101, 102, 103,
               112, 113, 114, 115, 116, 117, 118, 119};

int h_pos[16] = {0, 1, 2, 3, 4, 5, 6, 7,
                 16, 17, 18, 19, 20, 21, 22, 23};

char c_ID[16] = {'a','b','c','d','e','f','g','h',
                 'i','j','k', // R1, N1, B1
                 'l','m', // K, Q
                 'n','o','p'}; // B2, N2, R2
               
char curr_dir_ID;
char curr_p_ID;
char curr_p_ID_map;
int curr_step_ID;

// Recvd Value //

int curr_P_recvd = 200;
int K_recvd = 200;
int L_recvd = 200;

int comm = 0;

char stage;
char a_timer_sym;

int send_ctr = 0;

int knight = 0;
int knight_adj = 0;
int no_piece = 0;
int step_val = 0;
int move_diff = 0;

/////////////////////// HGM Piece //////////////////////////////

int call_ctr = 0;
char dir_f;

int lf_ok = 1;
int corr_applied = 0;
int adjust_ctr = 0;
int ad_ctr_val = 20;
int solo = 0;
int stat_calib = 0;
int begin_diag = 0;
int l_dturn = 1;
int flag_wait = 0;
int pre_ad = 0;
int pre_ctr = 0;

int FL_g_val = 0;
int FR_g_val = 0;

int b_try = 0;
int b_try_cnt = 0;
int bt_cnt_val = 30;
//////////////////////////// HGM ROBOT ///////////////////////////

int servo_forward = 9;
int servo_back = 10; // LED connected to digital pin
int servo_left = 6;
int servo_right = 11;

int p_left = 1500;
int p_right = 1500;
int p_back = 1500;
int p_forward = 1500;

int pulse_width_left = p_left;
int pulse_width_right = p_right;
int pulse_width_back = p_back;
int pulse_width_forward = p_forward;

long lastPulse = 0; 
int refreshTime = 20;
int transistor = 4;

int black_detect = 0;

int sens_TH[12] = {0,0,0,0,0,0,0,0,0,0,0,0};
int demo_array[3] = {1,4,8};
int demo_cnt = 0;
int demo_on = 0;

int w_val_high = 110;  // 120
int w_val_low = 60;  // 120
int w_val = w_val_low;

int dir_flag = 99;
 
int d_DT = 0;
int delay_detect = 0;

int DIAG_ROTATE_SPEED = 50;
int DIAG_ROTATE_CORR_low = 20; // 60
int DIAG_ROTATE_CORR_high = 50; // 60
int DIAG_ROTATE_CORR = 20;

///////////////////FLAGS DELAYS/////////////////////////////////

int F = 21;
int B = 22;
int RF = 23;
int LF = 24;
int LEFT = 25;
int RIGHT = 26;

int last_dir = F;
int state = F;
char pend = 'N';
char call = 'N';

int line_time = 0;
int wait_to_k = 0;
int wait_to_c = 0;
int wait_time = 20;
int repeat_cnt = 1;

int delay_CI_detect = 0;
int delay_CI_detect_val = 60;
int d_DT_val = 20;
int flag_avoid = 0;
int flag_cnt = 0;

/////////////////// XY Flags ////////////////////
int c_cnt = 0;
int calib_turn = 0;
int high_cal = 100, low_cal = 40;
int v1,v2 = 0;
int v1_max = 0;
int v2_max = 0;
int v1_min = 500; 
int v2_min = 500;
int v1_sensor_TH, v2_sensor_TH;
int at, at_sensor_TH;
/////////////////////////////////////////////////

int c_high = 0;
int c_low = 0;
char calibration_flag;
//////////////////////////////////////////////////////

int s0 = 8;
int s1 = 12;
int s2 = 13;
int r0 = 0;      
int r1 = 0;
int r2 = 0;

////////// 74HC595 /////////////////

byte data;
byte data_pos;
byte dataArray[10]; 
byte dataArray_pos[10];

int dataPin = 5;
int clockPin = 2;
int latchPin = 3;

////////////////////////////////////

int data_in = 0;  // Read FL BL LD RD Data
int data_in2 = 1; // Read FR BR LU RU Data

int a2 = 2; // Read P1L
int a3 = 3; // Read P2L
int a4 = 4; // Read P1R
int a5 = 5; // Read P2R

int bin[] = {10, 1, 0, 11, 100, 110, 111, 101}; //Sequential
int cal_count = 0;
int corr_pending = 0;
int init_cnt = 0;
int pturn = 0;
int timer = 0;
int t_r_map = 0;
int comp_flag = 0;
int h_input = 0;
int flag_kill = 0;
char kill_ID;

int poll_ctr = 16;
int blink_ctr = 0;

int king_boot = 0;
int boot_me = 0;

int knight_pending = 0;
char curr_b_ID = 'z';
int curr_b_pos = 200;

int blocking_pc = 200;
int adj_pc_ctr = 0; 

int piece_quit = 0;
 
/////////////////////////////////////////////////////

void shiftOut(int myDataPin, int myClockPin, byte myDataOut) {
 
  int i=0;
  int pinState;
  pinMode(myClockPin, OUTPUT);
  pinMode(myDataPin, OUTPUT);

    digitalWrite(myDataPin, 0);
    digitalWrite(myClockPin, 0);

    for (i=0; i<=7; i++) 
    {
    digitalWrite(myClockPin, 0);

    if ( myDataOut & (1<<i) ) pinState= 1;
    else pinState= 0;

    digitalWrite(myDataPin, pinState);
    digitalWrite(myClockPin, 1);
    digitalWrite(myDataPin, 0);
    }
  
    digitalWrite(myClockPin, 0);
}

void activate_led(int main_led, int pos_led)
 { 
    digitalWrite(latchPin, 0);
       
    shiftOut(dataPin, clockPin, dataArray_pos[pos_led]);
    shiftOut(dataPin, clockPin, dataArray[main_led]);
    
    digitalWrite(latchPin, 1);
 }
 
 int read_sensor(int a_sensor)
 { 
    int row = bin[a_sensor];      
  
    r0 = row & 0x01;
    r1 = (row>>1) & 0x01;
    r2 = (row>>2) & 0x01;

    digitalWrite(s0, r0);
    digitalWrite(s1, r1);
    digitalWrite(s2, r2);
 }
 
void simple (int main , int pos, int sens)
{
 activate_led(main,pos);
 read_sensor(sens);
}

void setup()  {
   
   pinMode(servo_left, OUTPUT);
   pinMode(servo_right, OUTPUT);
   pinMode(servo_back, OUTPUT);
   pinMode(servo_forward, OUTPUT);
  
   pinMode(transistor, OUTPUT);
         
   /////////// 74HC595 /////////////
   pinMode(latchPin, OUTPUT);  
   
   dataArray[0] = 0x00; //00000000  None
   dataArray[1] = 0xC0; //10100000  FL FR
   dataArray[2] = 0x30; //00110000  BL BR
   
   dataArray_pos[0] = 0x00; //00000000  None
   dataArray_pos[2] = 0x30; //00110000  P3 P4
   
   /////////////////////////////////
   
   pinMode(s0, OUTPUT);    
   pinMode(s1, OUTPUT); 
   pinMode(s2, OUTPUT);
  
   Serial.begin(19200);
   
   delay(1000);
   
    // Init Chess Engine Variables
    K=8;
    W(K--)
    {b[K]=(b[K+112]=o[K+24]+8)+8;b[K+16]=18;b[K+96]=9;
    L=8;W(L--)b[16*L+K+8]=(K-4)*(K-4)+(L-3.5)*(L-3.5); 
    }        
    
    // Init Chess Engine & Draw Table
    if (D(16,-I,I,Q,O,8,2)==I)
    {
    Serial.println("Chess Engine OK");
    draw_table(); 
    set_stage('~');
    }
    else
    {
    Serial.println("Chess Engine FAIL");  
    return;
    }
    
    // Draw Table w/o Chess Engine Init
    /*draw_table(); 
    set_stage('~');*/
    
    robot_play();
 }
 
void loop()  {
 
  if (millis() - lastPulse >= refreshTime) { 

  if (wait(200) == 1){
  if (wait_to_k == 1) 
  {wait_to_k = 0; 
  if (knight_pending == 1) {knight_pending = 0; set_stage('[');}  
  
  else {comp_flag = 1; set_stage('k');}
  }
  
  if (wait_to_c == 1) 
  {wait_to_c = 0; set_stage(',');} // Complete Pending Kill Piece
  
  /*KK_MOD-19/12/14 - Disabling the whole polling complexity for now
  if (wait_to_k == 2) 
  { 
    wait_to_k = 0;
    stage='~';  
    attach_timer('~');
    
    if (poll_ctr == 0)
     {
     king_boot++;
     if (king_boot == 1) {poll_ctr = 16; king_boot = 0; set_stage('*');}
     }
     
    else if (poll_ctr > 0) {h_input = 0; poll(1);}   
  }*/
  
  if (wait_to_k == 3)
  {
   wait_to_k = 0;
   adj_blocking_pc();
   knight_pending = 1;
  }
  
  if (wait_to_k == 4)
  {wait_to_k = 0; set_stage('=');}
  
  if (wait_to_k == 5)
  {wait_to_k = 0; robot_play(); h_input = 1;}
}
  
  if (h_input == 0) timer_check();
  
  if ( Serial.available() > 0) { 
   
   char inByte = Serial.read(); // read a byte
  
/******************* Core Communication *************************/

    /*************** CHESS DATA EXCHANGE ************************/
     
    /* If Destination Received from Piece Send K and L to Comp */
    if (inByte =='-') 
    {
    Serial.print("-"); 
    line_time = 0; 
    wait_to_k = 1;
    }
   
    if (inByte =='>') {Serial.print(">"); line_time = 0; wait_to_k = 3;}
   
    if (inByte =='+') {Serial.print("+"); line_time = 0; wait_to_k = 4;}
   
    if (inByte =='}') {Serial.print("}"); line_time = 0; wait_to_k = 5;}
   
    ///////// Reconfirm Blocking Direction ///////////
    
    if (inByte == '[') reconfirm_b_dir();   
    
    ////////// 2. Update between King and Comp ////////////////
    
    if (inByte =='@' || inByte =='!' || inByte =='x'
        || inByte ==':' || inByte ==',' || inByte =='~'
        || inByte == ']' || inByte == ')' || inByte == '='
        || inByte == '/' || inByte == '{')
    {
    if (stage == inByte) 
    {call_OK(); h_input = 1;}
    else call_RETRY();
    
    //////////////////////////////////////////////////
    
    if (inByte =='@') // Send Go Stage
    {
    if (flag_kill == 1) set_stage('!');
    // Tell Comp to ask humans to get out -> 
    // initiates a response ; from Comp //
    } 
    
    if (inByte =='!') 
    {
    char p_ID_recvd = Serial.read(); // Get move ID
    L_recvd = num_to_pos();
    reconfirm_l_comp();
    }
    
    if (inByte == '~') set_stage('@'); // King Boot 1
    if (inByte == ')') {set_stage('@'); knight = 0; u_R_map();} // Map Received
    } 

    if (inByte == '`'){Serial.print("`"); line_time = 0; wait_to_k = 2;}
    
    if (inByte == ';') 
    {Serial.print(";"); line_time = 0; wait_to_c = 1;}
   
    if (inByte == '&' || inByte == '?')
    orig_dest(inByte);
   
    if (inByte == '|')
    {
     k = 16;
     //K = I;
    
     if (D(k,-I,I,Q,O,8,2)==I)
     {    
     u_H_map();
     draw_table();
     
     if (robot_atk_chk() == 1) {piece_quit = 1; set_stage('(');} // Piece Quit Stage
     else robot_play();
     h_input = 0;
     }
     else set_stage('/'); // Human Input Error Stage
    }
     
     /*************** MAP DATA EXCHANGE ************************/
    
    /////////////// Confirm Blocking Piece //////////////////
    
    if (inByte == '<')
    {
    blocking_pc = num_to_pos(); // Serial to Pos
    Serial.print("<");
    pos_to_num(blocking_pc);
    }
    
    /////////////// 1. Reconfirm KL_comp ////////////////////
   
    if (inByte == '^')
    {
    if (stage == 'k' || stage == 'l') timer = 0;
    char p_ID_recvd = Serial.read(); // Get move ID
    
    if (p_ID_recvd == 'k')
    {
    K_recvd = num_to_pos();
    reconfirm_k_comp();
    }
    
    else if (p_ID_recvd == 'l')
    {
    L_recvd = num_to_pos();
    reconfirm_l_comp();
    }
    }
    
    /////////////// 2. Reconfirm Map ////////////////////
   
    if (inByte == '(')
    {
    if (stage == '(') timer = 0;
    
    char p_ID = Serial.read(); // Get piece ID
    curr_P_recvd = num_to_pos();
    reconfirm_map(p_ID);
    }
     
    if (inByte =='#') // Indicates success of Piece Quit
    {
    char p_ID = Serial.read();  // Piece ID to NULL  
    obound_p_ID(p_ID);  
    }

    /*************** MOVE DATA EXCHANGE ************************/
    
    /////////////// 1. Reconfirm Move ////////////////////
    
    if (inByte == '_')
    {
    if (a_timer_sym == '_') timer = 0;
    
    char p_ID_recvd = Serial.read(); // Get move ID
    
    if (p_ID_recvd == 'j' || p_ID_recvd == 'o')
    {
    K_recvd = num_to_pos();
    reconfirm_move(p_ID_recvd, 'z', 'z');
    }
    
    else if (p_ID_recvd == 'L')
    {
    L_recvd = num_to_pos();
    reconfirm_move(p_ID_recvd, 'z', 'z');
    }
    
    else if (p_ID_recvd != 'j' && p_ID_recvd != 'o')
    {
    char dir_ID_recvd = Serial.read();
    char step_ID_recvd = Serial.read();
    if (flag_kill == 1)  kill_ID = Serial.read(); 
    reconfirm_move(p_ID_recvd, dir_ID_recvd, step_ID_recvd);
    }}
    
      
/******************* Human Controlled ************************/

    if (inByte == '1') { // if that byte is the desired character
 
    char in = Serial.read();
    
    //////////// Set Direction Flags ///////////////////
    
    if (in == '0')  dir_flag = 0;  // STOP 
    /*if (in == '1')  dir_flag = 1;  // FORWARD    
    if (in == '2')  dir_flag = 2;  // BACK
    if (in == '3')  dir_flag = 3;  // LEFT
    if (in == '4')  dir_flag = 4;  // RIGHT
    if (in == '5')  dir_flag = 5;  // LF
    if (in == '6')  dir_flag = 6;  // LB
    if (in == '7')  dir_flag = 7;  // RF
    if (in == '8')  dir_flag = 8;  // RB*/
    if (in == '=')  dir_flag = 20;
    }
    
    /////////////// Auto Calibrate //////////////////////// 
    
    if (inByte == '4') 
    {char in = Serial.read();
    if (in == '0')  dir_flag = 40; // Read FL FR Sensors
    solo = 0;}
    
    }
 
  if (dir_flag == 99) think_blink();   
 ////////////// XY SELF CALIBRATION CODE /////////////////

   /*if (dir_flag == 40)
   {
   c_cnt++;;
   
   if (calib_turn == 0)
   {
   simple(1,2,0);
   v1 = get_FL_sensor_values();
   v2 = get_FR_sensor_values();
   }
   
   if (calib_turn == 1)
   {
   simple (1,2,0);
   v1 = get_P2L_sensor_values();
   v2 = get_P2R_sensor_values();
   }
   
   ///////////////// < Low Cal ///////////////////
   
   if (c_cnt < low_cal)
   DTURN_LF();
   
   if (c_cnt > low_cal && c_cnt <= high_cal)
   DTURN_RF();
   
   ////////////////// <= HIGH ////////////////////
   
   if (c_cnt <= high_cal)
   {
   v1_max=(v1>v1_max && v1!=0)?v1:v1_max;
   v1_min=(v1<v1_min && v1!=0)?v1:v1_min;
   v2_max=(v2>v2_max && v2!=0)?v2:v2_max;
   v2_min=(v2<v2_min && v2!=0)?v2:v2_min;
   
   v1_sensor_TH = v1_min + ((v1_max - v1_min)/3);
   v2_sensor_TH = v2_min + ((v2_max - v2_min)/3);
   }
   
   if (c_cnt > high_cal) 
   {
   DTURN_LF();
   if (calib_turn == 0) 
   {
   at = v2;
   at_sensor_TH = v2_sensor_TH;
   }
   
   else if (calib_turn == 1)
   {
   at = v1;
   at_sensor_TH = v1_sensor_TH;
   }
   
   if (at < at_sensor_TH)
   {
   v1_max = v2_max = 0;
   v1_min = v2_min = 500;
   
   if (calib_turn == 0) 
   {
   sens_TH[0] = v1_sensor_TH;
   sens_TH[1] = v2_sensor_TH;
   
   if (solo == 1) reset_c_counters();
   }
    
   if (calib_turn == 1) 
   {
   sens_TH[10] = v1_sensor_TH;
   sens_TH[11] = v2_sensor_TH;
    
   //dir_flag = 51;
   pulse_zero(); 
   calib_turn = 0;
   last_dir = F;
   state = RF;
   set_pend('N');
   set_call('N');
   reset_delay_counters();
   dir_flag = 22;
   }
   
   c_cnt = 0;
   calib_turn++;
   delay(200);
   }}}*/
   
   if (dir_flag == 22)
   {
   demo_on = 1;
   demo_cnt = 0;
   dir_flag = demo_array[demo_cnt];
   }
   
  /////////// Read Direction Flags ////////////////////////
   
 /*  if (dir_flag == 51)  // State Cleanup Dir Flag
   {
    pulse_zero(); 
    calib_turn = 0;
    last_dir = F;
    state = RF;
    set_pend('N');
    set_call('N');
    reset_delay_counters();
   }*/
   
   if (dir_flag == 50) // State Preserve Dir Flag
   {
    pulse_zero(); 
    last_dir = F;
    set_pend('N');
    set_call('N');
    reset_delay_counters();
    
    //if (boot_me == 1) {boot_me = 0; poll(1);}
    
    if (demo_on == 1 && demo_cnt < 3)
    {demo_cnt++; dir_flag = demo_array[demo_cnt];}
    if (demo_cnt >= 3) {demo_on = 0; demo_cnt = 0;};
   }
   
   if (dir_flag == 0)
   {      
    if ((last_dir == F || last_dir == B) && get_pend() == 'N')
    {state = RF; dir_flag = 50;}
    
   ///////// EXECUTE CORRECTION PENDING ///////////
   
   if (get_pend() == 'L')
   {
     dir_flag = 9;
     reset_delay_counters();
     DTURN_LF();
   }
   
   else if (get_pend() == 'R')
   {
     dir_flag = 9;
     reset_delay_counters();
     DTURN_RF();
   }}
   
   ///////////// FORWARD /////////////////////////////
   
   if (dir_flag == 1) 
   {}
     /*simple(1,2,0);
     
     if (last_dir != RF && last_dir != LF)
     { // This can happen only when it has corrected pending
     if (state == RF || state == LF)
     {
     lf_ok = 0;
     delay(50);
     
     int FL_val = get_FL_sensor_values();
     int FR_val = get_FR_sensor_values();  
     
     if (corr_applied == 0)
     {
     if (FR_val > sens_TH[1] && FL_val < sens_TH[0])
     corr_applied = 1;
     
     else if (FR_val < sens_TH[1] && FL_val > sens_TH[0])
     corr_applied = 2;
     
     else if (FR_val > sens_TH[1] && FL_val > sens_TH[0])
     {
     if (state == RF) corr_applied = 1;
     if (state == LF) corr_applied = 2;
     }
    
     else lf_ok = 1; 
     }
     
     if (corr_applied == 1)
     {
     DTURN_LF();
     last_dir = F;
     state = RF;
     
     if (FR_val < sens_TH[1] && FL_val > sens_TH[0]) 
     lf_ok = 1;
     }
     
     if (corr_applied == 2)
     {
     DTURN_RF();
     last_dir = F;
     state = RF;
     
     if (FR_val > sens_TH[1] && FL_val < sens_TH[0]) 
     lf_ok = 1;
     }}}
     
     if (lf_ok == 1) 
     {
     corr_applied = 0;
     state = F;
     
     if (last_dir == RF || last_dir == LF) 
     flag_avoid = step_val * 2; 
   
     if (last_dir != RF && last_dir != LF) // If there is no coupling
     {
     if (get_call() == 'L') last_dir = LEFT;
     else if (get_call() == 'R') last_dir = RIGHT;
     else if (get_call() == 'B') last_dir = B;
     else last_dir = F;
     flag_avoid = step_val;
     }
     
     w_val = w_val_low;
     DIAG_ROTATE_CORR = DIAG_ROTATE_CORR_high;
     
     delay_CI_detect++;
     
     if (delay_CI_detect > delay_CI_detect_val) 
     {w_val = w_val_high; 
     DIAG_ROTATE_CORR = DIAG_ROTATE_CORR_low;
     CI_detect();}
     
     forward();
     
     }}
  //////////////////// BACK ////////////////////////
  
  if (dir_flag == 2)
  {      
     simple(1,2,0);
    
     if (begin_diag == 0) pre_pending();
     
     ///////////////////////////////////////
     
     else if (begin_diag == 1)
     {
     DTURN_LF();
     set_call('B'); 
     detect_cycle();
     }
  }
  
  ///////////////// LEFT //////////////////
  
   if (dir_flag == 3)
   {    
     simple(1,2,0);
     
     if (begin_diag == 0) pre_pending();
       
     ///////////////////////////////////////
     
     else if (begin_diag == 1)
     {
     DTURN_LF();
     set_call('L');
     detect_cycle();
     }     
    }
  
  ///////////////// RIGHT //////////////////
  
   if (dir_flag == 4)
   {   
     simple(1,2,0);
     
     if (begin_diag == 0) pre_pending();
       
     ///////////////////////////////////////
     
     else if (begin_diag == 1)
     {
     DTURN_RF();
     set_call('R'); 
     detect_cycle();
     }
    }
    
  ////////////// LF //////////////////
  
  if (dir_flag == 5)
  {       
     simple(1,2,0);
     
     if (begin_diag == 0) pre_pending();
     
     ///////////////////////////////////////
     
     else if (begin_diag == 1)
     {
     DTURN_LF();
     set_call('W'); 
     detect_cycle();
     }
  }
  
  //////////////// LB ///////////////////
  
  if (dir_flag == 6)
  {    
     simple(1,2,0);
     
     if (begin_diag == 0) pre_pending();
     
     ///////////////////////////////////////
     
     else if (begin_diag == 1)
     {
     DTURN_RF();
     set_call('X'); 
     detect_cycle();
     }
  }
 
  //////////////// RF ///////////////////
  
  if (dir_flag == 7)
  {    
     simple(1,2,0);
     
     if (begin_diag == 0) pre_pending();
     
     ///////////////////////////////////////
     
     else if (begin_diag == 1)
     {
     DTURN_RF();
     set_call('Y'); 
     detect_cycle();
     }
}
 
 //////////////// RB ///////////////////
  
  if (dir_flag == 8)
  {         
    simple(1,2,0);
     /////////// Pre-Pending //////////////
     
     if (begin_diag == 0) pre_pending();
     
     ///////////////////////////////////////
     
     else if (begin_diag == 1)
     {
     DTURN_LF();
     set_call('Z');
     detect_cycle();
     }
 }

  if (dir_flag == 9) corr_cycle();  */
 ////////////////////////////////////////////////// 
 
if (dir_flag == 20)
{
   simple(1,2,0);
   Serial.println("\nRes...");
   digitalWrite(transistor, HIGH);
} // End Serial.available


if (dir_flag == 21)
{
    int ready_3;
    
    //Serial.println("corr_move");
   
    if(get_call() == 'L' || get_call() == 'B' || get_call() == 'W' || get_call() == 'Z') 
    ready_3 = corr_RF();
    
    if(get_call() == 'R' || get_call() == 'X' || get_call() == 'Y') 
    ready_3 = corr_LF();
    
    if (ready_3 == 1) 
    {
     pulse_width_back = p_back;
     pulse_width_forward = p_forward;
     dir_flag = 1;
     
     if(get_call() == 'L')
     {
     last_dir = LEFT;
     state = LF;
     }
     
     if(get_call() == 'R')
     {
     last_dir = RIGHT;
     state = RF;
     }
     
     if(get_call() == 'B')
     {
     last_dir = B;
     state = F;
     }     
     
     reset_delay_counters();
    }
}

    digitalWrite(servo_left, HIGH); 
    delayMicroseconds(pulse_width_left); 
    digitalWrite(servo_left, LOW); 
    digitalWrite(servo_right, HIGH); 
    delayMicroseconds(pulse_width_right); 
    digitalWrite(servo_right, LOW); 
    digitalWrite(servo_back, HIGH); 
    delayMicroseconds(pulse_width_back); 
    digitalWrite(servo_back, LOW); 
    digitalWrite(servo_forward, HIGH); 
    delayMicroseconds(pulse_width_forward); 
    digitalWrite(servo_forward, LOW); 
    lastPulse = millis();   
}} // END LOOP


////////////////// FUNCTIONS ////////////////////////////

void detect_cycle()
{
   if (get_call() == 'L' || get_call() == 'R') repeat_cnt = 2;
   else if (get_call() == 'W' || get_call() == 'Y') repeat_cnt = 1;
   else if (get_call() == 'X' || get_call() == 'Z') repeat_cnt = 3;
   else if (get_call() == 'B') repeat_cnt = 4; 
   else repeat_cnt = 1;
   
   ////////////////// Flag Wait 0 ///////////////////
   
   if (flag_wait == 0)
   {
   //Serial.println("wait 0");
   
   FR_g_val = get_FR_sensor_values();
   FL_g_val = get_FL_sensor_values();
   
   d_DT++;
   //Serial.println(d_DT);
   
   if (d_DT > d_DT_val) 
   {
   if (last_dir == LF)
   if (line_detect('L') == 1) {l_dturn++; flag_wait = 1;}
   
   if (last_dir == RF)
   if (line_detect('R') == 1) {l_dturn++; flag_wait = 1;}
   }
   }
   ////////////////// Flag Wait 1 ///////////////////
   
   if (flag_wait == 1)
   {
   //Serial.print("LD_TURN: ");
   //Serial.println(l_dturn);
   
   //Serial.println("wait 1");
   pulse_zero();
   if (wait(wait_time) == 1)
   { 
   if (l_dturn > repeat_cnt) dir_flag = 21;
   
   else if (l_dturn <= repeat_cnt) // Else continue next iteration
   {//Serial.println("Next"); 
    d_DT = 0; 
    flag_wait = 0;
    }
   }
   }
}

///////////////////// CORR CYCLE //////////////////////

void corr_cycle()
{
   if (get_call() == 'L') {DTURN_RF(); repeat_cnt = 2;} 
   else if (get_call() == 'R') {DTURN_LF(); repeat_cnt = 2;}
   else if (get_call() == 'W') {DTURN_RF(); repeat_cnt = 1;}
   else if (get_call() == 'X') {DTURN_LF(); repeat_cnt = 3;}
   else if (get_call() == 'Y') {DTURN_LF(); repeat_cnt = 1;}
   else if (get_call() == 'Z') {DTURN_RF(); repeat_cnt = 3;} 
   else if (get_call() == 'B') {DTURN_RF(); repeat_cnt = 4;} 
   else repeat_cnt = 1;
   
   ////////////////// Flag Wait 0 ///////////////////
   
   if (flag_wait == 0)
   {
   //Serial.println("wait 0");
   
   FR_g_val = get_FR_sensor_values();
   FL_g_val = get_FL_sensor_values();
   
   d_DT++;
   
   if (d_DT > d_DT_val) 
   {
   if (last_dir == LF)
   if (line_detect('L') == 1) {l_dturn++; flag_wait = 1;}
   
   if (last_dir == RF)
   if (line_detect('R') == 1) {l_dturn++; flag_wait = 1;}
   }
   }
   ////////////////// Flag Wait 1 ///////////////////
   
   if (flag_wait == 1)
   {
   //Serial.println("wait 1");
   
   pulse_zero();
   
   if (wait(wait_time) == 1) 
   {
   if (l_dturn > repeat_cnt) flag_wait = 2;
   
   else if (l_dturn <= repeat_cnt) // Else continue next iteration
   {//Serial.println("Next"); 
    d_DT = 0; 
    flag_wait = 0; 
    }
   }
   }
   
   ////////////////// Flag Wait 2 ///////////////////
   
   if (flag_wait == 2)
   {
    //Serial.println("wait 2");
   
    if (last_dir == LF)
    {state = LF; dir_flag = 50;}
    
    if (last_dir == RF)
    {state = RF; dir_flag = 50;} 
   }
}

////////////////// Line Detect ///////////////////////

int line_detect(char l) 
{
   //////////////// Adjust for LF / L /////////////////
   
   if (l == 'L')
   {
   if ((FL_g_val < (sens_TH[0])) && black_detect == 0)  
   {black_detect = 1; return 0;}
   
   else if ((FR_g_val < (sens_TH[1])) && black_detect == 1) 
   {black_detect = 0; return 1;}
   
   //else if ((FL_g_val > sens_TH[0]) && (FR_g_val > sens_TH[1]) && black_detect == 2)
   //{black_detect = 0; return 1;}
   
   else return 0;
   }
   
   //////////////// Adjust for RF / R /////////////////
   
   if (l == 'R')
   {
   if ((FR_g_val < (sens_TH[1])) && black_detect == 0)
   {black_detect = 1; return 0;}
   
   else if ((FL_g_val < (sens_TH[0])) && black_detect == 1)  
   {black_detect = 0; return 1;}
   
   //else if ((FL_g_val > sens_TH[0]) && (FR_g_val > sens_TH[1]) && black_detect == 2)
   //{black_detect = 0; return 1;}
   
   else return 0;
   }
}
//////////////////// CI Detect /////////////////////////////

void CI_detect()
{
   int P2L_val = get_P2L_sensor_values();
   int P2R_val = get_P2R_sensor_values();

   //Serial.print(P2L_val);
   //Serial.print(" | ");
   //Serial.println(P2R_val);
     
   if (P2L_val < sens_TH[10] && P2R_val < sens_TH[11]) 
   {    
     flag_cnt++;
     delay_CI_detect = 0;
     
     //Serial.print("P2L: ");
     //Serial.print(P2L_val);
     //Serial.print("< ");
     //Serial.print(sens_TH[10]);
     
     //Serial.print(" | P2R: ");
     //Serial.print(P2R_val);
     //Serial.print("< ");
     //Serial.println(sens_TH[11]);
     
     //Serial.print("Flag Cnt: ");
     //Serial.println(flag_cnt);
     //Serial.print("Flag Avoid: ");
     //Serial.println(flag_avoid);
     
     if (flag_cnt == flag_avoid)
     black_detect = 2;
   }
    
   if (black_detect == 2)
   {
     black_detect = 0;
     
     if (last_dir == F) 
     dir_flag = 0;
     
     if (last_dir == RF || last_dir == RIGHT) 
     {set_pend('L'); dir_flag = 0;}
    
     if (last_dir == LF || last_dir == LEFT || last_dir == B) 
     {set_pend('R'); dir_flag = 0;}
}}
       
//////////////////// Call Functions ////////////////////

void set_call(char c)
{
  if (c == 'L') call = 'L'; 
  if (c == 'R') call = 'R';
  if (c == 'B') call = 'B'; 
  if (c == 'W') call = 'W';
  if (c == 'X') call = 'X'; 
  if (c == 'Y') call = 'Y';
  if (c == 'Z') call = 'Z'; 
  if (c == 'N') call = 'N';
}

char get_call() {return call;}

//////////////////// Pending Functions /////////////////

void set_pend(char p)
{
  if (p == 'L') pend = 'L'; 
  if (p == 'R') pend = 'R';
  if (p == 'B') pend = 'B'; 
  if (p == 'W') pend = 'W';
  if (p == 'X') pend = 'X';
  if (p == 'Y') pend = 'Y'; 
  if (p == 'Z') pend = 'Z';
  if (p == 'N') pend = 'N';
}

char get_pend() {return pend;}

///////////////////// Direction Functions ///////////////

void forward ()
{ 
   int FR_val = get_FR_sensor_values();
   int FL_val = get_FL_sensor_values();
    
   if (FR_val > sens_TH[1] && FL_val < sens_TH[0])
   left_less_than_right_forward();
   
   if (FR_val < sens_TH[1] && FL_val > sens_TH[0])
   left_greater_than_right_forward();
   
   if (FR_val < sens_TH[1] && FL_val < sens_TH[0])
   left_greater_than_right_forward();
   
   if (FR_val > sens_TH[1] && FL_val > sens_TH[0])
   left_less_than_right_forward();  //
}
  
void DTURN_LF()
{
   state = LF;
    last_dir = LF;
 
    pulse_width_left = p_left - DIAG_ROTATE_SPEED;
    pulse_width_right = p_right - DIAG_ROTATE_SPEED;   
    pulse_width_back = p_back - DIAG_ROTATE_SPEED;
    pulse_width_forward = p_forward - DIAG_ROTATE_SPEED;
}

void DTURN_RF()
{
    state = RF;
    last_dir = RF;
    
    pulse_width_left = p_left + DIAG_ROTATE_SPEED;
    pulse_width_right = p_right + DIAG_ROTATE_SPEED;   
    pulse_width_back = p_back + DIAG_ROTATE_SPEED;
    pulse_width_forward = p_forward + DIAG_ROTATE_SPEED;// - 1;

}

int corr_LF()
{
  DTURN_LF();
  
  int FR_val = get_FR_sensor_values();
  int FL_val = get_FL_sensor_values();
    
  if (FL_val < sens_TH[0] && black_detect == 0)  
     black_detect = 1;
 
  if (FR_val < sens_TH[1] && black_detect == 1)  
     black_detect = 2;
   
   if (FR_val > sens_TH[1] && black_detect == 2)  
   {
     black_detect = 0;
     return 1;
   }
}

int corr_RF()
{
  DTURN_RF();
  
  int FR_val = get_FR_sensor_values();
  int FL_val = get_FL_sensor_values();
 
  if (FR_val < sens_TH[1] && black_detect == 0)  
     black_detect = 1;
 
  if (FL_val < sens_TH[0] && black_detect == 1)  
     black_detect = 2;
     
  if (FL_val > sens_TH[0] && black_detect == 2)  
   {
     black_detect = 0;
     return 1;
   }
}

int DI_F_LF()
{
  d_DT++;
   
  if (d_DT > 20) 
   {
   int FR_val = get_FR_sensor_values();
   int FL_val = get_FL_sensor_values();
    
   if (FL_val < sens_TH[0] && black_detect == 0)  
     black_detect = 1;
 
  if (FR_val < sens_TH[1] && black_detect == 1)  
   {
     black_detect = 0;
     return 1;
   }}}

int DI_F_RF()
{
  d_DT++;
   
  if (d_DT > 20) 
   {
   int FR_val = get_FR_sensor_values();
   int FL_val = get_FL_sensor_values();
  
   if (FR_val < sens_TH[1] && black_detect == 0)  
   black_detect = 1;

   if (FL_val < sens_TH[0] && black_detect == 1)
   {  
   black_detect = 0;
   return 1;
   }}}

void reset_delay_counters()
{
    d_DT = 0;
    delay_detect = 0;
    delay_CI_detect = 0;
    flag_avoid = 0;
    flag_cnt = 0;
    lf_ok = 1;
    adjust_ctr = 0;
    black_detect = 0;
    l_dturn = 1;
    repeat_cnt = 1;
    flag_wait = 0;
    begin_diag = 0;
} 

  
int get_FL_sensor_values()
{ 
   int FL_val = analogRead(data_in);
   return FL_val;
}

int get_FR_sensor_values()
{ 
   int FR_val = analogRead(data_in2);
   return FR_val;
}


int get_P2L_sensor_values()
{
   int P2L_val = analogRead(a4);
   return P2L_val;
}

int get_P2R_sensor_values()
{
   int P2R_val = analogRead(a5);
   return P2R_val;
}
   
void left_less_than_right_forward()
{
  pulse_width_forward = p_forward - DIAG_ROTATE_CORR;  // Sensors on Right
  pulse_width_back = p_back - DIAG_ROTATE_CORR;
  pulse_width_left = p_left + w_val;
  pulse_width_right = p_right - w_val;
}

void left_greater_than_right_forward()
{
  pulse_width_forward = p_forward + DIAG_ROTATE_CORR;  // Sensors on Right
  pulse_width_back = p_back + DIAG_ROTATE_CORR;
  pulse_width_left = p_left + w_val;
  pulse_width_right = p_right - w_val; 
}

void pulse_zero()
{
   pulse_width_left = p_left;
   pulse_width_right = p_right;
   pulse_width_back = p_back;
   pulse_width_forward = p_forward;
}

void pre_pending()
{
     if (pre_ad == 0)
     {
     if (state == LF)
     {
     DTURN_RF();
     state = LF;
     
     ////////////LF Adjustment for RF, RIGHT and LB //////////////
     
     if (dir_flag == 7 || dir_flag == 4 || dir_flag == 6)  // RF
     {
     int FL_val = get_FL_sensor_values();
     int FR_val = get_FR_sensor_values();
     if (FL_val < sens_TH[0] && FR_val > sens_TH[1])
     pre_ad = 1;
     }
     
     /////////No Adjustment for B, LF, LEFT, RB ////////////
    
     if (dir_flag == 2 || dir_flag == 5 || dir_flag == 3 || dir_flag == 8)
     pre_ad = 1;
     }
     
     if (state == RF)
     {
     DTURN_LF();
     state = RF;
      
     ////////////RF Adjustment for B, LF, LEFT, RB //////////////
     
     if (dir_flag == 2 || dir_flag == 5 || dir_flag == 3 || dir_flag == 8)  // LF
     {
     int FL_val = get_FL_sensor_values();
     int FR_val = get_FR_sensor_values();
     if (FL_val > sens_TH[0] && FR_val < sens_TH[1])
     pre_ad = 1;
     }
     
     /////////No Adjustment for RF, RIGHT and LB ////////////
     if (dir_flag == 7 || dir_flag == 4 || dir_flag == 6)
     pre_ad = 1;
     }
     }
     
     if (pre_ad == 1)
     {
     pulse_zero();
     pre_ctr++;
     
     if (pre_ctr > 40)
     {
     pre_ctr = 0;
     begin_diag = 1;
     pre_ad = 0;
     }    
     }
}

void reset_c_counters()
{
     c_cnt = 0;
     calib_turn = 0;
     dir_flag = 50;
}

void orig_dest(char inB)
{
    int val_pos;
    comp_flag = 1;
    val_pos = num_to_pos();
    Serial.print(inB);
    pos_to_num(val_pos);
    comp_flag = 0;
    
    if (inB == '&') {K = val_pos; Serial.print("Origin="); Serial.println(K);}
    if (inB == '?') {L = val_pos; Serial.print("Dest="); Serial.println(int(L));}  
}   
/////////////// Chess Code //////////////////////

int D(int k, int q, int l, int e, int E, int z, int n)      
{ // k = side to move, E = en passant square, e= evaluation                       
 int j,r,m,v,d,h,i,F,G,s;
 char t,p,u,x,y,X,Y,H,B;
 
 q--;                                          
 d=X=Y=0;                                      

 W(d++<n||                                     
   z==8&K==I&&(N<d_lim&d<98||                    
   (K=X,L=Y&~M,d=2)))                          
 {
  x=B=X;                                       
  h=Y&S;                                   
  
  m=d>1?-I:e;   // m = Score of best move so far                                  
  
  N++;          // N = counter of searched nodes                                       
  
  ///////////////////////////////////////////////
  do{         // Loop over Pieces
   u=b[x];
   
   if(u&k)    // If own piece                                
   {
    r=p=u&7;   // Extract piece type int r
    
    j=o[p+16];  // Look up first direction it moves in directory
    
    /////////////////////////////////////////////////    
    W(r=p>2&r<0?-r:-o[++j])  // Loop over directions                   
    {
     A: y=x;
        F=G=S;                                
    
     ///////////////////////////////////////////////////////////////// 
     do{  /// Loop over all squares in that direction while no capture                                   
      
      /*Serial.print("y: ");
      Serial.print((int)y);*/
      
      H=y=h?Y^h:y+r;                        
     
      /*if (r == -16) Serial.print("  r: "), Serial.print(r), Serial.print("  | "), Serial.print((int)y);
      else if (r == -15) Serial.print("  r: "), Serial.print(r), Serial.print("  / "), Serial.print((int)y);
      else if (r == -17) Serial.print("  r: "), Serial.print(r), Serial.print("  \\ "), Serial.print((int)y);
      else Serial.print("  r: "), Serial.print(r), Serial.print("  "), Serial.print((int)y);*/
      
      if(y&M) // If edge of board is hit
      {
      //Serial.print("   [Off Board]\n");  
      break;   // Break out of square loop, go to next direction                     
      }
      
      m=E-S&&b[E]&&y-E<2&E-y<2?I:m;    /* castling-on-Pawn-check bug fixed */
      
      if(p<3&y==E)H^=16;                       
      
      t=b[H];
      
      if(t&k)
      {
       //Serial.print("   [Own Piece]\n");
       break;  // Break out of square loop, go to next direction      
      }
      
      if(p<3&!(y-x&7)-!t)
      {
       //Serial.print("   [Pawn move forbidden]\n");
       break;  // Break out of square loop, go to next direction 
      }
      
      //Serial.println();
      
      i=99*w[t&7];          
      
      m=i<0?I:m;                       /* castling-on-Pawn-check bug fixed */
      if(m>=l)goto C;                          

      if(s=d-(y!=z))                           
      {
       v=p<6?b[x+8]-b[y+8]:0;
       b[G]=b[H]=b[x]=0;b[y]=u|32;       
       
       if(!(G&M))b[F]=k+6,v+=30;               
       if(p<3)                                 
       {
        v-=9*((x-2&M||b[x-2]-u)+               
              (x+2&M||b[x+2]-u)-1);            
        if(y+r+1&S)b[y]|=7,i+=C;               
       }
       v=-D(24-k,-l,m>q?-m:-q,-e-v-i,F,y,s);   
       if(K-I)                                 
       {if(v+I&&x==K&y==L&z==8)                
        {Q=-e-i;O=F;
         if(b[y]-u&7&&P-c>5)b[y]-=c[4]&3;        /* under-promotions */
         return l;
        }v=m;                                   
       }                                       
       b[G]=k+6;b[F]=b[y]=0;b[x]=u;b[H]=t;     
       if(v>m)                         
        m=v,X=x,Y=y|S&F;                       
       if(h){h=0;goto A;}                            
      }
      if(x+r-y|u&32|                           
         p>2&(p-3|j-7||                        
         b[G=x+3^r>>1&7]-k-6                   
         ||b[G^1]|b[G^2])                      
        )t+=p<5;                               
      else F=y;                                
     }W(!t);                                   
  }}}W((x=x+9&~M)-B);                          
C:if(m>I-M|m<M-I)d=98;                         
  m=m+I?m:-D(24-k,-I,I,0,S,S,1);    
 }       
  
 return m+=m<e;                                
}

void draw_table()
{
   Serial.println();
   for(int i=0; i<8; i++) 
   {Serial.print("  ");Serial.print(c_ID[i]);}
   Serial.println();
   
   int i = 7;
   //Serial.print("8");
   
   N=-1;
   W(++N<121)
   {
   int pic = (N&8&&(N+=7)?10:n[b[N]&15]);
   Serial.print("  ");
   Serial.print(char(pic));
   if (pic == 10 && i>0){Serial.print(char(i)); i--;};
   }
   //Serial.print("Your move: ");*/
}

void poll(int poll_dir)
{   
   if (poll_dir == 1) poll_ctr--;
   
   /*if (c_ID[poll_ctr] == 'l') // Own -> King
   {
   {boot_me = 1; dir_flag = 1;}
   if (poll_dir == 1) {boot_me = 2; dir_flag = 2;}
   } */
   
   //else 
   //{
   Serial.print("~");
   Serial.print(c_ID[poll_ctr]);
   //}
   
   dir_flag = 99;
}  

/****************** 0. ROBOT PLAY ************************/

void robot_play()
{   
    delay(1000);
     
    k = 8;
    K = I;
    D(k,-I,I,Q,O,8,2);
    draw_table();
          
    delay(1000);
    set_stage('K');
}
    
/****************** 1. CALL PIECE ************************/

void call_piece()
{  
   //int p_found = 0;
  
   for (int i= 0; i<16; i++){
   if (c_pos[i]== K)
   {
    //p_found = 1;  
    
    if (c_ID[i] == 'j')
    {knight = 1;} 
     /*if (knight_adj == 1) boot_left();*/
    
    if (c_ID[i] == 'o')
    {knight = 1;} 
     /*if (knight_adj == 1) boot_right();*/
    
    //if (knight_adj == 0)
    //{
    curr_p_ID = c_ID[i]; 
    Serial.print("_");
    Serial.print(curr_p_ID);
    //}
}
 
   /////////// If Destination is an Opponent ////////////
    if (h_pos[i]== L)
   {
    h_pos[i] = 100;
    flag_kill = 1;
   }
   //////////////////////////////////////////////////////
}
   
  // if (knight_adj == 0)
   //{
   //if (p_found == 0) no_piece = 1;
   send_direction();
  // }
}

/*************** 2. SEND DIRECTION ************************/

void send_direction() // Send K for Knight
{
   
   move_diff=(K>L)?(K-L):(L-K);

   if (move_diff > 8 && knight != 1)
   {
   if (move_diff % 16 == 0) // Straight
   {
   if (K > L) {curr_dir_ID = '1'; Serial.print("1");} // F
   if (K < L) {curr_dir_ID = '2'; Serial.print("2");} // B
   curr_step_ID = move_diff / 16;
   }

   else if (move_diff % 15 == 0) // Turn Left 
   {
   if (K > L) {curr_dir_ID = '7'; Serial.print("7");} // RF
   if (K < L) {curr_dir_ID = '8'; Serial.print("8");} // RB
   curr_step_ID = move_diff / 15;
   }

   else if (move_diff % 17 == 0) // Turn Right
   {
   if (K > L) {curr_dir_ID = '5'; Serial.print("5");} // LF
   if (K < L) {curr_dir_ID = '6'; Serial.print("6");} // LB
   curr_step_ID = move_diff / 17;
   }}

   else if (move_diff < 8 && knight != 1)
   {
   if (K > L) {curr_dir_ID = '3'; Serial.print("3");} // L
   if (K < L) {curr_dir_ID = '4'; Serial.print("4");} // R
   curr_step_ID = move_diff;
   }
   
   else if (knight == 1) pos_to_num(K);
   
   send_step();
}

/******************* 3. SEND STEP ************************/

void send_step() // Send L for Knight
{
   if (knight != 1 && no_piece != 1)
   Serial.print(curr_step_ID);
   
   if (flag_kill == 1) send_kill();
}

/*****************4. Send Kill *******************************/

void send_kill() // Send L for Knight
{
   Serial.println(".");   
}

//////////////// Robot Attack Check ///////////////////////////

int robot_atk_chk()
{
  for (int i=0; i<16; i++)
  if (c_pos[i] == L) {curr_p_ID = c_ID[i]; return 1;}
 
return 0;
}
//////////////// Update Human Map ///////////////////////////

void u_H_map()
{
  for (int i= 0; i<16; i++){
   if (h_pos[i] == K) h_pos[i] = L;
  }
  
  /*for (int i= 0; i<16; i++){
  Serial.print(h_pos[i]);
  Serial.print(" ");
  }*/
  
}
/////////////////// Send Map ////////////////////////////////

void send_map()
{
int pc_val;

if (send_ctr < 16)
{  
 curr_p_ID_map = c_ID[send_ctr]; 
 pc_val = c_pos[send_ctr];
 Serial.print("(");
 Serial.print(curr_p_ID);
 Serial.print(curr_p_ID_map);
 pos_to_num(pc_val);
}

 if (send_ctr == 16) 
 { 
 send_ctr = 0;

 if (stage == '(') 
 {
 if (piece_quit == 1) set_stage('{');
 else set_stage(')');
 }
 }}

///////////////// Re-Confirm KL_Comp //////////////////////////////////

void reconfirm_k_comp()
{
 if(K_recvd == K) {call_OK(); set_stage('l');}
 else call_RETRY();
}

void reconfirm_l_comp()
{
 if(L_recvd == L) 
 {call_OK(); comp_flag = 0; 
  if (flag_kill == 0) set_stage(':');
  if (flag_kill == 1) {flag_kill = 0; set_stage('x');}
 }
 else call_RETRY();
}

///////////////// Re-Confirm Map //////////////////////////////////

void reconfirm_map(char p_ID)
{
  if (p_ID==curr_p_ID_map && curr_P_recvd == c_pos[send_ctr]){
  call_OK(); send_ctr++; send_map();}
  
  else call_RETRY();   
}

 ///////////////// Re-Confirm Move //////////////////////////////////

 void reconfirm_move(char p_ID_recvd, char dir_ID_recvd, char step_ID_recvd)
 {
 ////////////////// STAGE K ////////////////////////
 
 if (stage == 'K'){
 if (p_ID_recvd == curr_p_ID)
 {
 if(p_ID_recvd == 'j' || p_ID_recvd == 'o'){
 if(K_recvd == K) set_stage('L');
 else call_RETRY();
 }
  
 if (p_ID_recvd != 'j' && p_ID_recvd != 'o')
 {
  if (curr_dir_ID == dir_ID_recvd && 
  curr_step_ID == char_to_int(step_ID_recvd))
  {
  if (flag_kill == 0) {call_OK(); u_R_map(); set_stage('@');}  
  if (flag_kill == 1) 
  {if (kill_ID == '.') {call_OK(); u_R_map(); set_stage('@');}
   else call_RETRY();}
   //if (knight_adj == 1) {set_stage('^'); call_piece(); knight_adj = 0;}
  }
  else call_RETRY();
 }}}
 
 ////////////////// STAGE L ////////////////////////
 
 if (stage == 'L'){
 if (p_ID_recvd == 'L' && L_recvd == L) 
 {
  if (flag_kill == 0) {call_OK(); set_stage('(');}  
  
  if (flag_kill == 1)  
  {
  kill_ID = Serial.read(); 
  if (kill_ID == '.') {call_OK(); set_stage('(');}
  else call_RETRY();
  }
 }
 else call_RETRY();
 }
 }

//////////////// UPDATE ROBOT MAP ///////////////////

void u_R_map()
{
  for (int i= 0; i<16; i++){
   if (c_pos[i]== K) c_pos[i] = L;
  }
  
 /* for (int i= 0; i<16; i++){
   Serial.print(c_pos[i]);
   Serial.print(" ");
  }*/
}

//////////////// THROW PIECE OFF BOUNDS ///////////////////

void out_bound()
{
  for (int i= 0; i<16; i++){
   if (c_ID[i]== curr_p_ID) c_pos[i] = 200;
  }
  
 /* for (int i= 0; i<16; i++){
   Serial.print(c_pos[i]);
   Serial.print(" ");
  }*/
}

/********************** THINK BLINK ************************/
void think_blink()
{
  //pulse_zero();
  
  int blink_ctr_val;
  
  //if (flag_kill == 1) blink_ctr_val = 1000;
  blink_ctr_val = 10;
  
  if (blink_ctr < blink_ctr_val)
  {
  if (wait(20) == 1)
  {
  if ((blink_ctr % 2) == 0)  simple(2,2,1);
  else simple(1,2,0);
  blink_ctr++;
  }}
  
  if (blink_ctr == blink_ctr_val) {blink_ctr = 0; dir_flag = 50;}
}

////////////////// SET_STAGE ////////////////////////

void set_stage(char stg)
{
  /* Blocking Piece Adjust Stage */
  if (stg == '[') {stage = '['; attach_timer('['); direct_blocking_pc();}

  /* Go Ahead for Piece Direct Stage */
  if (stg == ']') {stage = ']'; attach_timer(']'); Serial.print("]");}
   
  /* Free Go for Knight */
  if (stg == '=') {stage = '='; attach_timer('='); Serial.print("=");}
  
  /* PIECE + KNIGHT STAGE [K, @] */
  if (stg == 'K') {stage = 'K'; attach_timer('_'); call_piece();}
  
  /* KNIGHT ONLY STAGE [L, @] */
  if (stg == 'L') {stage = 'L'; attach_timer('_'); send_L();}
  
  /* KNIGHT MAP STAGE [(,)] */
  if (stg == '(') {stage = '('; attach_timer('('); send_map();}
  
  /* GO QUIT PIECE */
  if (stg == '{') {stage = '{'; attach_timer('{'); send_quit();}
 
  /* Human Input Error Stage */
  if (stg == '/') {stage = '/'; attach_timer('/'); Serial.write('/');}
 
  //////////////// COMPLETE STAGES /////////////////////
    
  /* PIECE ONLY STAGE (MOVE COMPLETE - SEND GO) */
  if (stg == '@') {stage = '@'; attach_timer('@'); Serial.print("@");}
  if (stg == ',') {stage = ','; attach_timer(','); Serial.print(",");}
  
  /* SEND MAP COMPLETE STAGES */ 
  if (stg == ')') {stage = ')'; attach_timer(')'); Serial.print(")");} // KNIGHT MAP COMPLETE
  
  /* Comp-King Stage */
  // Human has quit from Comp //
  if (stg == ';') {stage = ';';}
  
  // Request Human to get out from King //
  if (stg == '!') {stage = '!'; attach_timer('!'); send_l_comp();}
 
  // Send K and L to Comp //
  if (stg == 'k') {stage = 'k'; attach_timer('k'); send_k_comp();}
  if (stg == 'l') {stage = 'l'; attach_timer('l'); send_l_comp();}
 
  // Notify when flag_kill == 0 //
  if (stg == ':') {stage = ':'; attach_timer(':'); Serial.write(':');}
  
  // Notify when flag_kill == 1 //
  if (stg == 'x') {stage = 'x'; attach_timer('x'); Serial.write('x');}
  
  /* Poll by King to have pieces return to start positions */
  if (stg == '~') {stage = '~'; Serial.print("~");/*attach_timer('~'); simple(2,2,1); poll(1);*/}
  
  /* Robot Play */
  if (stg == '*') {stage = '*'; simple(1,2,0); robot_play(); dir_flag = 50;}
} 

////////////////// TIMER_FUNCS ////////////////////////

///////// ATTACH A_TIMER ///////////

void attach_timer(char s_sym)
{
  h_input = 0;
  
  if (s_sym == '_') a_timer_sym = '_'; // Robot Moves
  if (s_sym == '(') a_timer_sym = '('; // Quit Moves
  if (s_sym == ')') a_timer_sym = ')'; // Quit Moves
  if (s_sym == ';') a_timer_sym = ';'; // Notify Comp
  if (s_sym == '@') a_timer_sym = '@'; // Send Go
  if (s_sym == ',') a_timer_sym = ','; // Tell piece that human outbounded 
  if (s_sym == '!') a_timer_sym = '!';
  if (s_sym == ':') a_timer_sym = ':';
  if (s_sym == '~') a_timer_sym = '~'; // Poll Pieces
  if (s_sym == 'k') a_timer_sym = 'k';
  if (s_sym == 'l') a_timer_sym = 'l'; // Poll Pieces
  if (s_sym == 'x') a_timer_sym = 'x'; // Poll Pieces
  if (s_sym == '[') a_timer_sym = '['; // Blocking Piece Direction Data Exchange
  if (s_sym == ']') a_timer_sym = ']'; // Blocking Piece Direct
  if (s_sym == '=') a_timer_sym = '='; // Go Knight you are free
  if (s_sym == '{') a_timer_sym = '{'; // Quit piece
  if (s_sym == '/') a_timer_sym = '/'; // Human Input Error Stage
}

///////////////// Timer Code ///////////////////

void timer_check()
{
  timer++;
  if (timer > 100)
  call_RETRY();
}
 
///////////////// SEND k_comp /////////////////////////////
 
 void send_k_comp() 
 {comp_flag = 1; Serial.write('^'); Serial.write('k'); pos_to_num(K);}
 
///////////////// SEND l_comp /////////////////////////////
 
 void send_l_comp() 
 {comp_flag = 1; Serial.write('^'); Serial.write('l'); pos_to_num(L);}

///////////////// SEND L /////////////////////////////
 
 void send_L() {Serial.print("_"); Serial.print("L"); pos_to_num(L);}
 
 ///////////////// CALL OK ////////////////////////
 
 void call_OK() {Serial.println("OK"); timer = 0; delay(1000);}
 
 ///////////////// CALL RETRY ////////////////////////
  
 void call_RETRY() {
 timer = 0;
 delay(1000);
 
 if (stage == 'K') call_piece();
 if (stage == 'L') send_L();
 if (stage == '(') send_map();
 if (stage == ')') Serial.print(")");
 
 if (stage == '{') send_quit(); // Go Quit
  
 if (stage == ';') Serial.print(";");
 if (stage == '@') Serial.print('@');
 if (stage == ',') Serial.print(',');
 
 if (stage == '!') send_l_comp();
 if (stage == ':') Serial.print(":");
 /*KKMOD-19/12/14 
 We Dont need to do the exercise of polling back each piece for now
 if (stage == '~') poll(-1);*/
 
 if (stage == 'k') send_k_comp();
 if (stage == 'l') send_l_comp();
 
 if (stage == '[') direct_blocking_pc();
 if (stage == ']') Serial.print("]");
 
 if (stage == '=') Serial.print("=");
 
 if (stage == '/') Serial.write('/');
 if (stage == 'x') Serial.write('x');
 }
 
////////////////// Send Quit //////////////////////

void send_quit()
{
Serial.print("{");
Serial.print(curr_p_ID);
}

///////////////// Adjust Blocking Piece ///////////////

void adj_blocking_pc()
{
 for (int i=0; i<16; i++)
 {
 if (blocking_pc == c_pos[i]) 
 {curr_b_ID = c_ID[i]; 
  curr_b_pos = c_pos[i];
  set_stage('['); // Start directing Blocking Piece
 }  
 } 
}

///////////////// Direct Blocking Piece ///////////////

void direct_blocking_pc()
{
 Serial.print("[");
 Serial.print(curr_b_ID);
 if (adj_pc_ctr == 0) Serial.print("11"); 
 if ((adj_pc_ctr == 1) || (adj_pc_ctr == 2)) 
 {adj_pc_ctr = 2; Serial.print("12");}  
}

///////////////// Reconfirm Blocking Dir ///////////////

void reconfirm_b_dir()
{
 char b_ID_recvd = Serial.read();
 char b_dir_recvd = Serial.read();
 char b_step_recvd = Serial.read();
 
 if (b_ID_recvd == curr_b_ID && b_dir_recvd == '1')
 {
  if(adj_pc_ctr == 0){
   if (b_step_recvd == '1'){call_OK(); adj_pc_ctr = 1; set_stage(']');}
   else call_RETRY();
  }
  
  if(adj_pc_ctr == 2){
  if (b_step_recvd == '2'){call_OK(); adj_pc_ctr = 0; set_stage(']');}
  else call_RETRY();
  } 
 }
 
 else call_RETRY();
}

///////////////// Serial Value -> Pos ////////////////////////

 int num_to_pos()
 {
    char p_len = Serial.read();
    int pc_len;
    int p_pos;
    int di_1, di_2, di_3;
  
    if (p_len == '1') pc_len = 1;
    if (p_len == '2') pc_len = 2;
    if (p_len == '3') pc_len = 3;
      
    if (pc_len == 1 || pc_len == 2 || pc_len == 3)
    {
    char digit1 = Serial.read();
    di_1 = char_to_int(digit1);
    p_pos = di_1;
    }
    
    if (pc_len == 2 || pc_len == 3)
    {
    char digit2 = Serial.read();
    di_2 = char_to_int(digit2);
    p_pos = di_1 * 10 + di_2;
    }
    
    if (pc_len == 3)
    {
    char digit3 = Serial.read();
    di_3 = char_to_int(digit3);
    p_pos = di_1 * 100 + di_2 * 10 + di_3;
    }
    
    return p_pos;
  }

 ///////////////// Pos -> Serial ////////////////////////

 void pos_to_num(int pc_val) 
 {
 int pc_len;
 int p_pos;
 int di_1, di_2, di_3, di_inter;
  
 if (pc_val < 10) 
 {
 pc_len = 1;
 print_len(pc_len);
 di_1 = pc_val;
 print_d1(di_1);
 Serial.println();
 }
 
 if (pc_val >= 10 && pc_val < 100) 
 {
 pc_len = 2;
 print_len(pc_len);
 di_1 = pc_val / 10;
 di_2 = pc_val % 10;
 print_d1(di_1); 
 print_d2(di_2);
 Serial.println();
 }
 
 if (pc_val >= 100) 
 {
 pc_len = 3;
 print_len(pc_len);
 di_1 = pc_val / 100;
 di_inter = pc_val % 100;
 di_2 = di_inter / 10;
 di_3 = di_inter % 10; 
 print_d1(di_1); 
 print_d2(di_2);
 print_d3(di_3);
 Serial.println();
 }}

void print_len(int pc_len)
{
 if (comp_flag == 0) Serial.print(pc_len);
 if (comp_flag == 1) Serial.write(pc_len);
}
 
void print_d1(int di_1)
{
 if (comp_flag == 0) Serial.print(di_1);
 if (comp_flag == 1) Serial.write(di_1);
}

void print_d2(int di_2)
{
 if (comp_flag == 0) Serial.print(di_2);
 if (comp_flag == 1) Serial.write(di_2);
}

void print_d3(int di_3)
{
 if (comp_flag == 0) Serial.print(di_3);
 if (comp_flag == 1) Serial.write(di_3);
}

///////////////// Char -> Int ////////////////////////

int char_to_int(char digit)
{
 if (digit == '0') return 0;
 if (digit == '1') return 1;
 if (digit == '2') return 2;
 if (digit == '3') return 3;
 if (digit == '4') return 4;
 if (digit == '5') return 5;
 if (digit == '6') return 6;
 if (digit == '7') return 7;
 if (digit == '8') return 8;
 if (digit == '9') return 9;
}

/////////////// OutBound Piece //////////////////
  
void obound_p_ID(char p_ID)
{
  for (int i= 0; i<16; i++)
  if (p_ID == c_ID[i]) c_pos[i]= 200;
}

/////////////// Wait Time /////////////////////

int wait(int l_time)
{
  line_time++;
  if (line_time <= l_time) return 0;
  else 
  {line_time = 0; return 1;}
}

