import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smarthome/screens/userSide/MyFeedbacks.dart';
import 'package:smarthome/tools/UiComponents.dart';

class UserFeedbackScreen extends StatefulWidget {
  @override
  _UserFeedbackScreenState createState() => _UserFeedbackScreenState();
}

class _UserFeedbackScreenState extends State<UserFeedbackScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  final String? userId =
      FirebaseAuth.instance.currentUser?.uid; // Replace with actual user ID

  void _submitFeedback() {
    if (_feedbackController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection('feedbacks').add({
        'userid': userId,
        'feedback': _feedbackController.text,
        'timestamp': FieldValue.serverTimestamp(),
        'reply': '',
        'isreplied': false,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Your Feedback has been added successfully')),
      );
      _feedbackController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Submit Feedback',
          style: buttonTstlye(),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _feedbackController,
              decoration: InputDecoration(labelText: 'Your Feedback'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: BtnStyle(),
              onPressed: _submitFeedback,
              child: Text(
                'Submit',
                style: buttonTstlye(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UserFeedbackListScreen()));
        },
        child: Icon(Icons.history),
      ),
    );
  }
}
