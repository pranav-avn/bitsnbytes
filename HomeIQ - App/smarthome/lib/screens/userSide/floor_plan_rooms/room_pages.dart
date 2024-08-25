// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:smarthome/screens/userSide/floor_plan_rooms/sensor_pages/gas_sensor.dart';
// import 'package:smarthome/screens/userSide/floor_plan_rooms/sensor_pages/humidity_sensor.dart';
// import 'package:smarthome/screens/userSide/floor_plan_rooms/sensor_pages/ligth_sensor_page.dart';
// import 'package:smarthome/screens/userSide/floor_plan_rooms/sensor_pages/rfid_sensor.dart';
// import 'package:smarthome/screens/userSide/floor_plan_rooms/sensor_pages/soil_moisture.dart';
// import 'package:smarthome/screens/userSide/floor_plan_rooms/sensor_pages/temperatue_sensor.dart';
// import 'package:smarthome/services/BlynkService.dart';
// import 'package:smarthome/screens/userSide/floor_plan_rooms/sensor_pages/dust_sensor.dart';
//
// class RoomPage extends StatelessWidget {
//   final String roomName;
//   final int people;
//   RoomPage({required this.roomName, required this.people});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(roomName),
//         actions: [
//           Text(
//             'People: $people   ',
//             style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: FutureBuilder<DocumentSnapshot>(
//           future:
//               FirebaseFirestore.instance.collection('room').doc(roomName).get(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             }
//             if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             }
//             if (!snapshot.hasData || !snapshot.data!.exists) {
//               return Center(child: Text('Room not found'));
//             }
//
//             List<String> sensors =
//                 List<String>.from(snapshot.data!['sensors'] ?? []);
//
//             if (sensors.isEmpty) {
//               return Center(child: Text('No sensors available'));
//             }
//
//             return ListView.builder(
//               itemCount: sensors.length,
//               itemBuilder: (context, index) {
//                 IconData icon = Icons.device_unknown;
//
//                 if (sensors[index].toLowerCase().contains('fire')) {
//                   icon = Icons.fireplace;
//                 } else if (sensors[index].toLowerCase().contains('dust')) {
//                   icon = Icons.air_outlined;
//                 } else if (sensors[index].toLowerCase().contains('light')) {
//                   icon = Icons.lightbulb;
//                 } else if (sensors[index].toLowerCase().contains('humidity')) {
//                   icon = Icons.invert_colors;
//                 } else if (sensors[index]
//                         .toLowerCase()
//                         .contains('temperature') ||
//                     sensors[index].toLowerCase().contains('temp')) {
//                   icon = Icons.thermostat;
//                 } else if (sensors[index].toLowerCase().contains('rfid')) {
//                   icon = Icons.sensor_door;
//                 } else if (sensors[index].toLowerCase().contains('soil')) {
//                   icon = Icons.eco;
//                 }
//
//                 return GestureDetector(
//                   onTap: () {
//                     if (sensors[index].toLowerCase().contains('gas')) {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => GasSensorPage(
//                             blynkService: BlynkService('your-auth-token-here'),
//                             pin: 'V1',
//                           ),
//                         ),
//                       );
//                     } else if (sensors[index].toLowerCase().contains('light')) {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => LedControlPage(
//                             blynkService: BlynkService(
//                                 'eGTiuLVeg2GRGqbN1YdVib6ByTvjBA_V'),
//                             pin: 'v4',
//                             people: people,
//                           ),
//                         ),
//                       );
//                     } else if (sensors[index].toLowerCase().contains('dust')) {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => DustSensorPage(
//                             blynkService: BlynkService('your-auth-token-here'),
//                             pin: 'V2',
//                           ),
//                         ),
//                       );
//                     } else if (sensors[index]
//                         .toLowerCase()
//                         .contains('humidity')) {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => HumiditySensorPage(
//                             blynkService: BlynkService('your-auth-token-here'),
//                             pin: 'V3',
//                           ),
//                         ),
//                       );
//                     } else if (sensors[index]
//                         .toLowerCase()
//                         .contains('temperature')) {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => TemperatureSensorPage(
//                             blynkService: BlynkService('your-auth-token-here'),
//                             pin: 'V4',
//                           ),
//                         ),
//                       );
//                     } else if (sensors[index].toLowerCase().contains('soil')) {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => SoilMoistureSensorPage(
//                             blynkService: BlynkService('your-auth-token-here'),
//                             pin: 'V6',
//                           ),
//                         ),
//                       );
//                     }
//                   },
//                   child: SensorTile(
//                     sensorName: sensors[index],
//                     icon: icon,
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
// class SensorTile extends StatelessWidget {
//   final String sensorName;
//   final IconData icon;
//
//   const SensorTile({
//     Key? key,
//     required this.sensorName,
//     required this.icon,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Container(
//         height: 100.0,
//         decoration: BoxDecoration(
//           color: Colors.blue,
//           borderRadius: BorderRadius.circular(12.0),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.5),
//               spreadRadius: 5,
//               blurRadius: 7,
//               offset: Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               icon,
//               color: Colors.white,
//               size: 40.0,
//             ),
//             SizedBox(width: 10.0),
//             Text(
//               sensorName,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 16.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smarthome/screens/userSide/floor_plan_rooms/sensor_pages/gas_sensor.dart';
import 'package:smarthome/screens/userSide/floor_plan_rooms/sensor_pages/humidity_sensor.dart';
import 'package:smarthome/screens/userSide/floor_plan_rooms/sensor_pages/ligth_sensor_page.dart';
import 'package:smarthome/screens/userSide/floor_plan_rooms/sensor_pages/rfid_sensor.dart';
import 'package:smarthome/screens/userSide/floor_plan_rooms/sensor_pages/soil_moisture.dart';
import 'package:smarthome/screens/userSide/floor_plan_rooms/sensor_pages/temperatue_sensor.dart';
import 'package:smarthome/services/BlynkService.dart';
import 'package:smarthome/screens/userSide/floor_plan_rooms/sensor_pages/dust_sensor.dart';
import 'package:smarthome/screens/userSide/qrcode_page.dart'; // Import QRCodePage

class RoomPage extends StatelessWidget {
  final String roomName;
  final int people;
  RoomPage({required this.roomName, required this.people});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(roomName),
        actions: [
          Text(
            'People: $people   ',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: Icon(Icons.qr_code),
            onPressed: () {
              final deepLink = 'smarthome://room/$roomName';
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QRCodePage(deepLink: deepLink),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<DocumentSnapshot>(
          future:
              FirebaseFirestore.instance.collection('room').doc(roomName).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Center(child: Text('Room not found'));
            }

            List<String> sensors =
                List<String>.from(snapshot.data!['sensors'] ?? []);

            if (sensors.isEmpty) {
              return Center(child: Text('No sensors available'));
            }

            return ListView.builder(
              itemCount: sensors.length,
              itemBuilder: (context, index) {
                IconData icon = Icons.device_unknown;

                if (sensors[index].toLowerCase().contains('fire')) {
                  icon = Icons.fireplace;
                } else if (sensors[index].toLowerCase().contains('dust')) {
                  icon = Icons.air_outlined;
                } else if (sensors[index].toLowerCase().contains('light')) {
                  icon = Icons.lightbulb;
                } else if (sensors[index].toLowerCase().contains('humidity')) {
                  icon = Icons.invert_colors;
                } else if (sensors[index]
                        .toLowerCase()
                        .contains('temperature') ||
                    sensors[index].toLowerCase().contains('temp')) {
                  icon = Icons.thermostat;
                } else if (sensors[index].toLowerCase().contains('rfid')) {
                  icon = Icons.sensor_door;
                } else if (sensors[index].toLowerCase().contains('soil')) {
                  icon = Icons.eco;
                }

                return GestureDetector(
                  onTap: () {
                    if (sensors[index].toLowerCase().contains('gas')) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GasSensorPage(
                            blynkService: BlynkService('your-auth-token-here'),
                            pin: 'V1',
                          ),
                        ),
                      );
                    } else if (sensors[index].toLowerCase().contains('light')) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LedControlPage(
                            blynkService: BlynkService('your-auth-token-here'),
                            pin: 'V2',
                          ),
                        ),
                      );
                    } else if (sensors[index].toLowerCase().contains('dust')) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DustSensorPage(
                            blynkService: BlynkService('your-auth-token-here'),
                            pin: 'V2',
                          ),
                        ),
                      );
                    } else if (sensors[index]
                        .toLowerCase()
                        .contains('humidity')) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HumiditySensorPage(
                            blynkService: BlynkService('your-auth-token-here'),
                            pin: 'V3',
                          ),
                        ),
                      );
                    } else if (sensors[index]
                        .toLowerCase()
                        .contains('temperature')) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TemperatureSensorPage(
                            blynkService: BlynkService('your-auth-token-here'),
                            pin: 'V4',
                          ),
                        ),
                      );
                    } else if (sensors[index].toLowerCase().contains('soil')) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SoilMoistureSensorPage(
                            blynkService: BlynkService('your-auth-token-here'),
                            pin: 'V6',
                          ),
                        ),
                      );
                    }
                  },
                  child: SensorTile(
                    sensorName: sensors[index],
                    icon: icon,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class SensorTile extends StatelessWidget {
  final String sensorName;
  final IconData icon;

  const SensorTile({
    Key? key,
    required this.sensorName,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        height: 100.0,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 40.0,
            ),
            SizedBox(width: 10.0),
            Text(
              sensorName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
