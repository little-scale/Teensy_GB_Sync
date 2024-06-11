// Teensyduino Sync
// MIDI Clock --> Sync
// by Sebastian Tomczak
// 3 September

// At the time of writing, requires edited Teensyduino usb_midi/usb_api.cpp and usb_midi/usb_api.h
// See here: http://little-scale.blogspot.com/2011/08/how-to-deal-with-real-time-midi-beat.html

byte counter; 
byte CLOCK = 248; 
byte START = 250; 
byte CONTINUE = 251; 
byte STOP = 252; 

int LSDJ_pin = 0; 
int nano_pin = 1; 
int sync_24_pulse_pin = 2; 
int sync_24_start_pin = 3; 
int LED_pin = 11; 

void setup() {
  pinMode(LED_pin, OUTPUT); 
  pinMode(LSDJ_pin, OUTPUT); // LSDJ sync output
  pinMode(nano_pin, OUTPUT); // Nanoloop sync output
  pinMode(sync_24_pulse_pin, OUTPUT); // Sync 24 sync pulse output
  pinMode(3, OUTPUT); // Sync 24 start / stop output
  digitalWrite(11, HIGH); 
  usbMIDI.setHandleRealTimeSystem(RealTimeSystem);
}

void loop() {
  usbMIDI.read(); 

}

void RealTimeSystem(byte realtimebyte) {
  if(realtimebyte == CLOCK) {
    lightLED(); 
    lsdjSync(); 
    nanoSync(); 
    dinSync(); 
    counter++; 
  }
  if(realtimebyte == START || realtimebyte == CONTINUE) {
    counter = 0; 
    digitalWrite(LED_pin, HIGH); 
    digitalWrite(sync_24_start_pin, HIGH); 
  }
  if(realtimebyte == STOP) {
    digitalWrite(LED_pin, LOW);
    digitalWrite(sync_24_start_pin, LOW);  
  }
}

void lightLED() {
  if(counter == 23) {
      counter = 0; 
      digitalWrite(LED_pin, HIGH); 
    }

    if(counter == 11) {
      digitalWrite(LED_pin, LOW); 
    }
}

void lsdjSync() {
  for(int i = 0; i < 8; i ++) {
    digitalWrite(LSDJ_pin, LOW); 
    digitalWrite(LSDJ_pin, HIGH); 
  }
}

void nanoSync() {
  digitalWrite(nano_pin, counter % 12); 
}

void dinSync() {
  digitalWrite(sync_24_pulse_pin, HIGH); 
  delay(3); 
  digitalWrite(sync_24_pulse_pin, LOW); 
}


