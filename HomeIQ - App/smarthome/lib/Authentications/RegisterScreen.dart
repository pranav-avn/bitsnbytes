import 'package:flutter/material.dart';
import 'package:smarthome/tools/UiComponents.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class registerScreen extends StatefulWidget {
  const registerScreen({super.key});

  @override
  State<registerScreen> createState() => _registerScreenState();
}

class _registerScreenState extends State<registerScreen> {
  final TextEditingController registerEmailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController registerPasswordController =
      TextEditingController();
  final TextEditingController deptIDController = TextEditingController();

  Future<void> _registerUser() async {
    try {
      // Register the user with Firebase Authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: registerEmailController.text,
        password: registerPasswordController.text,
      );

      // Save user details to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': registerEmailController.text,
        'name': nameController.text,
        'deptid': deptIDController.text,
        'uid': userCredential.user!.uid,
        'fcmtoken': ''
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registered successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      // Handle registration errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Card(
            margin: EdgeInsets.all(10),
            color: Colors.purple.shade100,
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: registerEmailController,
                    decoration: tbdecor(labelT: "Enter your Email: "),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: registerPasswordController,
                    obscureText: true,
                    decoration: tbdecor(labelT: "Enter your password : "),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: nameController,
                    decoration: tbdecor(labelT: "Enter your Name : "),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: deptIDController,
                    obscureText: true,
                    decoration: tbdecor(labelT: "Enter your Department Id : "),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: _registerUser, child: Text('Register'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
