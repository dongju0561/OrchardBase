#include <SoftwareSerial.h>
#include <Servo.h>
#define servoPin 5
SoftwareSerial bluetooth(2,3);
Servo servo;

int angle = 0;

void setup() 
{
  bluetooth.begin(9600);
  Serial.begin(9600);
  servo.attach(servoPin); 
} 

void loop() 
{ 
  if(bluetooth.available()){
    char cmd = (char)bluetooth.read();
    Serial.println(cmd);
    Serial.println(sizeof(cmd));
    if( cmd == 'y'){ //불이 켜져있을때
      angle = 90;
      Serial.println("get!!");
    }
    else if(cmd == 'n'){ //불이 꺼져있을때
      angle = 0;
      Serial.println("get!!");
    }
  }
  servo.write(angle);
}
