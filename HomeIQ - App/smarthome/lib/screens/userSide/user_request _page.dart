import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class LeaveRequestPage extends StatefulWidget {
  @override
  _LeaveRequestPageState createState() => _LeaveRequestPageState();
}

class _LeaveRequestPageState extends State<LeaveRequestPage> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _leaveReason;
  DateTime? _startDate;
  DateTime? _endDate;
  File? _uploadedLetter;

  Future<void> _pickLetter() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _uploadedLetter = File(pickedFile.path);
      });
    }
  }

  void _submitRequest() {
    if (_formKey.currentState!.validate() && _uploadedLetter != null) {
      // Handle form submission and upload the letter
      print('Name: $_name');
      print('Leave Reason: $_leaveReason');
      print('Leave Dates: $_startDate to $_endDate');
      print('Letter Uploaded: ${_uploadedLetter!.path}');

      // Clear the form
      _formKey.currentState!.reset();
      setState(() {
        _uploadedLetter = null;
      });
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Leave request submitted successfully!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all fields and upload a letter.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leave Request'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Your Name'),
                validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
                onChanged: (value) => _name = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Leave Reason'),
                validator: (value) => value!.isEmpty ? 'Please enter a reason for your leave' : null,
                onChanged: (value) => _leaveReason = value,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Leave Start Date: ${_startDate != null ? _startDate!.toLocal().toString().split(' ')[0] : 'Select Date'}'),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _startDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != _startDate) {
                        setState(() {
                          _startDate = picked;
                        });
                      }
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Leave End Date: ${_endDate != null ? _endDate!.toLocal().toString().split(' ')[0] : 'Select Date'}'),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _endDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != _endDate) {
                        setState(() {
                          _endDate = picked;
                        });
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _pickLetter,
                child: Text(_uploadedLetter == null ? 'Upload Leave Letter' : 'Letter Uploaded'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitRequest,
                child: Text('Submit Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
