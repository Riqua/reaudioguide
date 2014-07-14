/*
Connect SCLK, MISO, MOSI, and CSB of ADXL362 to
SCLK, MISO, MOSI, and DP 10 of Arduino 
(check http://arduino.cc/en/Reference/SPI for details)
 
*/ 

#include <SPI.h>
#include <ADXL362.h>
#include <CapacitiveSensor.h>

ADXL362 xl;

int16_t temp;
int16_t XValue, YValue, ZValue, Temperature;

CapacitiveSensor capSensor = CapacitiveSensor(7,6);
CapacitiveSensor capSensor2 = CapacitiveSensor(8,9);
int threshold = 360; 

int statoplay= 8;
int stato= 0;
int traccia = 0;

void setup(){
  
  Serial.begin(2400);
  xl.begin(10);                   // Setup SPI protocol, issue device soft reset
  xl.beginMeasure();              // Switch ADXL362 to measure mode  
	
  Serial.println("ReAudioguide touch + accelero: test dei sensori");
}

void loop(){
  long sensorValue = capSensor.capacitiveSensor(3);
  long sensorValue2 = capSensor2.capacitiveSensor(3);
  
   if(sensorValue2 > threshold){
     if(traccia != 2){
       Serial.write(2); //Basso,
       //Serial.print("\n Traccia Ordine basso "); 
       traccia = 2;
     }
  }
  if(sensorValue > threshold) {
    if(traccia != 1){
     Serial.write(1); //Piazza,
     //Serial.print("\n Traccia Piazza ");
     traccia = 1;
    }
  }
  xl.readXYZTData(XValue, YValue, ZValue, Temperature);  
  
  if(XValue > 1100 || XValue < -1100) {
    if(statoplay != 8){
      Serial.write(8); //Pausa,
      //Serial.print("\n PAUSA "); 
      statoplay = 8; // ex statoplay
      traccia = 0;
    }
  }else{
     if((statoplay != 9)&&(XValue < 600 && XValue > -600)){
       Serial.write(9); //Play,
       //Serial.print("\n PLAY ");
       statoplay=9; // ex statoplay
       traccia = 0;
     } 
  }
  if(YValue > 500) {
    if(YValue > 1200) {
      if(stato != 12){
         Serial.write(12); //Rewind,
         //Serial.print("\n REWIND ");
         stato=12;
      }
    }else{
      if(stato == 12){
        if(YValue < 700) {
          Serial.write(9); //Play,
          //Serial.print("\n PLAY ");
          stato=0;
        }
      }
    }
  }
  if(YValue < -500) {
    if(YValue < -1200) {
      if(stato != 22){
         Serial.write(22); //Foward,
         //Serial.print("\n FOWARD ");
         stato=22;
      }
    }else{
      if(stato == 22){
        if(YValue > -700) {
          Serial.write(9); //Play,
          //Serial.print("\n PLAY ");
          stato=0;
        }
      }
    }
  }
/* Serial.println(Temperature);	 */ 
  delay(30);        
}
