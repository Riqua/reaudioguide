import processing.serial.*;
import ddf.minim.*;

Minim minim;
AudioPlayer player;

boolean cell_1 = false;
Serial myPort;
int autorizz;
int indexForNames = 8;
int nowPlaying;
int pausePlaying;
int countRewind;
int countFoward;
int countRewFow;

void setup() {
  size(512, 250);
  background(5);
  //smooth();
  //noStroke();
  //ellipseMode(CENTER);
  nowPlaying = 0;
  autorizz = 9;
countRewFow=0;
  pausePlaying = -1000; //milliseconds that must pass after a pause input, before it can be made again a play
  myPort = new Serial(this, Serial.list()[Serial.list().length-1], 800);
  minim = new Minim(this);
  player = minim.loadFile("track"+indexForNames+".mp3");
}
void draw() {
  int lettura = myPort.read();
  if (lettura == 8 || lettura == 22 || lettura == 12) {
    autorizz = 8;
  }else{
    autorizz = 9;
  }

  if (autorizz == 9 && (millis() - pausePlaying) > 1000){
    if (lettura == 1 || lettura == 2 || lettura == 3 || lettura == 4) {
// 1, 2, 3 and 4 are the signals to play the four specific audio-tracks
      indexForNames = lettura;
      if(nowPlaying !=lettura){
        player.pause();
        player = minim.loadFile("track"+indexForNames+".mp3");
      }
      player.play();
      nowPlaying = lettura;
    }
  }

 if (lettura == 8){ // 8 is the STOP signal: Arduino sends 8, via serial, when the model is tilted downward
  if (player.isPlaying()) {player.pause();}
  pausePlaying = millis(); // is saved the moment of pause. We want, after pausing, it is impossible to start with a new play before the lapse of time (1 second)
 }

  //if (lettura == 12 && player.isPlaying() || countRewFow != 0){
  if (lettura == 12 && player.isPlaying() || countRewind != 0){
//12 and 22 are respectively the signals for REWIND and FOWARD. Arduino sends 12 or 22 when the model is tilted (respectively) to the left or right
    if (player.isPlaying()) {player.pause();}
    countRewind = countRewind - 180;
 }
  if (lettura == 22 && player.isPlaying() || countFoward != 0){
//12 and 22 are respectively the signals for REWIND and FOWARD. Arduino sends 12 or 22 when the model is tilted (respectively) to the left or right
    if (player.isPlaying()) {player.pause();}
    countFoward = countFoward + 180;
 }
 if (lettura == 13 || lettura == 23){
    countRewFow = countRewind + countFoward;
    player.skip(countRewFow);
    countRewind=0;
    countFoward=0;
    player.play();
 }
  //println(lettura);
  //println(pausePlaying);
  //println(countRewFow);

if ( player.isPlaying())
  {text("The player is playing.", 5, 15);}
  else
  {text("The player is not playing.", 5, 35);}

  delay(30);
}

void stop()
{
  player.close();
  minim.stop();
  super.stop();
}
