#include <Servo.h>

int servoPin = 9;

Servo servo; 

int angle = 0; // servo position in degrees 

void setup() 
{ 
    servo.attach(servoPin); 
} 

void loop() 
{ 
  servo.write(180); 
  delay(500); 

  servo.write(0); 
  delay(1000); 
} 