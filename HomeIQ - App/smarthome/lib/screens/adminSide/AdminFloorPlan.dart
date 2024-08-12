import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:smarthome/screens/userSide/floor_plan_rooms/floor_plan.dart';
import 'package:smarthome/screens/userSide/floor_plan_rooms/room_pages.dart';

class adminFloorPlanWidget extends StatefulWidget {
  @override
  _adminFloorPlanWidgetState createState() => _adminFloorPlanWidgetState();
}

class _adminFloorPlanWidgetState extends State<adminFloorPlanWidget> {
  late Future<String> _imageUrlFuture;
  late Future<String> firstFloorImageUrlFuture;
  late Future<String> _secondFloorImageUrlFuture;
  List<String> options = ["Block A", "Block B"];
  int _selectedBlockIndex = 0;

  @override
  void initState() {
    super.initState();
    firstFloorImageUrlFuture = _getImageUrl('image/floor_map.jpeg');
    _secondFloorImageUrlFuture = _getImageUrl('image/FLOOR2.jpg');
    _imageUrlFuture = _getImageUrl('image/floor_map.jpeg');
  }

  Future<String> _getImageUrl(String imagePath) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(imagePath);
      final downloadUrl = await ref.getDownloadURL();
      print('Download URL: $downloadUrl'); // Debug URL
      return downloadUrl;
    } catch (e) {
      print('Error fetching download URL: $e');
      throw Exception('Error fetching download URL');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> floors = [
      buildFloorPlan(context, firstFloorImageUrlFuture, handleFirstFloorTap),
      buildFloorPlan(context, _secondFloorImageUrlFuture, handleSecondFloorTap),
    ];
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
              ],
            ),
            floors[_selectedBlockIndex],
          ],
        ),
      ),
    );
  }

  Widget floorplan1() {
    return Column(
      children: [
        FutureBuilder<String>(
          future: _imageUrlFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Error loading image: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No image available'));
            } else {
              final imageUrl = snapshot.data!;
              return GestureDetector(
                onTapUp: (details) =>
                    _handleTap(context, details.localPosition),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) {
                      return child;
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          value: progress.expectedTotalBytes != null
                              ? progress.cumulativeBytesLoaded /
                                  (progress.expectedTotalBytes ?? 1)
                              : null,
                        ),
                      );
                    }
                  },
                  errorBuilder: (context, error, stackTrace) {
                    print('Image loading error: $error');
                    print('Stack trace: $stackTrace');
                    return Center(child: Text('Failed to load image: $error'));
                  },
                ),
              );
            }
          },
        ),
        SizedBox(height: 30),
        Container(
          child: Column(
            children: [
              Text("OCCUPANCY COUNT",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text('Auditorium :100/180'),
              SizedBox(height: 5),
              Text('Dining Room :50/100'),
              SizedBox(height: 5),
              Text('MBA Office :2/4'),
              SizedBox(height: 5),
              Text('Room 103 :50/60'),
              SizedBox(height: 5),
              Text('Room 104 :55/60'),
              SizedBox(height: 5),
              Text(
                'Room 105 :60/60',
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(height: 5),
              Text('Room 106 :52/60'),
            ],
          ),
        )
      ],
    );
  }

  void _handleTap(BuildContext context, Offset position) {
    // Handle navigation based on the position of the tap
    if (_isInBounds(position, 96, 107, 73, 107)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RoomPage(roomName: 'room 106', people: 10),
        ),
      );
    } else if (_isInBounds(position, 344, 486, 212, 281)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RoomPage(roomName: 'dining', people: 20),
        ),
      );
    } else if (_isInBounds(position, 356, 490, 174, 205)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RoomPage(roomName: 'kitchen', people: 40),
        ),
      );
    } else if (_isInBounds(position, 284, 408, 15, 127)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RoomPage(roomName: 'auditorium', people: 0),
        ),
      );
    } else if (_isInBounds(position, 7, 88, 38, 70)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RoomPage(roomName: 'room 106', people: 30),
        ),
      );
    } else if (_isInBounds(position, 120, 165, 38, 71)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RoomPage(roomName: 'room 105', people: 40),
        ),
      );
    } else if (_isInBounds(position, 179, 224, 36, 69)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RoomPage(roomName: 'MBA office', people: 40),
        ),
      );
    } else if (_isInBounds(position, 10, 33, 100, 132)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RoomPage(roomName: 'room 107', people: 7),
        ),
      );
    } else if (_isInBounds(position, 39, 95, 100, 132)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RoomPage(roomName: 'room 104', people: 8),
        ),
      );
    } else if (_isInBounds(position, 125, 181, 101, 133)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RoomPage(roomName: 'room 103', people: 10),
        ),
      );
    } else if (_isInBounds(position, 92, 148, 185, 246)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RoomPage(roomName: 'room 102', people: 40),
        ),
      );
    } else if (_isInBounds(position, 149, 205, 245, 306)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RoomPage(roomName: 'room 101', people: 7),
        ),
      );
    } else if (_isInBounds(position, 254, 304, 122, 183)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RoomPage(roomName: 'main lobby', people: 30),
        ),
      );
    }
  }

  bool _isInBounds(
      Offset position, double left, double right, double top, double bottom) {
    return position.dx >= left &&
        position.dx <= right &&
        position.dy >= top &&
        position.dy <= bottom;
  }
}
