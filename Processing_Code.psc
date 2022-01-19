import processing.sound.*;
import oscP5.*;
import netP5.*;

SoundFile sound;
AudioIn in;
int bands = 512;
float[] spectrum = new float[bands];
int values = 150;
float[] spectrumValues = new float[values];
FFT fft;

OscP5 oscP5;
NetAddress myRemoteLocation;

PImage img;
int back;
int red = 0 ;
int green = 0;
int blue = 0;

void setup()
{
  size(900, 900, P3D);
  img = loadImage("venus.jpg");
  img.resize(width, height);
  //sound = new SoundFile(this, "Beat.wav");
  //sound.loop();
  /*fft = new FFT(this, bands);
  in = new AudioIn(this, 0);
  in.start();
  fft.input(in);*/
  
  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress("127.0.0.1",12000);
}
void draw()
{
  background(red,green,blue);
  noCursor();
  fill(#f5d22e);
  stroke(34);
  sphereDetail(3, 2);
  
//fft.analyze(spectrum);
for (int i = 0; i < bands; i++)
{
if (i < 100)
{
  spectrumValues[i] = spectrum[i];
}
  push();
  float tiles = mouseX;
  //println(i);
  float tileSize = width/tiles;
  translate(width/2, height/2);
  //rotateZ(radians(-mouseX));
  rotateY(radians(spectrum[i]));
  //rotateX(radians(spectrum[i]));
  
  for (int x = 0; x < tiles; x++)
  {
    for (int y = 0; y < tiles; y ++)
    {
      color c = img.get(int(x*tileSize), int(y*tileSize));
      float b = map(brightness(c), 0, 255, 1, 0);
      float z = map(b,spectrum[i],-spectrum[i] * mouseY,-250,250);
      
      push();
      translate (x*tileSize - width/2, y*tileSize - height/2, z);
      sphere(tileSize * b* 0.2);
      sphere(tileSize*b*0.8);
      pop();
      
    }
  } 
  pop();
}
}

void OscEvent(OscMessage myOscMessage)
{
  red = myOscMessage.get(0).intValue();
  green = myOscMessage.get(1).intValue();
  blue = myOscMessage.get(2).intValue();
}
