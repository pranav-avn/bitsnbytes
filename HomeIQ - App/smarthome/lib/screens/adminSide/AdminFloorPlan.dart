import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:smarthome/screens/userSide/floor_plan_rooms/room_pages.dart';

class adminFloorPlanWidget extends StatefulWidget {
  @override
  _adminFloorPlanWidgetState createState() => _adminFloorPlanWidgetState();
}

class _adminFloorPlanWidgetState extends State<adminFloorPlanWidget> {
  late Future<String> _imageUrlFuture;

  @override
  void initState() {
    super.initState();
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

  String _selectedBlock = 'Block A';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                Text("Select Block : "),
                DropdownButton<String>(
                  value: _selectedBlock,
                  items: <String>['Block A', 'Block B', 'Block C']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedBlock = newValue!;
                    });
                  },
                ),
              ],
            ),
            floorplan1(),
          ],
        ),
      ),
    );
  }

  FutureBuilder<String> floorplan1() {
    return FutureBuilder<String>(
      future: _imageUrlFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading image: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No image available'));
        } else {
          final imageUrl = snapshot.data!;
          return GestureDetector(
            onTapUp: (details) => _handleTap(context, details.localPosition),
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
