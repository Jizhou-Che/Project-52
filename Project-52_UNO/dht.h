#ifndef dht_h

#define dht_h

#if ARDUINO >= 100
 #include "Arduino.h"
#else
 #include "WProgram.h"
#endif

#define DHT_LIB_VERSION "0.1.00"

class dht {
	public:
		int read11(uint8_t pin);
	    int read22(uint8_t pin);
		double humidity;
		double temperature;
	private:
		uint8_t bits[5];  // Buffer to receive data.
		int read(uint8_t pin);
};

#endif
