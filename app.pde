import processing.net.*;

Server s; 
Client c;
String inp;
String dat[];
int  machine_state = 0;

import processing.serial.*;
PImage img,img1;
import controlP5.*;
ControlP5 cp5;
int x=0;

String[] textfieldNames = {"tf1"};


Serial serial_port = null;        // the serial port
int y=0;
// serial port buttons
Button btn_serial_up;              // move up through the serial port list
Button btn_serial_dn;              // move down through the serial port list
Button btn_serial_connect;         // connect to the selected serial port
Button btn_serial_disconnect;      // disconnect from the serial port
Button btn_serial_list_refresh;    // refresh the serial port list
String serial_list;                // list of serial ports
int serial_list_index = 0;         // currently selected serial port
int num_serial_ports = 0;          // number of serial ports in the list
String val="Welcome";
String val1="Enter Value";
int servo;

void setup() {
  // set the window size
  size (680, 550);
  PFont font = createFont("arial",20);

  cp5 = new ControlP5(this);
 s = new Server(this, 8080);  // Start a simple server on a port
  int y = 20;
  int spacing = 60;
  for(String name: textfieldNames){
    cp5.addTextfield(name)
       .setPosition(500,220)
       .setSize(100,40)
       .setFont(font)
       .setFocus(true)
       .setColor(color(255,0,0))
       ;
     y += spacing;
  }

  textFont(font);

  // create the buttons
  btn_serial_up = new Button("^", 450, 20, 30, 30);
  btn_serial_dn = new Button("v", 450, 80, 30, 30);
  btn_serial_connect = new Button("Connect", 500, 20, 100, 25);
  btn_serial_disconnect = new Button("Disconnect", 500, 50, 100, 25);
  btn_serial_list_refresh = new Button("Refresh", 500, 80, 100, 25);

  // get the list of serial ports on the computer
  serial_list = Serial.list()[serial_list_index];

  //println(Serial.list());
  //println(Serial.list().length);

  // get the number of serial ports in the list
  num_serial_ports = Serial.list().length;

  try
  {
    console = new Console();
  }
  catch(Exception e)
  {
  }
background(0);



}



char getClient(){
    c = s.available();
  if (c != null) {
    inp = c.readString();
    dat = inp.split("=");
    stroke(0);
    if(dat != null){
    try{
      println(dat[1]);
      s.disconnect(c);
      return dat[1].charAt(0);
    }catch(Exception e){
      println("error");
    }
  }
    s.disconnect(c);
  }
  return 'x';
}





void mousePressed() {
  // up button clicked
  if (btn_serial_up.MouseIsOver()) {
    if (serial_list_index > 0) {
      // move one position up in the list of serial ports
      serial_list_index--;
      serial_list = Serial.list()[serial_list_index];
    }
  }
  // down button clicked
  if (btn_serial_dn.MouseIsOver()) {
    if (serial_list_index < (num_serial_ports - 1)) {
      // move one position down in the list of serial ports
      serial_list_index++;
      serial_list = Serial.list()[serial_list_index];
    }
  }
  // Connect button clicked
  if (btn_serial_connect.MouseIsOver()) {
    if (serial_port == null) {
      // connect to the selected serial port
      serial_port = new Serial(this, Serial.list()[serial_list_index], 9600);
    }
    
  machine_state = 1;  
  }
  // Disconnect button clicked
  if (btn_serial_disconnect.MouseIsOver()) {
    if (serial_port != null) {
      // disconnect from the serial port
      serial_port.stop();
      serial_port = null;
    }
  }
  // Refresh button clicked
  if (btn_serial_list_refresh.MouseIsOver()) {
    // get the serial port list and length of the list
    serial_list = Serial.list()[serial_list_index];
    num_serial_ports = Serial.list().length;
  }
}

void moveBot(char key){
  if (key == 'w')
  {
     serial_port.write('w');
     val="Forward";
     x=1;
     delay(250);
     x=0;
     serial_port.write('W');
  }
  if (key == 'd' && x==0)
  {  
     x=1;
     serial_port.write('w');
     val="Forward";
     delay(100);
     serial_port.write('d');
     val="Left";
     delay(500);
     serial_port.write('w');
     val="Forward";
     delay(100);
     x=0;
     serial_port.write('W');
  }
 if (key == 's' && x==0)
 {
     serial_port.write('s');
     val="Back";
     x=1;
     delay(500);
     x=0;
     serial_port.write('W');
 }
 if (key == 'a' && x==0)
 {
     x=1;
     serial_port.write('w');
     val="Forward";
     delay(100);
     serial_port.write('a');
     val="Right";
     delay(500);
     serial_port.write('w');
     val="Forward";
     delay(100);
     x=0;
     serial_port.write('W');
 }  
}

void draw() {
  // draw the buttons in the application window
  btn_serial_up.Draw();
  btn_serial_dn.Draw();
  btn_serial_connect.Draw();
  btn_serial_disconnect.Draw();
  btn_serial_list_refresh.Draw();
  // draw the text box containing the selected serial port
  DrawTextBox("Select Port", serial_list, 20, 20, 400, 100);
  DrawTextBox1("Movement",val,20,200,120,80);
  DrawTextBox1("Speed",val1,170,200,120,80);
  control();
  if(machine_state == 1){
  moveBot(getClient());
  }
}

// function for drawing a text box with title and contents
void control()
{
  fill(255);
  fill(255);
  textAlign(LEFT);
  textSize(20);
  text("Controls", 50, 300, 100, 100);
  textSize(15);
  text("w - Forward      p - Servo up", 50, 350, 400, 100);
  text("a - left              l - Servo down", 50, 370, 400, 100);
  text("d - right          + - Speed inc.", 50, 390, 400, 100);
  text("s - back           - - Speed Dec.", 50, 410, 400, 100);
  text("q - Rotate left          ", 50, 430, 400, 100);
  text("e - Rotate right          ", 50, 450, 400, 100);
  textSize(13);
}
void DrawTextBox(String title, String str, int x, int y, int w, int h)
{
  fill(255);
  rect(x, y, w, h);
  fill(0);
  textAlign(LEFT);
  textSize(10);
  text(title, x + 10, y + 10, w - 20, 20);
  textSize(10);
  text(str, x + 10, y + 40, w - 20, h - 10);
}


// button class used for all buttons
class Button {
  String label;
  float x;    // top left corner x position
  float y;    // top left corner y position
  float w;    // width of button
  float h;    // height of button

  // constructor
  Button(String labelB, float xpos, float ypos, float widthB, float heightB) {
    label = labelB;
    x = xpos;
    y = ypos;
    w = widthB;
    h = heightB;
  }
  color c = color(0, 6, 255);
  // draw the button in the window
  void Draw() {
    fill(c);
    stroke(0);
    rect(x, y, w, h, 10);
    textAlign(CENTER, CENTER);
    fill(0);
    text(label, x + (w / 2), y + (h / 2));
  }

  // returns true if the mouse cursor is over the button
  boolean MouseIsOver() {
    if (mouseX > x && mouseX < (x + w) && mouseY > y && mouseY < (y + h)) {
      return true;
    }
    return false;
  }
}
void keyPressed()
{
  if (key == 'w' && x==0)
  {
     serial_port.write('w');
     val="Forward";
     x=1;
  }
  if (key == 'd' && x==0)
  {
     serial_port.write('d');
     val="Left";
     x=1;
  }
 if (key == 's' && x==0)
 {
     serial_port.write('s');
     val="Back";
     x=1;

 }
 if (key == 'a' && x==0)
 {
    serial_port.write('a');
    val="Right";
    x=1;
 }
 if (key == '=')
    { y++;
      if(y<8)
      {
     serial_port.write('=');
     switch (y){
       case 0: val1="0";
       break;
       case 1: val1="5";
       break;
       case 2: val1="30";
       break;
       case 3: val1="60";
       break;
       case 4: val1="90";
       break;
       case 5: val1="150";
       break;
       case 6: val1="200";
       break;
       case 7: val1="255";
       break;
     }

      }
      if(y>=8)
      {
        y=7;
      }
     println(y);
    }
 if (key == '-')
 {
      if(y>=0)
      {
     serial_port.write('-');
      switch (y){
       case 1: val1="0";
       break;
       case 2: val1="5";
       break;
       case 3: val1="30";
       break;
       case 4: val1="60";
       break;
       case 5: val1="90";
       break;
       case 6: val1="150";
       break;
       case 7: val1="200";
       break;
       case 8: val1="255";
       break;

     }
     y--;

      }
      if(y<0)
      {
        y=0;
      }
        println(y);



    }
  if(key=='1')
    {
       serial_port.write('1');
       println("You have selected first servo");
       servo=1;
       img = loadImage("servo1.png");
       image(img, 350, 187,100,100);
    }
  if(key=='2')
    {
       serial_port.write('2');
       println("You have selected second servo");
       servo=2;
       img = loadImage("servo2.png");
       image(img, 350, 187,100,100);
    }
   if(key=='3')
    {
       serial_port.write('3');
       println("You have selected third servo");
       servo=3;
       img = loadImage("servo3.png");
       image(img, 350, 187,100,100);
    }
    if(key=='p')
    {
      if(servo==1)
      {
      serial_port.write('h');
      println("h");
      }
      else if(servo==2)
      {
      serial_port.write('g');
       println("g");
      }
      else if(servo==3)
      {
      serial_port.write('j');
       println("j");
      }
    }
    if(key=='l')
    {
      if(servo==1)
      {
      serial_port.write('n');
      println("n");
      }
      else if(servo==2)
      {
      serial_port.write('b');
       println("b");
      }
      else if(servo==3)
      {
      serial_port.write('m');
       println("m");
      }
    }
    if(key=='e')
    {
      serial_port.write('e');
      println("Rotating left");
      val="Rotating Left";
    }
    if(key=='q')
    {
      serial_port.write('q');
      println("Rotating right");
       val="Rotating Right";
    }
    if(key=='6')
    {
      serial_port.write('6');
      println("Opening Gate");
    }
    if(key=='7')
    {
      serial_port.write('7');
      println("Closing Gate");
    }
    if(key=='f')
    {
      serial_port.write('f');
    }
    if(key=='g')
    {
      serial_port.write('g');
    }
    if(key=='b')
    {
      serial_port.write('b');
    }

}

void keyReleased() {
   if(key=='w')
    {
     serial_port.write('W');
     val=" ";
     x=0;
    }
   if (key == 'a')
   {
     serial_port.write('W');
     val=" ";
     x=0;
   }
   if (key == 'd')
   {
     serial_port.write('W');
     val=" ";
     x=0;
   }
   if (key == 's')
   {
     serial_port.write('W');
     val=" ";
     x=0;
   }
   if (key == '=')
     serial_port.write('l');
   if (key == '-')
     serial_port.write('l');
    if(key=='p')
     serial_port.write('H');
    if(key=='l')
     serial_port.write('H');
     if(key=='q')
    {
      serial_port.write('W');
      val=" ";
    }
    if(key=='e')
    {
      serial_port.write('W');
      val=" ";
    }
   }
void DrawTextBox1(String title, String str, int x2, int y2, int w2, int h2)
{
  fill(255);
  rect(x2, y2, w2, h2);
  fill(0);
  textAlign(CENTER);
  textSize(14);
  text(title, x2 + 10, y2 + 10, w2 - 20, 20);
  textSize(15);
  text(str, x2 + 10, y2 + 40, w2 - 20, h2 - 10);
}

void controlEvent(ControlEvent theEvent) {
  if(theEvent.isAssignableFrom(Textfield.class)) {
    println("controlEvent: accessing a string from controller '"
            +theEvent.getName()+"': "
            +theEvent.getStringValue()
            );
  }
}
