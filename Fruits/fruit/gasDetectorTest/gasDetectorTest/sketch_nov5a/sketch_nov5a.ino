#define sensorPin A0

int smokeLevel;

void setup() {
  pinMode(sensorPin,INPUT);
  Serial.begin(9600);
}

void loop() {
  smokeLevel = analogRead(sensorPin);
  Serial.println(smokeLevel);
  delay(100);
}
