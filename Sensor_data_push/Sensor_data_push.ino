#define BLYNK_TEMPLATE_ID "TMPL3cEB67lyb"
#define BLYNK_TEMPLATE_NAME "Test"

#define BLYNK_PRINT Serial
#define BLYNK_DEVICE_NAME "Dev1"  

#include <WiFi.h>
#include <WiFiClient.h>
#include <BlynkSimpleEsp32.h>
#include "DHT.h"

char auth[] = "BRDMR-_efMmYcrURqYIi8C1h4kkRyHri";

char ssid[] = "Pranav";
char pass[] = "Pranav0811";

#define DHTPIN 32         

#define LDRPIN 12
#define gassense 13
#define DUSTsense 14
#define DHTTYPE DHT11     
#define BLYNK_TEMPLATE_ID "TMPL3cEB67lyb"
#define BLYNK_TEMPLATE_NAME "Test"
#define BLYNK_AUTH_TOKEN "BRDMR-_efMmYcrURqYIi8C1h4kkRyHri"
DHT dht(DHTPIN, DHTTYPE);
BlynkTimer timer;
BLYNK_WRITE(V4) 
{
    if(param.asInt() == 1)
    {
      digitalWrite(33,HIGH);  // Set digital pin 2 HIGH
    }
     else
     {
      digitalWrite(33,LOW);  // Set digital pin 2 LOW    
     }
}
void sendSensor()
{
  float h = dht.readHumidity();
  float t = dht.readTemperature(); 
  float am=analogRead(LDRPIN);
  float g=analogRead(gassense);
  float p = analogRead(DUSTsense);
  if (isnan(h) || isnan(t)) {
    Serial.println("Failed to read from DHT sensor!");
    return;
  }
  Blynk.virtualWrite(V0, h); 
  Blynk.virtualWrite(V1, t); 
  Blynk.virtualWrite(V2, am);
  Blynk.virtualWrite(V3, g);
  Blynk.virtualWrite(V4, p);

}

void setup()
{
  Serial.begin(74880);
  delay(1000);
  Blynk.begin(auth, ssid, pass);
  dht.begin();
  timer.setInterval(1000L, sendSensor);
  pinMode(33,OUTPUT);
}
void loop()
{
  Blynk.run();
  timer.run();
}