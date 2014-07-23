import processing.serial.*;
import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer audiotrack;
AudioMetaData meta;
int songLength=0;

boolean cell_1 = false;
Serial myPort;
int autorizz;
int indexForNames = 0;
int nowPlaying;
int pausePlaying;
int countRewind;
int countFoward;
int countRewFow;

void setup() {
  size(512, 512);
  //smooth();
  //noStroke();
  //ellipseMode(CENTER);
  nowPlaying = 0;
  autorizz = 9;
  countRewFow=0;
  pausePlaying = -1000; //milliseconds that must pass after a pause input, before it can be made again a play
  myPort = new Serial(this, Serial.list()[Serial.list().length-1], 800);
  minim = new Minim(this);
  audiotrack = minim.loadFile("track"+indexForNames+".mp3");
}
void draw() {
  int lettura = myPort.read();
  if (lettura == 8 || lettura == 22 || lettura == 12) {
    autorizz = 8;
  }else{
    autorizz = 9;
  }

  if (autorizz == 9 && (millis() - pausePlaying) > 1000){
    if (lettura >= 0 || lettura <= 4) {
// 1, 2, 3 and 4 are the signals to play the four specific audio-tracks
// 0 is general audio-track. The general track is activated the first time that the audioguide comes out of standby mode.
      if(!(lettura == 0 && audiotrack.isPlaying())){ //a NAND operation to prevent the play of general audio-track while a user is listening to another track
        if(nowPlaying !=lettura){ // if a user touches the sensor relative to the current track, the track is not charged again
          indexForNames = lettura;
          audiotrack.pause();
          audiotrack = minim.loadFile("track"+indexForNames+".mp3");
          songLength=audiotrack.length();
          meta = audiotrack.getMetaData();
        }
        audiotrack.play();
        nowPlaying = lettura;
      }
    }
  }

 if (lettura == 8){ // 8 is the STOP signal: Arduino sends 8, via serial, when the model is tilted downward
  if (audiotrack.isPlaying()) {audiotrack.pause();}
  pausePlaying = millis(); // is saved the moment of pause. We want, after pausing, it is impossible to start with a new play before the lapse of time (1 second)
 }

  //if (lettura == 12 && audiotrack.isPlaying() || countRewFow != 0){
  if (lettura == 12 && audiotrack.isPlaying() || countRewind != 0){
//12 and 22 are respectively the signals for REWIND and FOWARD. Arduino sends 12 or 22 when the model is tilted (respectively) to the left or right
    if (audiotrack.isPlaying()) {audiotrack.pause();}
    countRewind = countRewind - 180;
 }
  if (lettura == 22 && audiotrack.isPlaying() || countFoward != 0){
//12 and 22 are respectively the signals for REWIND and FOWARD. Arduino sends 12 or 22 when the model is tilted (respectively) to the left or right
    if (audiotrack.isPlaying()) {audiotrack.pause();}
    countFoward = countFoward + 180;
 }
 if (lettura == 13 || lettura == 23){
    countRewFow = countRewind + countFoward;
    audiotrack.skip(countRewFow);
    countRewind=0;
    countFoward=0;
    audiotrack.play();
 }




  background(5);
if ( audiotrack.isPlaying())
  {text("The audiotrack is playing.", 5, 15);
    //if (!(meta==null))
    //  buttonProgressData.w = map(song.position(), 0, meta.length(), 0, width-24 );
    //buttonProgressData.display();
  showMeta() ;
}
  else
  {text("The audiotrack is not playing.", 5, 35);}

  delay(30);
  
  
  
}

void stop()
{
  audiotrack.close();
  minim.stop();
  super.stop();
}

void showMeta() {
  // 
  // data for meta information
  int ys = 115;  // y start-pos
  int yi = 16;   // y line difference
  //
  int y = ys;
  fill(255);
  if (!(meta==null)) {
    //textTab("File Name: \t" + showSongWithoutFolder(), 5, y);
    textTab("Length: \t" + strFromMillis(meta.length()), 5, y+=yi);
    textTab("Title: \t" + meta.title(), 5, y+=yi);
    textTab("Author: \t" + meta.author(), 5, y+=yi);
    textTab("Album: \t" + meta.album(), 5, y+=yi);
    textTab("Date: \t" + meta.date(), 5, y+=yi);
    textTab("Comment: \t" + meta.comment(), 5, y+=yi);
  } // if
}

void textTab (String s, float x, float y)
{
  // makes \t as tab for a table for one line
  // only for 2 columns yet
  // indent:  
  int indent = 90;
  //
  s=trim ( s );
  String [] texts = split (s, "\t");
  s=null;
  texts[0]=trim(texts[0]);
  text (texts[0], x, y);
  //
  // do we have a second part?
  if (texts.length>1&&texts[1]!=null) {
    // is the indent too small
    if (textWidth(texts[0]) > indent) {
      indent = int (textWidth(texts[0]) + 10);
    } // if
    //
    texts[1]=trim(texts[1]);
    text (texts[1], x+indent, y);
  }
} // func

String strFromMillis ( int m ) {
  // returns a string that represents a given millis m as hrs:minute:seconds
  float sec;
  int min;
  //
  sec = m / 1000;
  min = floor(sec / 60); 
  sec = floor(sec % 60);
  // over one hour?
  if (min>59) {
    int hrs = floor(min / 60);
    min = floor (min % 60);
    return  hrs+":"+nf(min, 2)+":"+nf(int(sec), 2);
  }
  else
  {
    return min+":"+nf(int(sec), 2);
  }
}
