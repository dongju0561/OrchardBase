#include <SoftwareSerial.h>
#include <stdio.h>
#include <Servo.h>
#define sensorPin A0
#define servoPin 5

//객체 선언
SoftwareSerial bluetooth(2,3);
Servo servo; //Servo 타입 servo 이름으로 객체 선언

//전역변수
int angle = 0;
int smokeLevel;

void setup(){
  Serial.begin(9600);
  bluetooth.begin(9600);
  pinMode(sensorPin,INPUT);
  servo.attach(servoPin); //서보 초기화 servo 조작을 위해 5번핀 PWM 사용
  
}

void loop(){
  if(bluetooth.available()){ //블루투스 수신
    
    char cmd = (char)bluetooth.read();
    Serial.println(cmd);
    //불이 켜져있을때
    if( cmd == 'y'){ //bluetooth로부터 문자 'y'를 받게 된다면
      angle = 90; // angle 변수값 갱신
      Serial.println("work");
    }
    //불이 꺼져있을때
    else if(cmd == 'n'){ //bluetooth로부터 문자 'n'를 받게 된다면
      angle = 0; // angle 변수값 갱신
      Serial.println("work");
    }
  }
  servo.write(angle);

  smokeLevel = analogRead(sensorPin);
  Serial.println(smokeLevel);

  if (smokeLevel > 100) {
    bluetooth.write(0x81);
    delay(200);
  }
  else {
    bluetooth.write(0x80);
    delay(200);
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
  
}
   
*/