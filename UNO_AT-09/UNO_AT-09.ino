#include <SoftwareSerial.h>

SoftwareSerial btSerial(7, 8); // RX, TX

void setup() {
  Serial.begin(9600);
  btSerial.begin(9600);
}

void loop() {
  if (btSerial.available()) {
    Serial.write(btSerial.read());
  }
  if (Serial.available()) {
    btSerial.write(Serial.read());
  }
}
