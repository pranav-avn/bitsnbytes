import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smarthome/services/BlynkService.dart';

class HumiditySensorPage extends StatefulWidget {
  final BlynkService blynkService;
  final String pin;

  HumiditySensorPage({required this.blynkService, required this.pin});

  @override
  _HumiditySensorPageState createState() => _HumiditySensorPageState();
}

class _HumiditySensorPageState extends State<HumiditySensorPage> {
  String humidity = 'Loading...';

  @override
  void initState() {
    super.initState();
    fetchHumidity();
  }

  Future<void> fetchHumidity() async {
    try {
      String humValue = await widget.blynkService.readPin(widget.pin);
      setState(() {
        humidity = humValue;
      });
    } catch (e) {
      print('Error fetching humidity data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Humidity Sensor'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Humidity: $humidity',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchHumidity,
              child: Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }
}
