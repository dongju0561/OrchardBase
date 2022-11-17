#include <IRremote.hpp>
#include <IRremote.h>

IRsend irsend;

void setup() {

  Serial.begin(9600);
}

void loop() {

  poweron(24, 0);
  delay(1000);
  poweroff();
  delay(1000);
}

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