void setup() {
  Serial.begin(9600);
}

void loop() {
  int a =  analogRead(A0);
  int b =  analogRead(A1);
  int c =  analogRead(A2);
  int d =  analogRead(A3);
  int e =  analogRead(A4);
  int f =  analogRead(A5);

  Serial.print(a);
  Serial.print(",");
  Serial.print(b);
  Serial.print(",");
  Serial.print(c);
  Serial.print(",");
  Serial.print(d);
  Serial.print(",");
  Serial.print(e);
  Serial.print(",");
  Serial.println(f);
  delay(10);
  
}
