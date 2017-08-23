#include <LiquidCrystal.h>


LiquidCrystal LCD (12 , 11 , 5 , 4 , 3 , 2);
char i;
void setup()
{
  LCD.begin(16,2);
  LCD.setCursor(5,0);
  Serial.begin(9600);
  
}

void loop() 
{
//  Serial.write("A"); //transmitter loop
//  delay(200);
//  Serial.write("B");
//  delay(200);
//  Serial.write("C");
//  delay(200);
  
  while(Serial.available()) //reciever loop
  {
    i=Serial.read();
    LCD.setCursor(5,0);
    LCD.print(i);
  }
  if(i=='A')
  {
    Serial.write(i);
    delay(200);
  }
  if(i=='B')
  {
   Serial.write(i);
  delay(200);
  }
 if(i=='C')
{
 Serial.write(i);
delay(200);
}  
}
