import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smarthome/Authentications/healthscreen3.dart';

class healthscreen2 extends StatefulWidget {
  @override
  _healthscreen2State createState() => _healthscreen2State();
}

class _healthscreen2State extends State<healthscreen2> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _sleepDurationController =
      TextEditingController();
  String? _sleepQuality;
  final TextEditingController _dietController = TextEditingController();
  final TextEditingController _waterIntakeController = TextEditingController();
  String? _smokingStatus;
  String? _alcoholConsumption;
  String? _caffeineIntake;
  String? _stressLevel;
  String? _mentalHealth;
  String? _selectedSleepQuality;
  String? _selectedDiet;
  String? _selectedWaterUnit;

  List<String> sleepQualityOptions = ['Good', 'Poor', 'Disturbed'];
  List<String> dietOptions = ['Vegetarian', 'Vegan', 'Non-Vegetarian'];
  List<String> waterUnitOptions = ['liter', 'ounces'];
  List<String> smokingStatusOptions = [
    'Non-Smoker',
    'Occasional Smoker',
    'Regular Smoker'
  ];
  List<String> caffeineOptions = ['None', 'Occasionally', 'Regularly'];
  List<String> mentalHealthOptions = ['Anxiety', 'Depression', 'Mood Swings'];

  Future<void> _submitData() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc('userId')
          .update({
        'sleep_duration': _sleepDurationController.text.isNotEmpty
            ? _sleepDurationController.text
            : 'Not mentioned',
        'sleep_quality': _sleepQuality ?? 'Not mentioned',
        'dietary_habits': _dietController.text.isNotEmpty
            ? _dietController.text
            : 'Not mentioned',
        'daily_water_intake': _waterIntakeController.text.isNotEmpty
            ? _waterIntakeController.text
            : 'Not mentioned',
        'smoking_status': _smokingStatus ?? 'Not mentioned',
        'alcohol_consumption': _alcoholConsumption ?? 'Not mentioned',
        'caffeine_intake': _caffeineIntake ?? 'Not mentioned',
        'stress_level': _stressLevel ?? 'Not mentioned',
        'mental_health': _mentalHealth ?? 'Not mentioned',
      });
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => healthscreen3()));
    } catch (e) {
      print('ERRORRRR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lifestyle Information'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _waterIntakeController,
                  decoration:
                      InputDecoration(labelText: 'Enter your Water intake'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16.0),
                DropdownButton<String>(
                  value: _selectedWaterUnit,
                  items: waterUnitOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedWaterUnit = newValue!;
                    });
                  },
                ),
                SizedBox(height: 16.0),
                DropdownButton<String>(
                  value: _sleepQuality,
                  items: sleepQualityOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _sleepQuality = newValue;
                    });
                  },
                ),
                SizedBox(height: 16.0),
                DropdownButton<String>(
                  value: _selectedDiet,
                  items: dietOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedDiet = newValue!;
                    });
                  },
                ),
                SizedBox(height: 16.0),
                DropdownButton<String>(
                  value: _smokingStatus,
                  items: smokingStatusOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _smokingStatus = newValue!;
                    });
                  },
                ),
                SizedBox(height: 16.0),
                DropdownButton<String>(
                  value: _caffeineIntake,
                  items: caffeineOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _caffeineIntake = newValue!;
                    });
                  },
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: TextEditingController(text: _alcoholConsumption),
                  decoration:
                      InputDecoration(labelText: 'Alcohol Consumption :'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _alcoholConsumption = value;
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _submitData,
                  child: Text('Submit & Next'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
