/*

Wiring Diagram for QTI Sensors:
Arduino          Sensor
D7               QTI4 - Far left
D6               QTI3 - Mid left
D5               QTI2 - Mid right
D4               QTI1 - Far right

Wiring Diagram for Servos:
Arduino          Servo
D13              Left servo
D12              Right servo

*/

#include <Servo.h>

Servo servoL;
Servo servoR;

void setup(){
  Serial.begin(9600);
  servoL.attach(13);
  servoR.attach(12);

  int pins = 1; //doesn't do anything

//straddle circle
  for(int i = 0; i < 155; i++){
    lineTracking();
  }
  
  //turns to rectangle
  servoL.writeMicroseconds(1500); 
  servoR.writeMicroseconds(1700);
  delay(1300);

  //drives to rectangle
  servoL.writeMicroseconds(1700); 
  servoR.writeMicroseconds(1300);
  delay(2500);

  //turns right on rectangle
  servoL.writeMicroseconds(1700); 
  servoR.writeMicroseconds(1700);
  delay(600);

  //move forward
  servoL.writeMicroseconds(1700);
  servoR.writeMicroseconds(1300);
  delay(200);


  for(int i = 0; i < 260; i++){
    lineTracking();
  }

  //back up to avoid wall --do not change
  servoL.writeMicroseconds(1300);
  servoR.writeMicroseconds(1700);
  delay(900);

  //turn off of rectangle --do not change
  servoL.writeMicroseconds(1500); 
  servoR.writeMicroseconds(1700);
  delay(1500);

  //move off rectangle --do not change
  servoL.writeMicroseconds(1700);
  servoR.writeMicroseconds(1300);
  delay(1900);

  //turn right --do not change
  servoL.writeMicroseconds(1700);
  servoR.writeMicroseconds(1700);
  delay(900);

  //move right --do not change
  servoL.writeMicroseconds(1700);
  servoR.writeMicroseconds(1300);
  delay(2600);

  //turn left -- do not change
  servoL.writeMicroseconds(1500);
  servoR.writeMicroseconds(1300);
  delay(1500);

  //move forward -- iffy
  servoL.writeMicroseconds(1700);
  servoR.writeMicroseconds(1300);
  delay(1050);

  //turn left - perfect
  servoL.writeMicroseconds(1500);
  servoR.writeMicroseconds(1300);
  delay(1600);

  //move forward -- good
  servoL.writeMicroseconds(1700);
  servoR.writeMicroseconds(1300);
  delay(3100);

  //turn right -- perfect
  servoL.writeMicroseconds(1700);
  servoR.writeMicroseconds(1500);
  delay(1700);

  //move forward -- perfect
  servoL.writeMicroseconds(1700);
  servoR.writeMicroseconds(1300);
  delay(1400);

  //move right -- working on
  servoL.writeMicroseconds(1700);
  servoR.writeMicroseconds(1500);
  delay(1500);

  //move forward --not tested
  servoL.writeMicroseconds(1700);
  servoR.writeMicroseconds(1300);
  delay(57 00);

  //end
  servoL.detach();
  servoR.detach();

 
  
}

void lineTracking(){
    DDRD |= B11110000;                         // Set direction of Arduino pins D4-D7 as OUTPUT
    PORTD |= B11110000;                        // Set level of Arduino pins D4-D7 to HIGH
    delayMicroseconds(230);                    // Short delay to allow capacitor charge in QTI module
    DDRD &= B00001111;                         // Set direction of pins D4-D7 as INPUT
    PORTD &= B00001111;                        // Set level of pins D4-D7 to LOW
    delayMicroseconds(230);                    // Short delay
    int pins = PIND;                           // Get values of pins D0-D7
    pins >>= 4;                                // Drop off first four bits of the port; keep only pins D4-D7
  
    Serial.println(pins, BIN);                 // Display result of D4-D7 pins in Serial Monitor
  
    // Determine how to steer based on state of the four QTI sensors
    int vL, vR;
    switch(pins){                               // Compare pins to known line following states
      case B1000:                        
        vL = -100;                             // -100 to 100 indicate course correction values
        vR = 100;                              // -100: full reverse; 0=stopped; 100=full forward
        break;
      case B1100:                        
        vL = 0;
        vR = 100;
        break;
      case B0100:                        
        vL = 50;
        vR = 100;
        break;
      case B0110:                        
        vL = 100;
        vR = 100;
        break;
      case B0010:                        
        vL = 100;
        vR = 50;
        break;
      case B0011:                        
        vL = 100;
        vR = 0;
        break;
      case B0001:                        
        vL = 100;
        vR = -100;
        break;
      case B1111:
        vL = 100;
        vR = 100;
        break;
    }
  
    servoL.writeMicroseconds(1500 + vL);      // Steer robot to recenter it over the line
    servoR.writeMicroseconds(1500 - vR);
  
    delay(50);                                // Delay for 50 milliseconds (1/20 second)
}

void loop(){
}
