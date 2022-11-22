#include <SoftwareSerial.h>
#include <stdio.h>
#include <Servo.h>
#include <string.h>
#include <IRremote.h>
#include <stdlib.h>
#define sensorPin A0
#define servoPin 5

//객체 선언

IRsend irsend(5);
SoftwareSerial bluetooth(2,3);
Servo servo; //Servo 타입 servo 이름으로 객체 선언

//전역변수
int angle = 0;
int smokeLevel;
char str[5] = "";
int currentTemp = 0;
int currentFan = 0;
int index = 0;

//에어컨 신호생성을 위한 함수들
void make_signal(uint8_t a, uint8_t b, uint8_t c, uint8_t d) {
  uint32_t val = ((a << 12) | (b << 8) | (c << 4) | d) & 0xFFFF;
  uint16_t crc = 0x0000;

  crc = (a + b + c + d) & 0xF;
  Serial.println(val,HEX);
  unsigned long data = 0x8800000;
  data = data | ( (val << 4) | crc );
  unsigned long z;
  irsend.sendLG(data, 28);
}

void cooling(int temp, int fan) {

    temp = min(max(18, temp), 30);
    make_signal(0, 8, temp-15, fan);
}

void poweron(int temp, int fan) { // with cooling mode

    temp = min(max(18, temp), 30);
    make_signal(0, 0, temp-15, fan);
}

void poweroff() {
    make_signal(12, 0, 0, 5);
}

void append(char *dst, char c) {
    char *p = dst;
    while (*p != '\0') p++; // 문자열 끝 탐색
    *p = c;
    *(p+1) = '\0'; 
}
void clearStr(char *dst, int num){
  char *p = dst;
  for(int i = 0; i< num; i++){
    *(p+i) = '\0';
  }
}

void setup(){
  Serial.begin(9600);
  bluetooth.begin(9600);
  pinMode(sensorPin,INPUT);
  servo.attach(servoPin); //서보 초기화 servo 조작을 위해 5번핀 PWM 사용
}
void loop(){
  if(bluetooth.available()){ //블루투스 수신
    
    char cmd = (char)bluetooth.read();    
    //에어컨 제어신호가 들어왔을때
    
    append(str, cmd);
    
    if(str[2] == '#'){
      Serial.print("get into: ");
      Serial.println(str);
      if(!strncmp(str,"lf",2)){
        angle = 0; // angle 변수값 갱신
        clearStr(str,5);
      }
      if(!strncmp(&str[0],"lo",2)){
        angle = 90; // angle 변수값 갱신  
        clearStr(str,5);
      }
      //에어컨 off
      if(!strncmp(&str[0],"af",2)){
        Serial.println("off");
        poweroff();
        clearStr(str,5);
      }
    }
    
    if(str[5] == '#'){
      //에어컨 on
      if(!strncmp(&str[0],"ao",2)){
        Serial.println("on");
        currentTemp = (atoi(str[2]) * 10) + atoi(str[3]);
        currentFan = atoi(str[4]);
        Serial.print(currentTemp);
        Serial.print(" ");
        Serial.print(currentFan);
        poweron(currentTemp, currentFan);
        clearStr(str,5);
      }
      //에어컨 온도 조절
      if(!strncmp(&str[0],"at",2)){
        currentTemp = (atoi(str[2]) * 10) + atoi(str[3]);
        currentFan = atoi(str[4]); 
        cooling(currentTemp, currentFan);
        clearStr(str,5);
      }
      //에어컨 풍향 조절
      if(!strncmp(&str[0],"an",2)){
        currentTemp = (atoi(str[2]) * 10) + atoi(str[3]);
        currentFan = atoi(str[4]);
        cooling(currentTemp, currentFan);
        clearStr(str,5);
      }
    }
    
  }
  servo.write(angle);
  smokeLevel = analogRead(sensorPin);


  if (smokeLevel > 100) {
    bluetooth.write(0x81);
    delay(200);
  }
  else {
    bluetooth.write(0x80);
    delay(200);
  }
}
