import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class adminFeedbackScreen extends StatelessWidget {
  final TextEditingController replyController = TextEditingController();

  void _replyToFeedback(String feedbackId) {
    FirebaseFirestore.instance.collection('feedbacks').doc(feedbackId).update({
      'reply': replyController.text,
      'isreplied': true,
    });
    replyController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Manage Feedbacks')),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('feedbacks')
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
              return Center(child: Text('No feedbacks found.'));
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var doc = snapshot.data!.docs[index];
                  return ListTile(
                    title: Text(doc['feedback']),
                    subtitle: doc['isreplied'] ?? false
                        ? Text("Replied: ${doc['reply']}")
                        : Text('Not Replied Yet'),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Reply to Feedback"),
                              content: TextField(
                                controller: replyController,
                                decoration:
                                    InputDecoration(labelText: "Enter reply"),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    _replyToFeedback(doc.id);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Submit"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  );
                });
          },
        ));
  }
}
