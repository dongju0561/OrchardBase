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
    if( cmd == 'y'){ //불이 켜져있을때
      angle = 90;
      Serial.println("on!!");
    }
    else if(cmd == 'n'){ //불이 꺼져있을때
      angle = 0;
      Serial.println("off!!");
    }
  }
  servo.write(angle);
}
  // for(int i=0; i<90; i++){
  //   servo.write(i);
  //   delay(delay_);
  // }
  // for(int i=90; i>0; i--){
  //   servo.write(i);
  //   delay(delay_);
  // }

  // servo.write(0);
  // delay(20);
  // servo.write(180);
  // delay(20);
  // servo2.write(0);
  // servo2.write(350);
  

