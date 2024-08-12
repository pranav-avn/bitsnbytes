import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smarthome/Authentications/healthScreen1.dart';
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
  late TextEditingController _dietController = TextEditingController();
  final TextEditingController _waterIntakeController = TextEditingController();
  String? _smokingStatus;
  String? _alcoholConsumption;
  String? _caffeineIntake;
  String? _stressLevel;
  String? _mentalHealth;
  late String _selectedAcoholConsumption = "None";
  late String _selectedSmokinStatus = "Never";
  late String _selectedcaffeineIntake = "Often";
  late String _selectedmentalHealth = "Choose mental Health status";
  late String _selectedDiet = "Select Dietary Type";
  late String _selectedSleepQuality = "Choose Sleep Quality";
  String _selectedWaterUnit = 'liter';

  Future<void> _submitData() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc('userId')
          .update({
        'sleep_duration': _sleepDurationController.text ?? 'Not mentioned',
        'sleep_quality': _sleepQuality ?? 'Not mentioned',
        'dietary_habits': _dietController.text ?? 'Not mentioned',
        'daily_water_intake': _waterIntakeController.text ?? 'Not mentioned',
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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _sleepDurationController,
                decoration:
                    InputDecoration(labelText: 'Sleep Duration (hours)'),
                keyboardType: TextInputType.number,
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Please enter sleep duration';
                //   }
                //   return null;
                // },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Sleep Quality"),
                  DropdownButton<String>e(
                    value: _selectedSleepQuality,
                    items: ['Good', 'Poor', 'Disturbed'].map((String quality) {
                      return DropdownMenuItem<String>(
                        value: quality,
                        child: Text(quality),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSleepQuality = value!;
                        _sleepQuality = value;
                      });
                    },
                  ),
                ],
              ),

              SizedBox(height: 9),
              Text("Food Preferrences"),
              DropdownButton<String>(
                items: ['Vegetarian', 'Vegan', 'Non-Vegetarian']
                    .map((String quality) {
                  return DropdownMenuItem<String>(
                    value: quality,
                    child: Text(quality),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _dietController.text = "${_dietController.text} $value";
                  });
                },
              ),
              SizedBox(height: 9),
              TextFormField(
                controller: _waterIntakeController,
                decoration: InputDecoration(labelText: 'Water Intake'),
                keyboardType: TextInputType.number,
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Please enter Water intake';
                //   }
                //   return null;
                // },
              ),
              DropdownButton<String>(
                items: ['liter', 'ounces'].map((String quality) {
                  return DropdownMenuItem<String>(
                    value: _selectedWaterUnit,
                    child: Text(quality),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedWaterUnit = value!;
                    _waterIntakeController.text =
                        "${_waterIntakeController.text} $value";
                  });
                },
              ),

              SizedBox(height: 9),
              DropdownButton<String>(
                items: ['Non-Smoker', 'Occasional Smoker', 'Regular Smoker']
                    .map((String quality) {
                  return DropdownMenuItem<String>(
                    value: quality,
                    child: Text(quality),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _smokingStatus = value;
                  });
                },
              ),
              SizedBox(height: 9),
              DropdownButton<String>(
                items:
                    ['None', 'Occasionally', 'Regularly'].map((String quality) {
                  return DropdownMenuItem<String>(
                    value: quality,
                    child: Text(quality),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _caffeineIntake = value;
                  });
                },
              ),
              SizedBox(height: 9),
              DropdownButton<String>(
                items: ['Anxiety', 'Depression', 'Mood Swings']
                    .map((String quality) {
                  return DropdownMenuItem<String>(
                    value: quality,
                    child: Text(quality),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _mentalHealth = value;
                  });
                },
              ),
              // Similar fields for diet, water intake, smoking, etc.
              ElevatedButton(
                onPressed: _submitData,
                child: Text('Submit & Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
