import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smarthome/Authentications/healthscreen2.dart';

class healthscreen1 extends StatefulWidget {
  @override
  _healthscreen1State createState() => _healthscreen1State();
}

class _healthscreen1State extends State<healthscreen1> {
  final _formKey = GlobalKey<FormState>();
  // Controllers for capturing input data
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _waterIntakeController = TextEditingController();

  String? _gender;
  final TextEditingController _bmiController = TextEditingController();
  final TextEditingController _waistController = TextEditingController();
  final TextEditingController _hipController = TextEditingController();
  final TextEditingController _neckController = TextEditingController();

  // Method to submit data
  Future<void> _submitData() async {
    final User? firebaseUser = FirebaseAuth.instance.currentUser;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser?.uid)
          .set({
        'height': _heightController.text ?? '152',
        'weight': _weightController.text ?? '56',
        'age': _ageController.text ?? 35,
        'gender': _gender ?? 'Male',
        'bmi': _bmiController.text ?? 30,
      });
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => healthscreen2()));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('General Metrics'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _heightController,
                decoration: InputDecoration(labelText: 'Height'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(width: 16.0),
              SizedBox(height: 9),
              TextField(
                controller: _weightController,
                decoration: InputDecoration(labelText: 'Weight'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(width: 16.0),
              SizedBox(height: 9),
              TextField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Please enter your Age';
                //   }
                //   return null;
                // },
              ),
              SizedBox(height: 9),
              Row(
                children: [
                  Text("Gender : "),
                  DropdownButton<String>(
                    value: _gender,
                    items: ['Male', 'Female', 'Prefer not to say']
                        .map((String gender) {
                      return DropdownMenuItem<String>(
                        value: gender,
                        child: Text(gender),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 9),
              TextField(
                controller: _bmiController,
                decoration: InputDecoration(labelText: 'BMI'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                // controller: _waterIntakeController,
                decoration:
                    InputDecoration(labelText: 'Enter your Water intake'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 9),
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
