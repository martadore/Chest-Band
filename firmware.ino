int heartmonitor;     //the analog reading from the ECG sensor
int fsrReading;      // the analog reading from the FSR resistor divider

void setup() {
  Serial.begin(115200);
  pinMode(10, INPUT); // Setup for leads off detection LO +
  pinMode(11, INPUT); // Setup for leads off detection LO -
}

void loop() {
  
  if((digitalRead(10) == 1)||(digitalRead(11) == 1)){
      //Serial.print("!,");
  }
  else{
    // send the value of analog input 0:
      heartmonitor = analogRead(A0);
      Serial.print(heartmonitor);
      Serial.print(",");
      fsrReading = analogRead(A1);
      Serial.print(fsrReading);
      Serial.print(",\n");
  }
  //Wait for a bit to keep serial data from saturating
  delay(100);
}
