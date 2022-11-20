#include <SoftwareSerial.h>
#include <Servo.h>
#define servoPin 5

SoftwareSerial bluetooth(2,3); //bluetooth 송수신 핀으로 2,3번핀을 사용
Servo servo; //Servo 타입 servo 이름으로 객체 선언

int angle = 0;
char cmd[5] = {}int smokeLevel;

void setup() 
{
  bluetooth.begin(9600); // bluetooth 초기화 baud rate 9600으로 설정
  servo.attach(servoPin); //서보 초기화 servo 조작을 위해 5번핀 PWM 사용
  Serial.begin(9600);
} 

void loop() 
{ 
  if(bluetooth.available()){ //bluetooth로 신호들어 올때
    
    Serial.println(cmd);
    Serial.println(sizeof(cmd));

    //불이 켜져있을때
    if( cmd == 'y'){ //bluetooth로부터 문자 'y'를 받게 된다면
      angle = 90; // angle 변수값 갱신
    }
    //불이 꺼져있을때
    else if(cmd == 'n'){ //bluetooth로부터 문자 'n'를 받게 된다면
      angle = 0; // angle 변수값 갱신
    }
  }
  servo.write(angle); //갱신한 angle 변수값에 따라 servo 각도 변경 -> 전등 스위치 조작
}
