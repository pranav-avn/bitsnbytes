import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:smarthome/Authentications/LoginScreen.dart';
import 'Authentications/SignINScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBRiATV2-UM1cimqYjZJZviMkbSZXmgzBo",
          appId: "1:139573230039:android:e52f5e5ebba5df33217392",
          messagingSenderId: "139573230039",
          projectId: "homeiqq",
          storageBucket: "homeiqq.appspot.com"),
    );

    // Initialize Firebase Messaging
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    // Request permissions for notifications
    await _firebaseMessaging.requestPermission();

    // Get the FCM token
    final String? fcmtoken = await _firebaseMessaging.getToken();
    print('FCM Token: $fcmtoken');
  } catch (e) {
    // Handle errors here
    print('Error initializing Firebase or Firebase Messaging: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.instance.subscribeToTopic('fire_alerts');
    return MaterialApp(
      title: 'HackMegdon',
      home: SignInPage(),
    );
  }
}
