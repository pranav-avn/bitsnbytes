// import 'package:flutter/material.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:smarthome/screens/userSide/floor_plan_rooms/room_pages.dart';
//
// class FloorPlanWidget extends StatefulWidget {
//   @override
//   _FloorPlanWidgetState createState() => _FloorPlanWidgetState();
// }
//
// class _FloorPlanWidgetState extends State<FloorPlanWidget> {
//   late Future<String> _imageUrlFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     _imageUrlFuture = _getImageUrl('image/floor_map.jpeg');
//   }
//
//   Future<String> _getImageUrl(String imagePath) async {
//     try {
//       final ref = FirebaseStorage.instance.ref().child(imagePath);
//       final downloadUrl = await ref.getDownloadURL();
//       print('Download URL: $downloadUrl'); // Debug URL
//       return downloadUrl;
//     } catch (e) {
//       print('Error fetching download URL: $e');
//       throw Exception('Error fetching download URL');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Floor Plan',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.blue,
//       ),
//       body: FutureBuilder<String>(
//         future: _imageUrlFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(
//                 child: Text('Error loading image: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No image available'));
//           } else {
//             final imageUrl = snapshot.data!;
//             return GestureDetector(
//               onTapUp: (details) => _handleTap(context, details.localPosition),
//               child: Image.network(
//                 imageUrl,
//                 fit: BoxFit.cover,
//                 loadingBuilder: (context, child, progress) {
//                   if (progress == null) {
//                     return child;
//                   } else {
//                     return Center(
//                       child: CircularProgressIndicator(
//                         value: progress.expectedTotalBytes != null
//                             ? progress.cumulativeBytesLoaded /
//                                 (progress.expectedTotalBytes ?? 1)
//                             : null,
//                       ),
//                     );
//                   }
//                 },
//                 errorBuilder: (context, error, stackTrace) {
//                   print('Image loading error: $error');
//                   print('Stack trace: $stackTrace');
//                   return Center(child: Text('Failed to load image: $error'));
//                 },
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
//
//   void _handleTap(BuildContext context, Offset position) {
//     // Handle navigation based on the position of the tap
//     if (_isInBounds(position, 96, 107, 73, 107)) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => RoomPage(roomName: 'room 106', people: 10),
//         ),
//       );
//     } else if (_isInBounds(position, 344, 486, 212, 281)) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => RoomPage(roomName: 'dining', people: 20),
//         ),
//       );
//     } else if (_isInBounds(position, 356, 490, 174, 205)) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => RoomPage(roomName: 'kitchen', people: 40),
//         ),
//       );
//     } else if (_isInBounds(position, 284, 408, 15, 127)) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => RoomPage(roomName: 'auditorium', people: 0),
//         ),
//       );
//     } else if (_isInBounds(position, 7, 88, 38, 70)) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => RoomPage(roomName: 'room 106', people: 30),
//         ),
//       );
//     } else if (_isInBounds(position, 120, 165, 38, 71)) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => RoomPage(roomName: 'room 105', people: 40),
//         ),
//       );
//     } else if (_isInBounds(position, 179, 224, 36, 69)) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => RoomPage(roomName: 'MBA office', people: 40),
//         ),
//       );
//     } else if (_isInBounds(position, 10, 33, 100, 132)) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => RoomPage(roomName: 'room 107', people: 7),
//         ),
//       );
//     } else if (_isInBounds(position, 39, 95, 100, 132)) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => RoomPage(roomName: 'room 104', people: 8),
//         ),
//       );
//     } else if (_isInBounds(position, 125, 181, 101, 133)) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => RoomPage(roomName: 'room 103', people: 10),
//         ),
//       );
//     } else if (_isInBounds(position, 92, 148, 185, 246)) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => RoomPage(roomName: 'room 102', people: 40),
//         ),
//       );
//     } else if (_isInBounds(position, 149, 205, 245, 306)) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => RoomPage(roomName: 'room 101', people: 7),
//         ),
//       );
//     } else if (_isInBounds(position, 254, 304, 122, 183)) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => RoomPage(roomName: 'main lobby', people: 30),
//         ),
//       );
//     }
//   }
//
//   bool _isInBounds(
//       Offset position, double left, double right, double top, double bottom) {
//     return position.dx >= left &&
//         position.dx <= right &&
//         position.dy >= top &&
//         position.dy <= bottom;
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:smarthome/screens/userSide/floor_plan_rooms/room_pages.dart';

class FloorPlanWidget extends StatefulWidget {
  @override
  _FloorPlanWidgetState createState() => _FloorPlanWidgetState();
}

class _FloorPlanWidgetState extends State<FloorPlanWidget> {
  late Future<String> firstFloorImageUrlFuture;
  late Future<String> _secondFloorImageUrlFuture;
  List<String> options = ["Block A", "Block B"];

  int _selectedBlockIndex = 0;

  @override
  void initState() {
    super.initState();
    firstFloorImageUrlFuture = _fetchImageUrl('image/floor_map.jpeg');
    _secondFloorImageUrlFuture = _fetchImageUrl('image/FLOOR2.jpg');
  }

  Future<String> _fetchImageUrl(String path) async {
    final storageRef = FirebaseStorage.instance.ref().child(path);
    final url = await storageRef.getDownloadURL();
    return url;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> floors = [
      buildFloorPlan(context, firstFloorImageUrlFuture, handleFirstFloorTap),
      buildFloorPlan(context, _secondFloorImageUrlFuture, handleSecondFloorTap),
    ];
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Floor Plan',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.teal,
          ),
          body: Center(
            child: Column(
              children: [
                Text("Select Block : "),
                SizedBox(height: 10),
                DropdownButton<String>(
                  value: options[_selectedBlockIndex],
                  items: options.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedBlockIndex = options.indexOf(newValue!);
                      print('Index: $_selectedBlockIndex');
                    });
                  },
                ),
                floors[_selectedBlockIndex],
              ],
            ),
          )),
    );
  }
}

void handleFirstFloorTap(BuildContext context, Offset position) {
  if (position.dx >= 96 &&
      position.dx <= 107 &&
      position.dy >= 73 &&
      position.dy <= 107) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RoomPage(
                roomName: 'room 106',
                people: 10,
              )),
    );
  } else if (position.dx >= 344 &&
      position.dx <= 486 &&
      position.dy >= 212 &&
      position.dy <= 281) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RoomPage(
                roomName: 'dining',
                people: 20,
              )),
    );
  } else if (position.dx >= 356 &&
      position.dx <= 490 &&
      position.dy >= 174 &&
      position.dy <= 205) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RoomPage(
                roomName: 'kitchen',
                people: 40,
              )),
    );
  } else if (position.dx >= 284 &&
      position.dx <= 408 &&
      position.dy >= 15 &&
      position.dy <= 127) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RoomPage(roomName: 'auditorium', people: 0)),
    );
  } else if (position.dx >= 7 &&
      position.dx <= 88 &&
      position.dy >= 38 &&
      position.dy <= 70) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RoomPage(
                roomName: 'room 106',
                people: 30,
              )),
    );
  } else if (position.dx >= 120 &&
      position.dx <= 165 &&
      position.dy >= 38 &&
      position.dy <= 71) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RoomPage(
                roomName: 'room 105',
                people: 40,
              )),
    );
  } else if (position.dx >= 179 &&
      position.dx <= 224 &&
      position.dy >= 36 &&
      position.dy <= 69) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RoomPage(
                roomName: 'MBA office',
                people: 40,
              )),
    );
  } else if (position.dx >= 10 &&
      position.dx <= 33 &&
      position.dy >= 100 &&
      position.dy <= 132) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RoomPage(
                roomName: 'room 107',
                people: 7,
              )),
    );
  } else if (position.dx >= 39 &&
      position.dx <= 95 &&
      position.dy >= 100 &&
      position.dy <= 132) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RoomPage(
                roomName: 'room 104',
                people: 8,
              )),
    );
  } else if (position.dx >= 125 &&
      position.dx <= 181 &&
      position.dy >= 101 &&
      position.dy <= 133) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RoomPage(
                roomName: 'room 103',
                people: 10,
              )),
    );
  } else if (position.dx >= 92 &&
      position.dx <= 148 &&
      position.dy >= 185 &&
      position.dy <= 246) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RoomPage(roomName: 'room 102', people: 40)),
    );
  } else if (position.dx >= 149 &&
      position.dx <= 205 &&
      position.dy >= 245 &&
      position.dy <= 306) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RoomPage(
                roomName: 'room 101',
                people: 7,
              )),
    );
  } else if (position.dx >= 254 &&
      position.dx <= 304 &&
      position.dy >= 122 &&
      position.dy <= 183) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RoomPage(
                roomName: 'main lobby',
                people: 30,
              )),
    );
  }
}

void handleSecondFloorTap(BuildContext context, Offset position) {
  if (position.dx >= 92 &&
      position.dx <= 281 &&
      position.dy >= 104 &&
      position.dy <= 373) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RoomPage(
                roomName: 'lydia mendalssonhn theatre',
                people: 50,
              )),
    );
  } else if (position.dx >= 160 &&
      position.dx <= 216 &&
      position.dy >= 406 &&
      position.dy <= 453) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RoomPage(
                roomName: 'blagdon',
                people: 25,
              )),
    );
  } else if (position.dx >= 226 &&
      position.dx <= 318 &&
      position.dy >= 406 &&
      position.dy <= 448) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RoomPage(
                roomName: 'administration',
                people: 15,
              )),
    );
  } else if (position.dx >= 439 &&
      position.dx <= 564 &&
      position.dy >= 411 &&
      position.dy <= 537) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RoomPage(
                roomName: 'main lobby',
                people: 40,
              )),
    );
  } else if (position.dx >= 570 &&
      position.dx <= 594 &&
      position.dy >= 423 &&
      position.dy <= 490) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RoomPage(
                roomName: 'room 6',
                people: 35,
              )),
    );
  } else if (position.dx >= 636 &&
      position.dx <= 708 &&
      position.dy >= 422 &&
      position.dy <= 490) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RoomPage(
                roomName: 'room 4',
                people: 15,
              )),
    );
  } else if (position.dx >= 777 &&
      position.dx <= 824 &&
      position.dy >= 405 &&
      position.dy <= 449) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RoomPage(
                roomName: 'room 2',
                people: 10,
              )),
    );
  } else if (position.dx >= 296 &&
      position.dx <= 561 &&
      position.dy >= 88 &&
      position.dy <= 290) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RoomPage(
                roomName: 'eula d marks garden',
                people: 12,
              )),
    );
  } else if (position.dx >= 447 &&
      position.dx <= 484 &&
      position.dy >= 326 &&
      position.dy <= 369) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RoomPage(
                roomName: 'lounge',
                people: 20,
              )),
    );
  } else if (position.dx >= 572 &&
      position.dx <= 778 &&
      position.dy >= 134 &&
      position.dy <= 373) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RoomPage(
                roomName: 'summa space',
                people: 5,
              )),
    );
  } else if (position.dx >= 780 &&
      position.dx <= 835 &&
      position.dy >= 126 &&
      position.dy <= 347) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RoomPage(
                roomName: 'kitchen',
                people: 30,
              )),
    );
  } else if (position.dx >= 824 &&
      position.dx <= 887 &&
      position.dy >= 84 &&
      position.dy <= 148) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RoomPage(
                roomName: 'terrace',
                people: 8,
              )),
    );
  }
}

Widget buildFloorPlan(BuildContext context, Future<String> imageUrlFuture,
    void Function(BuildContext, Offset) onTap) {
  return FutureBuilder<String>(
    future: imageUrlFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (!snapshot.hasData) {
        return Center(child: Text('No image data available'));
      } else {
        final imageUrl = snapshot.data!;
        return GestureDetector(
          onTapUp: (details) {
            onTap(context, details.localPosition);
          },
          child: Image.network(
            imageUrl,
          ),
        );
      }
    },
  );
}
