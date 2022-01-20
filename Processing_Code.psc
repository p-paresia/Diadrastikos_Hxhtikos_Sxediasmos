// Libraries//

import oscP5.*;
import netP5.*;

//
OscP5 oscP5;
NetAddress myRemoteLocation;

int red =0;
int green = 0;
int blue = 0;
int movementY = 0;
int movementX = 0;

PImage img;

String imageKadinsky = "venus.jpg";

int back = #f1f1f1;
int cFill = 0;

void setup() 
{
  size(900, 900, P3D);
  img = loadImage(imageKadinsky);
  img.resize(900, 900);
  frameRate(25);
  
  // Instanciate the Objects//
  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress("127.0.0.1", 12000);
}

void draw() 
{
  background(back);
  fill(cFill);
  noStroke();
  sphereDetail(5);
  float tiles = movementX /2;
  float tileSize = width/tiles;
  push();
  translate(width/2,height/2);
  rotateY(radians(frameCount * movementY));
  
 
  push();
  if (mousePressed && mouseButton == LEFT)
  {
   back = int(random(#2d917f,#442166));
   cFill = int(random(#043814,#b53f18));
  }
  else if (mousePressed && mouseButton == RIGHT)
  {
   back = int(random(#5e1d31,#856809));
   cFill = int(random(#043814,#b53f18));
  }
  else 
  {
    back = 0; 
    cFill = 255;
  }
  pop();
  
  for (int x = 0; x < tiles; x++) 
  {
    for (int y = 0; y < tiles; y++) 
    {
      color c = img.get(int(x*tileSize),int(y*tileSize));
      float b = map(brightness(c),0,255,1,0);
      float z = map(b,0,1,-350,350);
      
      push();
      translate(x*tileSize - width/2, y*tileSize - height/2, z);
      sphere(tileSize*b*0.8);
      pop();
    }
  }
  pop();
}

void oscEvent(OscMessage theOscMessage)
{ 
  movementY = theOscMessage.get(0).intValue();
  movementX = theOscMessage.get(1).intValue(); 
  println(movementY, "", movementX);
}
