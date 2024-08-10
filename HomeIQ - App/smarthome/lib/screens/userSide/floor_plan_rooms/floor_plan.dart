import 'package:flutter/material.dart';
import 'package:smarthome/screens/userSide/floor_plan_rooms/room_pages.dart';

// Floor Plan Widget
class FloorPlanWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Floor Plan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: GestureDetector(
          onTapUp: (details) {
            _handleTap(context, details.localPosition);
          },
          child: Image.asset(
            'images/map.jpg', // Ensure this is the correct path to your image asset
          ),
        ),
      ),
    );
  }

  void _handleTap(BuildContext context, Offset position) {
    // Directly check coordinates and navigate to RoomPage with roomName
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
}
