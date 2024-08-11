import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class sensorUi extends StatefulWidget {
  const sensorUi({super.key});

  @override
  State<sensorUi> createState() => _sensorUiState();
}

class _sensorUiState extends State<sensorUi> {
  double ambLightSliderValue = 10.0;

  Widget LedSwitch() {
    return LiteRollingSwitch(
      value: false,
      iconOn: Icons.lightbulb,
      iconOff: Icons.lightbulb_outline_rounded,
      colorOn: Colors.yellow,
      colorOff: Colors.grey,
      onTap: () {},
      onDoubleTap: () {},
      onSwipe: () {},
      onChanged: (bool state) {
        print('Current State of SWITCH IS: $state');
      },
    );
  }

  Widget ambLightSlider() {
    return SfSlider(
      min: 0.0,
      max: 100.0,
      value: ambLightSliderValue,
      showTicks: false,
      enableTooltip: true,
      activeColor: CupertinoColors.systemYellow,
      inactiveColor: Colors.grey,
      onChanged: (dynamic value) {
        setState(() {
          ambLightSliderValue = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [LedSwitch(), SizedBox(height: 10), ambLightSlider()],
        ),
      ),
    );
  }
}
