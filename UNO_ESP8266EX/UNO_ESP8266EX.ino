/*
  Software serial multple serial test

 Receives from the hardware serial, sends to software serial.
 Receives from software serial, sends to hardware serial.

 The circuit:
 * RX is digital pin 10 (connect to TX of other device)
 * TX is digital pin 11 (connect to RX of other device)

*/
#include <SoftwareSerial.h>

SoftwareSerial mySerial(10, 11); // RX, TX

void setup(){
  // Open serial communications and wait for port to open:
  Serial.begin(9600);
  while (!Serial){
    ; // wait for serial port to connect. Needed for native USB port only
  }
  Serial.println("Hardware serial.");
  // set the data rate for the SoftwareSerial port
  mySerial.begin(4800);
  mySerial.println("Software serial.");
}

void loop(){
  if (mySerial.available()) {
    Serial.write(mySerial.read());
  }
  if (Serial.available()) {
    mySerial.write(Serial.read());
  }
}
