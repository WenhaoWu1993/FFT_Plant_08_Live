import ddf.minim.*;
import ddf.minim.analysis.*;
//import ddf.minim.effects.*;
//import ddf.minim.signals.*;
//import ddf.minim.spi.*;
//import ddf.minim.ugens.*;

import peasy.*;
//import peasy.org.apache.commons.math.*;
//import peasy.org.apache.commons.math.geometry.*;

PeasyCam cam;

int divisions = 8;
int floorCount = 0;

float updateTime = 5000.0;
float timeStamp;

float Length = 10.0;
float Radius = 10.0;

float _height = 5.0;

ArrayList<Group> groups;

Minim minim;
AudioPlayer audio;
AudioMetaData meta;
FFT fft;

float[] frequencyBands;
float[] frequencyBandsMax;
float[] frequencyBandsAverage;
float[] relativeAmp;
int[] avgCount;
float scale = 100.0;

String title, progress;
boolean isPlaying = false;
int kickofftime;

void setup() {
  size(960, 720, P3D);
  cam = new PeasyCam(this, 500);
  
  minim = new Minim(this);
  audio = minim.loadFile("The Album Leaf - Glimmering Lights.mp3", 1024);
  meta = audio.getMetaData();
  fft = new FFT(audio.bufferSize(), audio.sampleRate());
  fft.logAverages(100, 1);
  
  frequencyBands = new float[divisions];
  frequencyBandsMax = new float[divisions];
  frequencyBandsAverage = new float[divisions];
  relativeAmp = new float[divisions];
  avgCount = new int[divisions];
  
  println(audio.bufferSize());
  println(fft.avgSize());
  
  groups = new ArrayList<Group>();  
  for(int i = 0; i < divisions; i++) {
    groups.add(new Group(i));
  }
  
  title = meta.title();
  pixelDensity(displayDensity());
  colorMode(HSB, 255);
  
  audio.play();
  println(title);
}

void draw() {
  background(0);
  
  ambientLight(0, 0, 220);
  //directionalLight(0, 0, 255, 0, 0, 1);
  drawAxis();  
  
  fft.forward(audio.mix);
  for(int i = 0; i < fft.avgSize(); i++) {
    float avg = fft.getAvg(i) * scale;
    frequencyBands[i] += avg;
    if(avg > frequencyBandsMax[i]) {
      frequencyBandsMax[i] = avg;
    }
    if(floorCount > 0) {
      relativeAmp[i] = frequencyBandsAverage[i] / frequencyBandsMax[i];
    }
    avgCount[i]++;
  }
  
  //println(relativeAmp[7]);
  
  if(millis() > timeStamp && audio.isPlaying()) {
    for(int i = 0; i < frequencyBandsAverage.length; i++) {
      if(floorCount > 0) {
        frequencyBandsAverage[i] = frequencyBands[i] / avgCount[i];
      }
      frequencyBands[i] = 0;
      avgCount[i] = 0;
    }
    //println(relativeAmp[0]);
    
    for(Group g : groups) {
      g.addStep();
    }    
    timeStamp += updateTime;
    floorCount++;
  }
  
  for(int i = 0; i < groups.size(); i++) {
    Group g = groups.get(i);
    pushMatrix();
    rotateZ(i * TWO_PI / divisions);
    g.display();
    popMatrix();
  }
  
  //println(frameRate);
  GUI();
}

void GUI() {
  if(!isPlaying && audio.isPlaying()) {
    kickofftime = millis();
    isPlaying = true;
  }
  
  if(audio.isPlaying()) {
    int playtime = millis() - kickofftime;
    int s_ = playtime / 1000;
    int s = s_ % 60;
    int m = s_ / 60;
  
    String sec = nf(s, 2);
    String min = nf(m, 2);
  
    progress = min + ":" + sec;
  }
  //println(sec);
  
  hint(DISABLE_DEPTH_TEST);
  cam.beginHUD();
  fill(255);
  text("Title: " + title, 20, 10, 500, 30);
  text("Time Played: " + progress, 20, 25, 500, 30);
  text("Framerate: " + frameRate, 20, 40, 500, 30);
  cam.endHUD();
  hint(ENABLE_DEPTH_TEST);
}

void drawAxis() {
  //axis
  //colorMode(RGB);
  stroke(0, 255, 255);
  strokeWeight(1);
  line(0, 0, 0, 100, 0, 0);
  
  stroke(80, 255, 255);
  line(0, 0, 0, 0, 100, 0);
  
  stroke(160, 255, 255);
  line(0, 0, 0, 0, 0, 100);
}

int savedTime = 0;

void keyPressed() {
  if(key == ' ') {
    savedTime++;
    String name = "fftTrial2-" + savedTime;
    saveFrame(name + ".png");
  }
}