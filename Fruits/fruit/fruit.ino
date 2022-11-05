#include <SoftwareSerial.h>
#include <Servo.h>

#define sensorPin A0

SoftwareSerial bluetooth(2,3);

int smokeLevel;

void setup(){
  Serial.begin(9600);
  bluetooth.begin(9600);
  pinMode(sensorPin,INPUT);
}

void loop(){
  smokeLevel = analogRead(sensorPin);
  Serial.println(smokeLevel);

  delay(100);
  if (smokeLevel > 300) {
    bluetooth.write(0x01);
    delay(200);
  }
  else {
    bluetooth.write("n");
    delay(200);
  }
}
  // //bluetooth에서 어떤 신호가 왔을때 시리얼 모니터에 출력
  // if(bluetooth.available()){
  //   Serial.write(bluetooth.read());
  // }
  // //시리얼 모니터에서 어떤 입력이 들어왔을때 bluetooth에 입력
  // if(Serial.available()){
  //   bluetooth.write(Serial.read());
  // }

// 98:da:60:03:82:04