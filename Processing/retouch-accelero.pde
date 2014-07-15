import processing.serial.*; 
import ddf.minim.*; 

Minim minim; 
AudioPlayer player; 

boolean cell_1 = false; 
Serial myPort;
int autorizz = 9;
int indexForNames = 8;
int nowPlaying = 0;


void setup() {  
  size(512, 250); 
  background(5);
  //smooth();
  //noStroke();
  //ellipseMode(CENTER);
  myPort = new Serial(this, Serial.list()[Serial.list().length-1], 800); // TODO dinamico
  minim = new Minim(this); 
  player = minim.loadFile("track"+indexForNames+".mp3");
} 
void draw() { 
  int lettura = myPort.read(); 
  int pausePlaying = -1500; //variabile legato al timing delle pause
  if (lettura == 8 || lettura == 22 || lettura == 12) {
    autorizz = 8;
  }else{
    autorizz = 9;
  }

  if (autorizz == 9 && (millis() - pausePlaying) > 1500){
    if (lettura == 13){
      //TODO segnale da aggiungere after rewind (12): prendi il count di millis passati e lanci qui .skip()
    }
    if (lettura == 1 || lettura == 2 || lettura == 3 || lettura == 4) {
      indexForNames = lettura;
      if(nowPlaying !=lettura){
        player.pause(); 
        player = minim.loadFile("track"+indexForNames+".mp3");
      }
      player.play(); 
      nowPlaying = lettura;
    } 
  }
 
 if (lettura == 8){ // 8 è il segnale di STOP: Arduino invia 8 quando il modellino è inclinato
  if (player.isPlaying()) {player.pause();}   
  pausePlaying = millis(); // FUNZIONA??? mi sa di no! settiamo la variabile pausePlaying al tempo di pause. Vogliamo che, dopo aver messo in pausa, sia impossibile partire con un nuovo play prima che sia trascorso del tempo (1500 millisec, impostato nell'IF in partenza)
 } 
 
  if (lettura == 12 && player.isPlaying()){ // 8 è il segnale di STOP: Arduino invia 8 quando il modellino è inclinato
    player.pause();
    player.skip(-1600);
    delay(300);  
 }
     
  println(lettura); 
  println(pausePlaying);
  
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
