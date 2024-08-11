import 'package:flutter/material.dart';
import 'package:smarthome/services/BlynkService.dart';

class SoilMoistureSensorPage extends StatefulWidget {
  final BlynkService blynkService;
  final String pin;

  SoilMoistureSensorPage({required this.blynkService, required this.pin});

  @override
  _SoilMoistureSensorPageState createState() => _SoilMoistureSensorPageState();
}

class _SoilMoistureSensorPageState extends State<SoilMoistureSensorPage> {
  double soilMoisture = 45.0; // Dummy value

  @override
  void initState() {
    super.initState();
    // Commented out to use dummy value
    // fetchSoilMoisture();
  }

  // Commented out since we're using a dummy value
  // Future<void> fetchSoilMoisture() async {
  //   try {
  //     String moistureValue = await widget.blynkService.readPin(widget.pin);
  //     setState(() {
  //       soilMoisture = double.parse(moistureValue);
  //     });
  //   } catch (e) {
  //     setState(() {
  //       soilMoisture = null;
  //     });
  //     print('Error fetching soil moisture data: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Soil Moisture Sensor'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Soil Moisture: ${soilMoisture.toStringAsFixed(2)}%',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Optional: Update the dummy value when refreshing
                setState(() {
                  soilMoisture = (soilMoisture + 5) % 100; // Example logic
                });
              },
              child: Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }
}
