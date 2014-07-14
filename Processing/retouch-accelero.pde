import processing.serial.*; 
import ddf.minim.*; 

Minim minim; 
AudioPlayer player1, player2, player3, player4; 

boolean cell_1 = false; 
Serial myPort;
int autorizz = 9;

void setup() {  
  size(512, 250); 
  background(5);
  //smooth();
  //noStroke();
  //ellipseMode(CENTER);
  myPort = new Serial(this, Serial.list()[Serial.list().length-1], 1200); // TODO dinamico
  minim = new Minim(this); 
  // TODO dinamico, in base a traccia come se cliccassi foward
  player1 = minim.loadFile("track1.mp3", 2048); 
  player2 = minim.loadFile("track2.mp3", 2048); 
  player3 = minim.loadFile("track3.mp3", 2048); 
  player4 = minim.loadFile("track4.mp3", 2048); 
  //background(back);
} 
void draw() { 
  int lettura = myPort.read(); 
  int pausePlaying = -1500; //variabile legato al timing delle pause
  if (lettura == 8 || lettura == 22 || lettura == 23) {
    autorizz = 8;
  }else{
    autorizz = 9;
  }

  if (autorizz == 9 && (millis() - pausePlaying) > 1500){
    if (lettura == 1) {
      if (player2.isPlaying()) {player2.pause();}  
      if (player3.isPlaying()) {player3.pause();}  
      if (player4.isPlaying()) {player4.pause();}  
      player1.play(); 
    } 
    
    if (lettura == 2) {
      if (player1.isPlaying()) {player1.pause();}  
      if (player3.isPlaying()) {player3.pause();}  
      if (player4.isPlaying()) {player4.pause();}    
      player2.play(); 
    }
    if (lettura == 3) {
      if (player2.isPlaying()) {player2.pause();}  
      if (player3.isPlaying()) {player3.pause();}  
      if (player1.isPlaying()) {player1.pause();}  
      player4.play(); 
    }
    if (lettura == 4) {
      if (player2.isPlaying()) {player2.pause();}  
      if (player1.isPlaying()) {player1.pause();}  
      if (player4.isPlaying()) {player4.pause();}   
      player3.play(); 
    } 
  }
 
 if (lettura == 8){ // 8 è il segnale di STOP: Arduino invia 8 quando il modellino è inclinato
  if (player1.isPlaying()) {player1.pause();}
  if (player2.isPlaying()) {player2.pause();}  
  if (player3.isPlaying()) {player3.pause();}  
  if (player4.isPlaying()) {player4.pause();}    
  pausePlaying = millis(); // settiamo la variabile pausePlaying al tempo di pause. Vogliamo che, dopo aver messo in pausa, sia impossibile partire con un nuovo play prima che sia trascorso del tempo (1500 millisec, impostato nell'IF in partenza)
 } 
 
  if (lettura == 12 || lettura == 13){ // 8 è il segnale di STOP: Arduino invia 8 quando il modellino è inclinato
  if (player1.isPlaying()) {player1.skip(-60);}
  if (player2.isPlaying()) {player2.skip(-60);}  
  if (player3.isPlaying()) {player3.skip(-60);}  
  if (player4.isPlaying()) {player4.skip(-60);}    
  pausePlaying = millis(); // settiamo la variabile pausePlaying al tempo di pause. Vogliamo che, dopo aver messo in pausa, sia impossibile partire con un nuovo play prima che sia trascorso del tempo (1500 millisec, impostato nell'IF in partenza)
 }
     
  println(lettura); 
  
if ( player1.isPlaying() || player2.isPlaying())
  {text("The player is playing.", 5, 15);}
  else
  {text("The player is not playing.", 5, 35);}
  
  delay(30); 
} 
   
void stop() 
{ 
  player1.close(); 
  player2.close(); 
  minim.stop(); 
  super.stop(); 
} 
