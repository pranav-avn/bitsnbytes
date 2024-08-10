import 'package:flutter/material.dart';
import 'package:smarthome/services/BlynkService.dart';

class RfidSensorPage extends StatefulWidget {
  final BlynkService blynkService;
  final String pin;

  RfidSensorPage({required this.blynkService, required this.pin});

  @override
  _RfidSensorPageState createState() => _RfidSensorPageState();
}

class _RfidSensorPageState extends State<RfidSensorPage> {
  String rfidStatus = 'Loading...';

  @override
  void initState() {
    super.initState();
    fetchRfidStatus();
  }

  Future<void> fetchRfidStatus() async {
    try {
      String rfidValue = await widget.blynkService.readPin(widget.pin);
      setState(() {
        rfidStatus = rfidValue == '1' ? 'RFID detected' : 'RFID not detected';
      });
    } catch (e) {
      setState(() {
        rfidStatus = 'Error fetching RFID status: $e';
      });
      print('Error fetching RFID status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RFID Sensor'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              rfidStatus,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchRfidStatus,
              child: Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }
}
