import 'package:flutter/material.dart';
import 'package:smarthome/services/BlynkService.dart';

class TemperatureSensorPage extends StatefulWidget {
  final BlynkService blynkService;
  final String pin;

  TemperatureSensorPage({required this.blynkService, required this.pin});

  @override
  _TemperatureSensorPageState createState() => _TemperatureSensorPageState();
}

class _TemperatureSensorPageState extends State<TemperatureSensorPage> {
  double temperature = 20.0; // Default temperature
  final double maxTemperature = 100.0; // Maximum temperature for the meter

  @override
  void initState() {
    super.initState();
    _fetchTemperature();
  }

  Future<void> _fetchTemperature() async {
    try {
      String tempValue = await widget.blynkService.readPin(widget.pin);
      setState(() {
        temperature = double.tryParse(tempValue) ?? temperature;
      });
    } catch (e) {
      print('Error fetching temperature: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Temperature Sensor'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            temperature != null
                ? Column(
                    children: [
                      Text(
                        'Temperature: ${temperature.toStringAsFixed(2)} °C',
                        style: TextStyle(fontSize: 24),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: 300,
                        height: 20,
                        child: Stack(
                          children: [
                            Container(
                              width: 300,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            Container(
                              width: (300 * temperature / maxTemperature)
                                  .clamp(0.0, 300.0),
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
