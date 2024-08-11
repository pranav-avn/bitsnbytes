// import 'package:flutter/material.dart';
// import 'package:smarthome/screens/adminSide/adminAnnouncementsPage.dart';
// import 'package:smarthome/screens/adminSide/adminFeedbackScreen.dart';
// import 'package:smarthome/services/FCMservice.dart';
// import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
//
// class adminHomePage extends StatefulWidget {
//   const adminHomePage({super.key});
//
//   @override
//   State<adminHomePage> createState() => _adminHomePageState();
// }
//
// class _adminHomePageState extends State<adminHomePage> {
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Admin\'s Home Page'),
//       ),
//       body: adminAnnouncementScreen(),
//       floatingActionButton: ExpandableFab(
//         children: [
//           FloatingActionButton.small(
//             onPressed: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => adminFeedbackScreen()));
//             },
//             child: Icon(Icons.feedback),
//           ),
//           FloatingActionButton.small(
//             heroTag: null,
//             child: const Icon(Icons.search),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       // floatingActionButton: FloatingActionButton(
//       //   onPressed: () {
//       //     Navigator.push(context,
//       //         MaterialPageRoute(builder: (context) => adminFeedbackScreen()));
//       //   },
//       //   child: Icon(Icons.feedback),
//       // ),
//       // body: SingleChildScrollView(
//       //   child: Column(
//       //     crossAxisAlignment: CrossAxisAlignment.center,
//       //     mainAxisAlignment: MainAxisAlignment.center,
//       //     children: [
//       //       ElevatedButton(
//       //           onPressed: () {
//       //             Navigator.push(
//       //                 context,
//       //                 MaterialPageRoute(
//       //                     builder: (context) => adminAnnouncementScreen()));
//       //           },
//       //           child: Text('Announcements'))
//       //     ],
//       //   ),
//       // ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:smarthome/screens/adminSide/AdminFloorPlan.dart';
import 'package:smarthome/screens/adminSide/adminAnnouncementsPage.dart';
import 'package:smarthome/screens/adminSide/adminFeedbackScreen.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:smarthome/screens/userSide/floor_plan_rooms/floor_plan.dart';

class adminHomePage extends StatefulWidget {
  const adminHomePage({super.key});

  @override
  State<adminHomePage> createState() => _adminHomePageState();
}

class _adminHomePageState extends State<adminHomePage> {
  final ImagePicker _picker = ImagePicker(); // Initialize ImagePicker

  @override
  void initState() {
    super.initState();
  }

  Future<void> _uploadFloorPlan() async {
    try {
      // Pick an image
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;

      // Upload image to Firebase Storage
      final file = File(pickedFile.path);
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('floor_plans/${pickedFile.name}');
      final uploadTask = storageRef.putFile(file);

      // Monitor upload progress
      uploadTask.snapshotEvents.listen((taskSnapshot) {
        final progress =
            (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes) * 100;
        print('Upload progress: $progress%');
      });

      await uploadTask.whenComplete(() {
        print('Upload complete');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload successful!')),
        );
      });
    } catch (e) {
      print('Error uploading file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin\'s Home Page'),
        actions: [],
      ),
      body: adminFloorPlanWidget(),
      // floatingActionButton: ExpandableFab(
      //   openButtonBuilder: RotateFloatingActionButtonBuilder(
      //     child: const Icon(Icons.account_box),
      //     fabSize: ExpandableFabSize.regular,
      //     foregroundColor: Colors.amber,
      //     backgroundColor: Colors.green,
      //     shape: const CircleBorder(),
      //   ),
      //   closeButtonBuilder: FloatingActionButtonBuilder(
      //     size: 56,
      //     builder: (BuildContext context, void Function()? onPressed,
      //         Animation<double> progress) {
      //       return IconButton(
      //         onPressed: onPressed,
      //         icon: const Icon(
      //           Icons.check_circle_outline,
      //           size: 40,
      //         ),
      //       );
      //     },
      //   ),
      //   children: [
      //     FloatingActionButton.small(
      //       onPressed: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => adminFeedbackScreen(),
      //           ),
      //         );
      //       },
      //       child: Icon(Icons.feedback),
      //     ),
      //
      //   ],
      // ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 35.0),
            child: FloatingActionButton.small(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => adminAnnouncementScreen()));
              },
              child: Icon(Icons.newspaper_sharp),
            ),
          ),
          FloatingActionButton.small(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => adminFeedbackScreen(),
                ),
              );
            },
            child: Icon(Icons.feedback),
          ),
        ],
      ),
    );
  }
}
