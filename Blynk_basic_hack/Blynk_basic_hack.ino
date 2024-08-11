#define BLYNK_TEMPLATE_ID "TMPL3cEB67lyb"
#define BLYNK_TEMPLATE_NAME "Test"

#define BLYNK_PRINT Serial
#define BLYNK_DEVICE_NAME "Dev1"  

#include <WiFi.h>
#include <WiFiClient.h>
#include <BlynkSimpleEsp32.h>
#include "DHT.h"

// You should get Auth Token in the Blynk App.
// Go to the Project Settings (nut icon).
char auth[] = "eGTiuLVeg2GRGqbN1YdVib6ByTvjBA_V";//Paste auth token you copied

// Your WiFi credentials.
// Set password to "" for open networks.
char ssid[] = "Pranav";///Enter your wifi name
char pass[] = "Pranav0811";// Enter wifi password

#define DHTPIN 32         // What digital pin we're connected to select yours accordingly

// Uncomment whatever type you're using!
#define DHTTYPE DHT11     // DHT 11
//#define DHTTYPE DHT22   // DHT 22, AM2302, AM2321
//#define DHTTYPE DHT21   // DHT 21, AM2301

DHT dht(DHTPIN, DHTTYPE);
BlynkTimer timer;
void sendSensor()
{
  float h = dht.readHumidity();
  float t = dht.readTemperature(); 
  if (isnan(h) || isnan(t)) {
    Serial.println("Failed to read from DHT sensor!");
    return;
  }
  Blynk.virtualWrite(V0, h); 
  Blynk.virtualWrite(V1, t); 
}

void setup()
{
  Serial.begin(74880);
  delay(1000);
  Blynk.begin(auth, ssid, pass);
  dht.begin();
  timer.setInterval(1000L, sendSensor);
}
void loop()
{
  float h = dht.readHumidity();
  Serial.println(h);
  Blynk.run();
  timer.run();
}