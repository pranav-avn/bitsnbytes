import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//
// void initFCMToken() async {
//   String? token = await FirebaseMessaging.instance.getToken();
//   if (token != null) {
//     print(token);
//     saveTokenToDatabase(token);
//   } else {
//     print("Token not created");
//   }
// }
//
// Future<void> saveTokenToDatabase(String token) async {
//   // // Assume the current user is logged in
//   User? user = FirebaseAuth.instance.currentUser;
//   //
//   // // Save the token in Firestore
//   // await FirebaseFirestore.instance.collection('users').doc(userId).update({
//   //   'fcmToken': token,
//   // });
//   try {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       String userId = user.uid;
//
//       // Save the token in Firestore
//       await FirebaseFirestore.instance.collection('users').doc(userId).update({
//         'fcmToken': token,
//       });
//     } else {
//       print('User is not logged in');
//     }
//   } catch (e, stackTrace) {
//     print('Error saving token: $e');
//     print('Stack trace: $stackTrace');
//   }
// }
//
import 'package:firebase_admin/firebase_admin.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> sendFCMMessage() async {
  const String serverKey = 'AIzaSyBRiATV2-UM1cimqYjZJZviMkbSZXmgzBo';
  // const String fcmUrl = 'https://fcm.googleapis.com/fcm/send';
  const String fcmUrl = 'https://fcm.googleapis.com/v1/homeiqq/messages:send';
  try {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };

    final body = jsonEncode({
      'notification': {
        'title': '!!! Fire Alert !!',
        'body': 'Evacuate the building IMMEDIATELY!!!',
      },
      'priority': 'high',
      'to':
          '/topics/fire_alerts', // Send to all devices subscribed to 'fire_alerts' topic
    });

    final response = await http.post(
      Uri.parse(fcmUrl),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      print('FCM message sent successfully');
    } else {
      print('Failed to send FCM message');
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print('Error in Send Fire Alert Method :$e');
  }
}

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    try {
      NotificationSettings settings =
          await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      // Print permission status
      print(
          'User granted Notification permission: ${settings.authorizationStatus}');
      final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      if (apnsToken != null) {
        print('apns Notification: $apnsToken');
      }
      // Get the token and print it
      String? token = await _firebaseMessaging.getToken();
      print('FCM Token: $token');

      // Listen for foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Received a message while in the foreground!');
        if (message.notification != null) {
          print(
              'Message also contained a notification: ${message.notification}');
        }
      });

      // Listen for messages when the app is in the background but not terminated
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('Message clicked: ${message.notification?.title}');
        // Navigate to a specific screen if needed
      });

      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
    } catch (e) {
      print(e);
    }
    // Request permissions for iOS
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Print and handle background message
  print('Handling a background message: ${message.notification?.title}');
}

Future<void> initFCMToken() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  try {
    String? token = await messaging.getToken();
    if (token != null) {
      print('FCM Token: $token');
      // Save the token to your database
      saveTokenToDatabase(token);
    }
  } catch (e) {
    print("Error while initializing fcmtoken : $e");
  }
}

Future<void> saveTokenToDatabase(String token) async {
  User? user = FirebaseAuth.instance.currentUser;
  try {
    if (user != null) {
      String userId = user.uid;

      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'fcmtoken': token,
      }, SetOptions(merge: true));
      print("Saved fcmtoken in firestore: $token");
    }
  } catch (e) {
    print("Error while updating fcmtoken in firebase : $e");
  }
}

// void configureFirebaseMessaging() {
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     print(
//         'Received a message in the foreground: ${message.notification?.title}');
//     // Handle foreground notifications
//   });
//
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
// }
