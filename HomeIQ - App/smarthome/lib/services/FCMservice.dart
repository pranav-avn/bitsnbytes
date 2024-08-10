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

      // Get the token and print it
      String? token = await _firebaseMessaging.getToken();
      print('FCM Token: $token');

      // Listen for foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print(
            'Message received in the foreground: ${message.notification?.title}');
        // Handle the message here and show an alert/dialog if needed
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

      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'fcmToken': token,
      });
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
