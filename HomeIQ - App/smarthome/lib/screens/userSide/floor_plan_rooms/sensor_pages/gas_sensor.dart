import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'dart:async';
import 'dart:math';
import 'package:smarthome/services/BlynkService.dart';

class GasSensorPage extends StatefulWidget {
  final BlynkService blynkService;
  final String pin;

  GasSensorPage({required this.blynkService, required this.pin});

  @override
  _GasSensorPageState createState() => _GasSensorPageState();
}

class _GasSensorPageState extends State<GasSensorPage> {
  double _gasLevel = 500.0; // Initial dummy value

  @override
  void initState() {
    super.initState();
    _startUpdatingGasLevel();
  }

  void _startUpdatingGasLevel() {
    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        _gasLevel = Random()
            .nextInt(1024)
            .toDouble(); // Random value between 0 and 1023
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gas Sensor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Gas Level: ${_gasLevel.toInt()}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            SfRadialGauge(
              axes: <RadialAxis>[
                RadialAxis(
                  minimum: 0,
                  maximum: 1023, // Assuming sensor range is 0-1023
                  ranges: <GaugeRange>[
                    GaugeRange(
                      startValue: 0,
                      endValue: 340,
                      color: Colors.green,
                    ),
                    GaugeRange(
                      startValue: 341,
                      endValue: 680,
                      color: Colors.orange,
                    ),
                    GaugeRange(
                      startValue: 681,
                      endValue: 1023,
                      color: Colors.red,
                    ),
                  ],
                  pointers: <GaugePointer>[
                    NeedlePointer(value: _gasLevel),
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                      widget: Container(
                        child: Text(
                          '${_gasLevel.toInt()}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      angle: 90,
                      positionFactor: 0.5,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
