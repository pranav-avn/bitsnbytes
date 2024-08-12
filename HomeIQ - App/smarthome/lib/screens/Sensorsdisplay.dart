// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// //
// // class sensorsDisplayScreen extends StatefulWidget {
// //   sensorsDisplayScreen({super.key, required this.category});
// //   String category;
// //
// //   @override
// //   State<sensorsDisplayScreen> createState() => _sensorsDisplayScreenState();
// // }
// //
// // class _sensorsDisplayScreenState extends State<sensorsDisplayScreen> {
// //   List<String> allDevices = [
// //     "Temperature",
// //     "Humidity",
// //     "Pressure",
// //     "Gas Level",
// //     "Smoke"
// //   ];
// //   List<String> selectedDevices = [];
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadSelectedDevices();
// //   }
// //
// //   Future<void> _loadSelectedDevices() async {
// //     User? user = FirebaseAuth.instance.currentUser;
// //     if (user != null) {
// //       DocumentSnapshot userDoc = await FirebaseFirestore.instance
// //           .collection('user_devices')
// //           .doc(user.uid)
// //           .get();
// //       Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
// //       if (data != null && data.containsKey(widget.category)) {
// //         setState(() {
// //           selectedDevices = List<String>.from(data[widget.category]);
// //         });
// //       }
// //     }
// //   }
// //
// //   Future<void> _saveSelectedDevices() async {
// //     User? user = FirebaseAuth.instance.currentUser;
// //     if (user != null) {
// //       await FirebaseFirestore.instance
// //           .collection('user_devices')
// //           .doc(user.uid)
// //           .set({
// //         widget.category: selectedDevices,
// //       }, SetOptions(merge: true));
// //     }
// //   }
// //
// //   void _showDeviceSelectionDialog() {
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         List<String> tempSelectedDevices = List.from(selectedDevices);
// //         return AlertDialog(
// //           title: Text('Select Devices'),
// //           content: StatefulBuilder(
// //             builder: (BuildContext context, StateSetter setState) {
// //               return SingleChildScrollView(
// //                 child: Column(
// //                   mainAxisSize: MainAxisSize.min,
// //                   children: allDevices.map((device) {
// //                     return CheckboxListTile(
// //                       title: Text(device),
// //                       value: tempSelectedDevices.contains(device),
// //                       onChanged: (bool? value) {
// //                         setState(() {
// //                           if (value == true) {
// //                             tempSelectedDevices.add(device);
// //                           } else {
// //                             tempSelectedDevices.remove(device);
// //                           }
// //                         });
// //                       },
// //                     );
// //                   }).toList(),
// //                 ),
// //               );
// //             },
// //           ),
// //           actions: [
// //             TextButton(
// //               child: Text('Cancel'),
// //               onPressed: () {
// //                 Navigator.of(context).pop();
// //               },
// //             ),
// //             TextButton(
// //               child: Text('Add'),
// //               onPressed: () {
// //                 setState(() {
// //                   selectedDevices = tempSelectedDevices;
// //                 });
// //                 _saveSelectedDevices();
// //                 Navigator.of(context).pop();
// //               },
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(
// //             '${widget.category[0].toUpperCase()}${widget.category.substring(1)} Devices'),
// //       ),
// //       body: ListView.builder(
// //         itemCount: selectedDevices.length,
// //         itemBuilder: (context, index) {
// //           return ListTile(
// //             title: Text(selectedDevices[index]),
// //           );
// //         },
// //       ),
// //       // body: Column(),
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: _showDeviceSelectionDialog,
// //         child: Icon(Icons.add),
// //       ),
// //     );
// //   }
// // }
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class sensorsDisplayScreen extends StatefulWidget {
//   final String category;
//   sensorsDisplayScreen({super.key, required this.category});
//
//   @override
//   State<sensorsDisplayScreen> createState() => _sensorsDisplayScreenState();
// }
//
// class _sensorsDisplayScreenState extends State<sensorsDisplayScreen> {
//   List<String> allDevices = [
//     "Temperature",
//     "Humidity",
//     "Pressure",
//     "Gas Level",
//     "Smoke"
//   ];
//   List<String> selectedDevices = [];
//   List<String> rooms = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _loadSelectedDevices();
//   }
//
//   Future<void> _loadSelectedDevices() async {
//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         DocumentSnapshot userDoc = await FirebaseFirestore.instance
//             .collection('user_devices')
//             .doc(user.uid)
//             .get();
//         Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
//         if (data != null && data.containsKey(widget.category)) {
//           setState(() {
//             selectedDevices = List<String>.from(data[widget.category]);
//           });
//         }
//       }
//     } catch (e) {
//       print('Error loading selected devices: $e');
//     }
//     // User? user = FirebaseAuth.instance.currentUser;
//     // if (user != null) {
//     //   DocumentSnapshot userDoc = await FirebaseFirestore.instance
//     //       .collection('user_devices')
//     //       .doc(user.uid)
//     //       .get();
//     //   Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
//     //   if (data != null && data.containsKey(widget.category)) {
//     //     setState(() {
//     //       selectedDevices = List<String>.from(data[widget.category]);
//     //     });
//     //   }
//     // }
//   }
//
//   Future<void> _saveSelectedDevices() async {
//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         await FirebaseFirestore.instance
//             .collection('user_devices')
//             .doc(user.uid)
//             .update(
//           {
//             widget.category: selectedDevices,
//           },
//         );
//       }
//     } catch (e) {
//       print('Error saving selected devices: $e');
//     }
//   }
//
//   void _showDeviceSelectionDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         List<String> tempSelectedDevices = List.from(selectedDevices);
//         return AlertDialog(
//           title: Text('Select Devices'),
//           content: StatefulBuilder(
//             builder: (BuildContext context, StateSetter setState) {
//               return SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: allDevices.map((device) {
//                     return CheckboxListTile(
//                       title: Text(device),
//                       value: tempSelectedDevices.contains(device),
//                       onChanged: (bool? value) {
//                         setState(() {
//                           if (value == true) {
//                             tempSelectedDevices.add(device);
//                           } else {
//                             tempSelectedDevices.remove(device);
//                           }
//                         });
//                       },
//                     );
//                   }).toList(),
//                 ),
//               );
//             },
//           ),
//           actions: [
//             TextButton(
//               child: Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('Add'),
//               onPressed: () {
//                 setState(() {
//                   selectedDevices = tempSelectedDevices;
//                 });
//                 _saveSelectedDevices();
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//             '${widget.category[0].toUpperCase()}${widget.category.substring(1)} Devices'),
//       ),
//       body: ListView.builder(
//         itemCount: selectedDevices.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(selectedDevices[index]),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _showDeviceSelectionDialog,
//         child: Icon(Icons.meeting_room_rounded),
//       ),
//     );
//   }
// }
