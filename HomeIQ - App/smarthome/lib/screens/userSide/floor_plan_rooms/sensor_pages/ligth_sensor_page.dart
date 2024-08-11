import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:smarthome/services/BlynkService.dart';

class LedControlPage extends StatefulWidget {
  final BlynkService blynkService;
  final String pin;
  final int? people;

  LedControlPage({required this.blynkService, required this.pin, this.people});

  @override
  _LedControlPageState createState() => _LedControlPageState();
}

class _LedControlPageState extends State<LedControlPage> {
  bool ledStatus = false;
  double ledBrightness = 50.0; // Dummy value for brightness (0-100)

  @override
  void initState() {
    super.initState();
    _fetchInitialLEDStatus();
    if (widget.people == 0) {
      widget.blynkService.writePin(widget.pin, '0');
    }
  }

  Future<void> _fetchInitialLEDStatus() async {
    // Dummy implementation for fetching LED status and brightness
    setState(() {
      ledStatus = '1' == widget.blynkService.readPin('v4');
      // Set to true as default
      ledBrightness = 50.0; // Dummy brightness value
    });
  }

  void _onLedSwitchChanged(bool state) async {
    try {
      await widget.blynkService.writePin(widget.pin, state ? '1' : '0');
      print("LED Light changed");
      setState(() {
        ledStatus = state;
      });
    } catch (e) {
      print('Error updating LED status: $e');
    }
  }

  void _onSliderChanged(double value) {
    setState(() {
      ledBrightness = value;
    });
    // Optionally update the brightness value in Blynk
    // await widget.blynkService.writePin('V2', value.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LED Control'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LiteRollingSwitch(
              value: ledStatus,
              onDoubleTap: () {},
              onTap: () {},
              onSwipe: () {},
              textOn: "ON",
              textOff: "OFF",
              iconOn: Icons.lightbulb,
              iconOff: Icons.lightbulb_outline_rounded,
              colorOn: Colors.yellow,
              colorOff: Colors.grey,
              onChanged: _onLedSwitchChanged,
            ),
            SizedBox(height: 20),
            Text(
              'Brightness: ${ledBrightness.toStringAsFixed(0)}%',
              style: TextStyle(fontSize: 20),
            ),
            Slider(
              value: ledBrightness,
              min: 0.0,
              max: 100.0,
              divisions: 100,
              onChanged: _onSliderChanged,
              activeColor: Colors.yellow,
              inactiveColor: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
