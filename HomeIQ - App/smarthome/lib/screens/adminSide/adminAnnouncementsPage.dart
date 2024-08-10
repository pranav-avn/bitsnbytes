import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/screens/adminSide/adminFeedbackScreen.dart';

class adminAnnouncementScreen extends StatefulWidget {
  @override
  _adminAnnouncementScreenState createState() =>
      _adminAnnouncementScreenState();
}

class _adminAnnouncementScreenState extends State<adminAnnouncementScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController editTitleController = TextEditingController();
  final TextEditingController editContentController = TextEditingController();

  void _addAnnouncement() {
    FirebaseFirestore.instance.collection('announcements').add({
      'title': titleController.text,
      'content': contentController.text,
      'timestamp': Timestamp.now(),
    });
    titleController.clear();
    contentController.clear();
  }

  void _editAnnouncement(String announcementId) {
    FirebaseFirestore.instance
        .collection('announcements')
        .doc(announcementId)
        .update({
      'title': editTitleController.text,
      'content': editContentController.text,
    });
    editTitleController.clear();
    editContentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Announcements'),
      ),
      body: Column(
        children: [
          Container(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Card(
                color: Colors.purple.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Add Announcement',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                            labelText: 'Title',
                            fillColor: Colors.white,
                            filled: true),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: contentController,
                        decoration: InputDecoration(
                            labelText: 'Content',
                            fillColor: Colors.white,
                            filled: true),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _addAnnouncement,
                        child: Text('Submit'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('announcements')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
                  return Center(child: Text('No announcements found.'));
                }

                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    return ListTile(
                      title: Text(doc['title']),
                      subtitle: Text(doc['content']),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          editTitleController.text = doc['title'];
                          editContentController.text = doc['content'];
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Edit Announcement"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: editTitleController,
                                      decoration:
                                          InputDecoration(labelText: "Title"),
                                    ),
                                    TextField(
                                      controller: editContentController,
                                      decoration:
                                          InputDecoration(labelText: "Content"),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      _editAnnouncement(doc.id);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Save"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => adminFeedbackScreen()));
        },
        child: Icon(Icons.feedback),
      ),
    );
  }
}
