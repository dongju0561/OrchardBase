#include <SoftwareSerial.h>
#include <stdio.h>
//#include <Servo.h>

SoftwareSerial bluetooth(2,3);


void setup(){
  Serial.begin(9600);
  bluetooth.begin(9600);
  
}

void loop(){
  if(bluetooth.available()){
    Serial.write((int)bluetooth.read());
    Serial.println(sizeof(data));
  }
}
//bluetooth MAC addr: 98:da:60:03:82:04

/* bluetooth에서 어떤 신호가 왔을때 시리얼 모니터에 출력
#include <SoftwareSerial.h>

if(bluetooth.available()){
  Serial.write(bluetooth.read());
}
//시리얼 모니터에서 어떤 입력이 들어왔을때 bluetooth에 입력
if(Serial.available()){
  bluetooth.write(Serial.read());
}
*/

/* 
Code for detecting gas and sending the each result

int smokeLevel;

pinMode(sensorPin,INPUT);
smokeLevel = analogRead(sensorPin);
  Serial.println(smokeLevel);

  delay(100);
  if (smokeLevel > 200) {
    bluetooth.write(0x81);
    delay(200);
  }
  else {
    bluetooth.write(0x80);
    delay(200);
}
   
*/