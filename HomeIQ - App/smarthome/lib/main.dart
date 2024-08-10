import 'package:flutter/material.dart';
import 'package:smarthome/Authentications/LoginScreen.dart';
import 'package:smarthome/services/FCMservice.dart';
import 'screens/homepage.dart';
import 'package:smarthome/Authentications/SignINScreen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBRiATV2-UM1cimqYjZJZviMkbSZXmgzBo",
      appId: "1:139573230039:android:e52f5e5ebba5df33217392",
      messagingSenderId: "139573230039",
      projectId: "homeiqq",
    ),
  );
  NotificationService().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HackMegdon',
      home: SignInPage(),
    );
  }
}
