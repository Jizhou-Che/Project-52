#include <SoftwareSerial.h>
#include "dht.h"

#define DHT11_PIN 7 // DHT11.
#define LIGHT_PIN A0 // Light.
#define SOUND_PIN A5 // Sound.

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
  int temperature = DHT.temperature;
  int humidity = DHT.humidity;
  // Light.
  int light = analogRead(LIGHT_PIN);
  // Sound.
  int sound = analogRead(SOUND_PIN);
  // Encode data to 16 hexadecimal characters.
  String data = String();
  // Temperature in 4 hexadecimal characters.
  String temperatureHEXString = String(temperature, HEX);
  for (int i = 0; i < 4 - temperatureHEXString.length(); i++) {
    data.concat("0");
  }
  data.concat(temperatureHEXString);
  // Humidity in 4 hexadecimal characters.
  String humidityHEXString = String(humidity, HEX);
  for (int i = 0; i < 4 - humidityHEXString.length(); i++) {
    data.concat("0");
  }
  data.concat(humidityHEXString);
  // Light in 4 hexadecimal characters.
  String lightHEXString = String(light, HEX);
  for (int i = 0; i < 4 - lightHEXString.length(); i++) {
    data.concat("0");
  }
  data.concat(lightHEXString);
  // Sound in 4 hexadecimal characters.
  String soundHEXString = String(sound, HEX);
  for (int i = 0; i < 4 - soundHEXString.length(); i++) {
    data.concat("0");
  }
  data.concat(soundHEXString);
  // Buffer array of 20 bytes.
  char dataBuffer[20];
  data.toCharArray(dataBuffer, 20);
  // AT-09.
  bleSerial.write(dataBuffer);
  delay(10);
}
