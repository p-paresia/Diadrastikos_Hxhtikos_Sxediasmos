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
int movementZ =0;
int movementNew = 0;

PImage img;
String imageKadinsky = "venus.jpg";


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
  if(movementNew == 0)
  {
    red = int(random(movementX, movementZ));
    green = int(random(movementY, movementX));
    blue = int(random(movementZ, movementY));
  }
  if (movementNew == 1)
  {
    red = int(random(movementZ, movementY));
    green = int(random(movementX, movementZ));
    blue = int(random(movementY, movementX));
  }
  if (movementNew == 2)
  {
    red = int(random(movementY, movementX));
    green = int(random(movementX, movementY));
    blue = int(random(movementX, movementZ));
  }
  
  background(red,green,blue);
  fill(blue,red,green);
  
  noStroke();
  sphereDetail(5);
  float tiles = movementX /2;
  float tileSize = width/tiles;
  push();
  translate(width/2,height/2);
  rotateY(radians(frameCount * movementNew));
 
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
  float movementY = theOscMessage.get(0).floatValue();
  movementX = theOscMessage.get(1).intValue(); 
  float movementZ = theOscMessage.get(2).floatValue();
  movementNew = theOscMessage.get(3).intValue();
  println(movementY, "", movementX, "", movementZ, "", movementNew);
}
