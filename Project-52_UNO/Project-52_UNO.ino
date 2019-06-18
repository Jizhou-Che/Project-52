#include <SoftwareSerial.h>
#include "dht.h"

#define DHT11_PIN 7 // DHT11.

// (RX, TX).
SoftwareSerial bleSerial(3, 2); // AT-09.

dht DHT;

void setup() {
  Serial.begin(9600);
  bleSerial.begin(9600);
}

void loop() {
  // DHT11.
  DHT.read11(DHT11_PIN);
  Serial.print("Temperature: ");
  Serial.println(DHT.temperature);
  Serial.print("Humidity: ");
  Serial.println(DHT.humidity);
  // AT-09.
  bleSerial.write("Maximum of 20 bytes.");
  delay(1000);
}
