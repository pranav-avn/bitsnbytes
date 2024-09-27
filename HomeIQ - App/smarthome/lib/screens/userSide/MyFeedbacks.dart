import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smarthome/tools/UiComponents.dart';

class UserFeedbackListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String? userid = FirebaseAuth.instance.currentUser?.uid;

    if (userid == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'My Feedbacks',
            style: buttonTstlye(),
          ),
          backgroundColor: Colors.teal,
        ),
        body: Center(child: Text('User not logged in')),
      );
    }

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text(
            'My Feedbacks',
            style: buttonTstlye(),
          )),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('feedbacks')
            .where('userid', isEqualTo: userid)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
            return Center(child: Text('No feedback found.'));
          }
          return ListView.builder(
            itemCount: snapshot.data?.docs.length ?? 0,
            itemBuilder: (context, index) {
              var feedbackData = snapshot.data?.docs[index];
              return ListTile(
                title: Text(feedbackData?['feedback'] ?? ''),
                subtitle: feedbackData?['isreplied'] ?? false
                    ? Text("Admin Reply: ${feedbackData?['reply']}")
                    : Text('No reply yet'),
              );
            },
          );
        },
      ),
    );
  }
}
