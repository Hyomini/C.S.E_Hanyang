const int ledPin=13;
int blinkRate=0;
int value = 0;

void setup()
{
  Serial.begin(9600);
  pinMode(ledPin,OUTPUT);
}
void loop()
{  
    if(Serial.available())
    {
      char ch = Serial.read();
      if(isDigit(ch))
      {
        value = (value*10)+(ch-'0');
      }
      else if(ch == 10)
      {
        blinkRate=value;
        Serial.print("delay : ");
        Serial.print(blinkRate);
        Serial.println("ms");
        value=0;
      }
    }
  blink();
}
void blink()
{
  digitalWrite(ledPin,HIGH);
  delay(blinkRate);
  digitalWrite(ledPin,LOW);
  delay(blinkRate);
}
