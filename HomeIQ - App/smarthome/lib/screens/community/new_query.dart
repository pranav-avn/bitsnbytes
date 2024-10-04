import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

class NewQueryPage extends StatefulWidget {
  @override
  _NewQueryPageState createState() => _NewQueryPageState();
}

class _NewQueryPageState extends State<NewQueryPage> {
  final TextEditingController _queryController = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String? _userId;

  @override
  void initState() {
    super.initState();
    _fetchUserId();
  }

  Future<void> _fetchUserId() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
      });
    } else {
      _showErrorAndRedirect('Please log in to submit a query');
    }
  }

  void _showErrorAndRedirect(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
    Navigator.pop(context);
  }

  Future<void> _pickImage() async {
    try {
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _image = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> _submitQuery() async {
    String queryText = _queryController.text.trim();
    if (queryText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Query cannot be empty')),
      );
      return;
    }

    String? imageUrl;
    if (_image != null) {
      try {
        String fileName = '${DateTime.now().millisecondsSinceEpoch}_${_image!.path.split('/').last}';
        final storageRef = FirebaseStorage.instance.ref().child('comments/$fileName');
        UploadTask uploadTask = storageRef.putFile(_image!);
        TaskSnapshot snapshot = await uploadTask;
        imageUrl = await snapshot.ref.getDownloadURL();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image')),
        );
        return;
      }
    }

    if (_userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not authenticated')),
      );
      return;
    }

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(_userId).get();

      if (!userDoc.exists) {
        _showErrorAndRedirect('User data not found');
        return;
      }

      String username = userDoc['name'] ?? 'Unknown';

      await FirebaseFirestore.instance.collection('comments').add({
        'text': queryText,
        'imageURL': imageUrl,
        'author': username,
        'authorId': _userId,
        'status': 'open',
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Query submitted successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit query: $e')),
      );
    }
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Query'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Create a New Query',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _queryController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Enter your query',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
              ),
            ),
            SizedBox(height: 20),
            _image != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.file(
                _image!,
                height: 200,
                fit: BoxFit.cover,
              ),
            )
                : Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Center(
                child: Text('No image selected', style: TextStyle(color: Colors.grey)),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              ),
              icon: Icon(Icons.image),
              label: Text(
                'Pick Image',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitQuery,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                'Submit Query',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
