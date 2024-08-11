import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:http/http.dart' as http;

class BlynkService {
  final String authToken;
  final String baseUrl = 'http://blynk-cloud.com';

  BlynkService(this.authToken);

  Future<void> writePin(String pin, String value) async {
    try{final url = Uri.parse(
        'https://blr1.blynk.cloud/external/api/update?token=eGTiuLVeg2GRGqbN1YdVib6ByTvjBA_V&v4=$value');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to write pin');
    }}catch(e){print(e);}

  }

  Future<String> readPin(String pin) async {
    final url = Uri.parse('https://blr1.blynk.cloud/external/api/get?token=eGTiuLVeg2GRGqbN1YdVib6ByTvjBA_V&v4');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data[0];
    } else {
      throw Exception('Failed to read pin');
    }
  }
}

class TemperatureSensor extends StatefulWidget {
  const TemperatureSensor({super.key});

  @override
  State<TemperatureSensor> createState() => BlynkFunctions();
}

class BlynkFunctions extends State<TemperatureSensor> {
  final String baseUrl = 'http://blynk-cloud.com';
  final String url =
      'https://blr1.blynk.cloud/external/api/get?token=eGTiuLVeg2GRGqbN1YdVib6ByTvjBA_V&v0';
  Timer? timer;
  String blynkAuthToken =
      'eGTiuLVeg2GRGqbN1YdVib6ByTvjBA_V'; // Replace with your Blynk Auth Token
  //Pins
  String TempPin = 'v1'; // Replace with the virtual pin used for temperature
  String humPin = 'v0'; // Replace with the virtual pin used for humidity
  String dustPin = 'v2';
  String fireSensorPin = 'V1';
  String ledLightPin = 'V1';
  String rfidPin = 'V1';
  String pirPin = 'V1';
  String irPin = 'V1';
  String soilPin = 'V1';
  int count = 0;
  String occupancyPin = 'v2';

  //Values
  String? temperature;
  String? dust;
  String humidity = 'Loading...';
  Timer? _debounce;
  bool ledStatus = false;
  final String pin = 'YOUR_PIN';
  bool rfidHigh = false;
  bool pirHigh = false;
  bool irHigh = false;
  int soilMoistureValue = 0;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
        Duration(seconds: 5), (Timer t) => fetchTemperature(Temppin: TempPin));
    timer = Timer.periodic(
        Duration(seconds: 5), (Timer t) => fetchHumidityData(humPin: humPin));
    timer = Timer.periodic(
        Duration(seconds: 5), (Timer t) => fetchdustData(dustPin: dustPin));
    fetchInitialLEDStatus();
  }

  Future<void> fetchTemperature({String? Temppin}) async {
    try {
      final response = await http.get(Uri.parse(
          'https://blr1.blynk.cloud/external/api/get?token=$blynkAuthToken&$TempPin'));

      if (response.statusCode == 200) {
        double temperatureValue = double.parse(response.body);
        String temperatureString = temperatureValue.toString();
        // String data = json.decode(response.body);
        setState(() {
          temperature = temperatureString;
        });
        // if (_debounce?.isActive ?? false) _debounce!.cancel();
        //       _debounce = Timer(const Duration(milliseconds: 500), () {
        //         setState(() {
        //           temperature = newTemperature;
        //         });
        //       });
      } else {
        print('Failed to fetch temperature data');
      }
    } catch (e) {
      print('Error fetching temperature data: $e');
    }
  }

  Future<void> fetchHumidityData({String? humPin}) async {
    // final String apiUrl =
    //     'http://blynk-cloud.com/$blynkAuthToken/get/$humPin'; // Replace with your API endpoint
    final String apiUrl =
        'https://blr1.blynk.cloud/external/api/get?token=$blynkAuthToken&$humPin';
    try {
      final response = await http.get(Uri.parse(apiUrl));

      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final data = response.body;
        setState(() {
          humidity = '$data';
        });
        // if (_debounce?.isActive ?? false) _debounce!.cancel();
        // _debounce = Timer(const Duration(milliseconds: 500), () {
        //   setState(() {
        //     humidity = data.toString();
        //   });
        // });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print("Error fetching Humidity data : $e");
      setState(() {
        humidity = 'Error loading data';
      });
    }
  }

  Future<void> fetchdustData({String? dustPin}) async {
    // final String apiUrl =
    //     'http://blynk-cloud.com/$blynkAuthToken/get/$humPin'; // Replace with your API endpoint
    final String apiUrl =
        'https://blr1.blynk.cloud/external/api/get?token=$blynkAuthToken&$dustPin';
    try {
      final response = await http.get(Uri.parse(apiUrl));

      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final data = response.body;
        setState(() {
          dust = '$data';
        });
        // if (_debounce?.isActive ?? false) _debounce!.cancel();
        // _debounce = Timer(const Duration(milliseconds: 500), () {
        //   setState(() {
        //     humidity = data.toString();
        //   });
        // });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print("Error fetching Dust data : $e");
      setState(() {
        dust = 'Error loading data';
      });
    }
  }

  //Getting initial status from blynk
  Future<void> fetchInitialLEDStatus() async {
    try {
      bool status = await readLEDStatus();
      setState(() {
        ledStatus = status;
      });
    } catch (e) {
      print('Error fetching initial LED status: $e');
    }
  }

  //reading for updating toggle switch
  Future<bool> readLEDStatus({String? ledPin}) async {
    final response = await http.get(
      Uri.parse('http://blynk-cloud.com/$blynkAuthToken/get/$ledPin'),
    );

    if (response.statusCode == 200) {
      // Blynk returns the pin status in a list format: ["0"] or ["1"]
      return response.body.contains('1');
    } else {
      throw Exception('Failed to read LED status');
    }
  }

  //performs update in blynk
  Future<void> updateLEDStatus({String? ledPin, required bool isOn}) async {
    final status = isOn ? '1' : '0';
    try {
      final response = await http.get(
        Uri.parse(
            'http://blynk-cloud.com/$blynkAuthToken/update/$ledPin?value=$status'),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update LED status');
      }
    } catch (e) {
      print("Error while updating LED status : $e");
    }
  }

  void onLedSwitchChanged(bool state) async {
    try {
      await updateLEDStatus(isOn: state);
      setState(() {
        ledStatus = state;
      });
    } catch (e) {
      print('Error updating LED status: $e');
    }
  }

  Future<double?> readFireSensorData({String? firePin}) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/$blynkAuthToken/get/$firePin'), // Replace V1 with your virtual pin
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        // Assuming the response is a list, take the first element as the sensor data
        double sensorValue = double.parse(data[0].toString());
        return sensorValue;
      } else {
        print('Failed to read sensor data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error reading sensor data: $e');
      return null;
    }
  }

  Future<void> _checkOccupancy() async {
    final response =
        await http.get(Uri.parse('$baseUrl/$blynkAuthToken/get/$occupancyPin'));

    if (response.statusCode == 200) {
      final occupancy = response.body;
      if (occupancy == '0' && ledStatus) {
        await _turnOffLight();
      }
    } else {
      print('Failed to get occupancy');
    }
  }

  Future<void> _turnOffLight() async {
    final response = await http
        .get(Uri.parse('$baseUrl/$blynkAuthToken/update/$ledLightPin?value=0'));

    if (response.statusCode == 200) {
      setState(() {
        ledStatus = false;
      });
      print('Light turned off');
    } else {
      print('Failed to turn off light');
    }
  }

  Future<void> get_Rfids_SensorData(
      {String? rfidPin, String? pirpin, String? irpin}) async {
    final responseRfid = await http
        .get(Uri.parse('http://blynk-cloud.com/$blynkAuthToken/get/$rfidPin'));
    final responsePir = await http
        .get(Uri.parse('http://blynk-cloud.com/$blynkAuthToken/get/$pirpin'));
    final responseIr = await http
        .get(Uri.parse('http://blynk-cloud.com/$blynkAuthToken/get/$irpin'));

    if (responseRfid.statusCode == 200 &&
        responsePir.statusCode == 200 &&
        responseIr.statusCode == 200) {
      setState(() {
        rfidHigh = json.decode(responseRfid.body)[0] == "1";
        pirHigh = json.decode(responsePir.body)[0] == "1";
        irHigh = json.decode(responseIr.body)[0] == "1";
      });

      evaluateCheckInOut();
    } else {
      print('Failed to fetch sensor data');
    }
  }

  void evaluateCheckInOut() {
    if (rfidHigh && pirHigh) {
      print('Person has checked in');
      // Implement your check-in logic here
    } else if (pirHigh && !irHigh) {
      print('Security Alert! Deploy measures and start camera analysis');
      // Implement security logic here
    } else if (irHigh && !pirHigh) {
      print('Person has checked out');
      // Implement your check-out logic here
    }
  }

  Future<void> fetchSoilMoistureData({String? soilpin}) async {
    try {
      final response = await http.get(
        Uri.parse('http://blynk-cloud.com/$blynkAuthToken/get/$soilpin'),
      );

      if (response.statusCode == 200) {
        setState(() {
          soilMoistureValue = int.parse(json.decode(response.body)[0]);
        });
      } else {
        print('Failed to fetch data');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Temperature Display'),
      ),
      body: Center(
        child: Column(
          children: [
            temperature != null
                ? Text(
                    'Temperature: $temperature °C',
                    style: TextStyle(fontSize: 24),
                  )
                : Text('Temperature : 40 °C'),
            SizedBox(height: 20),
            Text('Humidity : $humidity', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            dust != null
                ? Text('Dust Sensor: $dust')
                : Text('Dust Sensor : Loading..'),
            LiteRollingSwitch(
              value: ledStatus,
              textOn: "ON",
              textOff: "OFF",
              iconOn: Icons.lightbulb,
              iconOff: Icons.lightbulb_outline_rounded,
              colorOn: Colors.yellow,
              colorOff: Colors.grey,
              onTap: () {},
              onDoubleTap: () {},
              onSwipe: () {},
              onChanged: (bool state) {
                onLedSwitchChanged(state);
              },
            ),
            Text(
              rfidHigh ? 'RFID detected' : 'RFID not detected',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              pirHigh ? 'PIR detected motion' : 'PIR did not detect motion',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              irHigh ? 'IR sensor detected' : 'IR sensor not detected',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: get_Rfids_SensorData,
              child: Text('Refresh Data'),
            ),
            ElevatedButton(
              onPressed: () {
                // Implement manual check-in/out logic here
                print('Manual Check-in/Check-out triggered');
              },
              child: Text('Manual Check-in/Check-out'),
            ),
            SizedBox(height: 10),
            Text(
              'Soil Moisture sensor Value : $soilMoistureValue',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          fetchTemperature;
          fetchHumidityData();
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
