import 'package:flutter/material.dart';
import 'package:smarthome/services/BlynkService.dart';

class DustSensorPage extends StatefulWidget {
  final BlynkService blynkService;
  final String pin;

  DustSensorPage({required this.blynkService, required this.pin});

  @override
  _DustSensorPageState createState() => _DustSensorPageState();
}

class _DustSensorPageState extends State<DustSensorPage> {
  double dustLevel = 50.0; // Default dust level
  final double maxDustLevel = 100.0; // Maximum dust level for the meter

  @override
  void initState() {
    super.initState();
    _fetchDustLevel();
  }

  Future<void> _fetchDustLevel() async {
    try {
      String dustValue = await widget.blynkService.readPin(widget.pin);
      setState(() {
        dustLevel = double.tryParse(dustValue) ?? dustLevel;
      });
    } catch (e) {
      print('Error fetching dust level: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dust Sensor'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Dust Level: ${dustLevel.toStringAsFixed(2)}',
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
                    width: (300 * dustLevel / maxDustLevel).clamp(0.0, 300.0),
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchDustLevel,
              child: Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }
}
