import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smarthome/screens/adminSide/adminHome.dart';
import 'package:smarthome/screens/homepage.dart';
import 'package:smarthome/screens/userSide/floor_plan_rooms/floor_plan.dart';
import 'package:smarthome/services/BlynkService.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = "", regEmail = "";
  String password = "", regPassword = "";
  String deptID = "";
  String name = "";

  @override
  void initState() {
    super.initState();
    BlynkService("eGTiuLVeg2GRGqbN1YdVib6ByTvjBA_V").writePin("v4", "1");
  }

  final TextEditingController adminEmailController =
      TextEditingController(text: "dxpka@gmail.com");
  final TextEditingController adminPasswordController =
      TextEditingController(text: "123456");

  final TextEditingController emailController =
      TextEditingController(text: "deepika@gmail.com");
  final TextEditingController passwordController =
      TextEditingController(text: "123456");

  final TextEditingController registerEmailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController registerPasswordController =
      TextEditingController();
  final TextEditingController deptIDController = TextEditingController();

  // void _loginUser(String email, String password) async {
  //   try {
  //     UserCredential userCredential =
  //         await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     String userID = userCredential.user!.uid;
  //     Service_Imp().storeid(userID);
  //     if (user != null) {
  //       // Get the device token
  //       String? token = await getDeviceToken();
  //       if (token != null) {
  //         await FirebaseFirestore.instance
  //             .collection('users')
  //             .doc(userID)
  //             .update({
  //           'deviceToken': token,
  //         });
  //       }
  //     }
  //     print(user);
  //
  //     Navigator.pop(context);
  //
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => WelcomePage()),
  //     );
  //   } catch (e) {
  //     print("Error logging in: $e");
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text('Invalid Login')));
  //   }
  // }

  Future<void> _signIn() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // Navigate to the category screen after successful login
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    } on FirebaseAuthException catch (e) {
      print('Failed to sign in: $e');
    }
  }

  Future<void> _adminsignIn() async {
    try {
      if (adminEmailController.text == "dxpka@gmail.com" &&
          adminPasswordController.text == "123456") {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: adminEmailController.text,
          password: adminPasswordController.text,
        );

        // Navigate to the category screen after successful login
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => adminHomePage()));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Invalid Login')));
      }
    } on FirebaseAuthException catch (e) {
      print('Failed to sign in: $e');
    }
  }

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

      // Navigate to home screen after successful registration
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
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
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              controller: emailController,
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: passwordController,
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
            ),
            ElevatedButton(onPressed: _signIn, child: Text('Login')),
            SizedBox(height: 10),
            TextFormField(
              controller: adminEmailController,
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: adminPasswordController,
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
            ),
            ElevatedButton(onPressed: _adminsignIn, child: Text('Admin Login')),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(labelText: "Enter name"),
              controller: nameController,
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Enter email"),
              controller: registerEmailController,
              onChanged: (value) {
                setState(() {
                  regEmail = value;
                });
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(labelText: "Enter password"),
              controller: registerPasswordController,
              onChanged: (value) {
                setState(() {
                  regPassword = value;
                });
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(labelText: "Enter deptId"),
              controller: deptIDController,
              onChanged: (value) {
                setState(() {
                  deptID = value;
                });
              },
            ),
            ElevatedButton(onPressed: _registerUser, child: Text('Register')),
          ],
        ),
      ),
    );
  }
}
