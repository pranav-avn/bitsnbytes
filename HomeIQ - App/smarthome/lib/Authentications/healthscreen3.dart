import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class healthscreen3 extends StatefulWidget {
  @override
  _healthscreen3State createState() => _healthscreen3State();
}

class _healthscreen3State extends State<healthscreen3> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _chronicConditionsController =
      TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();
  final TextEditingController _familyHistoryController =
      TextEditingController();
  final TextEditingController _surgicalHistoryController =
      TextEditingController();
  final TextEditingController _recentIllnessesController =
      TextEditingController();
  final TextEditingController _previousInjuriesController =
      TextEditingController();

  List<String> _allergies = [];
  List<String> _family_medical_history = [];
  List<String> _prev_injuries = [];
  List<String> _recent_illness = [];
  List<String> _surgical_histories = [];
  List<String> _chronic_conditions = [];

  void _addAllergy() {
    if (_allergiesController.text.isNotEmpty) {
      setState(() {
        _allergies.add(_allergiesController.text);
        _allergiesController.clear();
      });
    }
  }

  void _add_family_medical_history() {
    if (_familyHistoryController.text.isNotEmpty) {
      setState(() {
        _family_medical_history.add(_familyHistoryController.text);
        _familyHistoryController.clear();
      });
    }
  }

  void _add_prev_injuries() {
    if (_previousInjuriesController.text.isNotEmpty) {
      setState(() {
        _prev_injuries.add(_previousInjuriesController.text);
        _previousInjuriesController.clear();
      });
    }
  }

  void _add_recent_illness() {
    if (_recentIllnessesController.text.isNotEmpty) {
      setState(() {
        _recent_illness.add(_recentIllnessesController.text);
        _recentIllnessesController.clear();
      });
    }
  }

  void _add_chronic_conditions() {
    if (_chronicConditionsController.text.isNotEmpty) {
      setState(() {
        _chronic_conditions.add(_chronicConditionsController.text);
        _chronicConditionsController.clear();
      });
    }
  }

  void _add_surgical_histories() {
    if (_surgicalHistoryController.text.isNotEmpty) {
      setState(() {
        _surgical_histories.add(_surgicalHistoryController.text);
        _surgical_histories.clear();
      });
    }
  }

  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc('userId')
            .update({
          'chronic_conditions': _chronic_conditions.isNotEmpty
              ? _chronic_conditions
              : ['Not mentioned'],
          'allergies': _allergies.isNotEmpty ? _allergies : ['Not mentioned'],
          'family_medical_history': _family_medical_history.isNotEmpty
              ? _family_medical_history
              : ['Not mentioned'],
          'surgical_history': _surgical_histories.isNotEmpty
              ? _surgical_histories
              : ['Not mentioned'],
          'recent_illnesses':
              _recent_illness.isNotEmpty ? _recent_illness : ['Not mentioned'],
          'previous_injuries':
              _prev_injuries.isNotEmpty ? _prev_injuries : ['Not mentioned'],
        });
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medical History'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _chronicConditionsController,
                decoration: InputDecoration(labelText: 'Chronic Conditions'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter chronic conditions';
                  }
                  return null;
                },
              ),
              SizedBox(height: 9),
              TextFormField(
                controller: _chronicConditionsController,
                decoration: InputDecoration(labelText: 'Chronic Conditions'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter chronic conditions';
                  }
                  return null;
                },
              ),
              SizedBox(height: 9),
              TextFormField(
                controller: _allergiesController,
                decoration: InputDecoration(labelText: 'Allergies'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Allergic reactions';
                  }
                  return null;
                },
              ),
              SizedBox(height: 9),
              TextFormField(
                controller: _familyHistoryController,
                decoration: InputDecoration(
                    labelText: 'Family medical Conditions if any'),
              ),
              SizedBox(height: 9),
              TextFormField(
                controller: _surgicalHistoryController,
                decoration:
                    InputDecoration(labelText: 'Surgical History if any'),
              ),
              SizedBox(height: 9),
              TextFormField(
                controller: _recentIllnessesController,
                decoration: InputDecoration(labelText: 'Recent/Last Illness'),
              ),
              SizedBox(height: 9),
              TextFormField(
                controller: _previousInjuriesController,
                decoration:
                    InputDecoration(labelText: 'Previous Injuries If any'),
              ),
              SizedBox(height: 9),
              // Similar fields for allergies, family history, etc.
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
