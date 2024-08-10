import 'package:flutter/material.dart';
import 'package:smarthome/screens/adminSide/adminAnnouncementsPage.dart';
import 'package:smarthome/screens/adminSide/adminFeedbackScreen.dart';
import 'package:smarthome/services/FCMservice.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

class adminHomePage extends StatefulWidget {
  const adminHomePage({super.key});

  @override
  State<adminHomePage> createState() => _adminHomePageState();
}

class _adminHomePageState extends State<adminHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin\'s Home Page'),
      ),
      body: adminAnnouncementScreen(),
      floatingActionButton: ExpandableFab(
        children: [
          FloatingActionButton.small(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => adminFeedbackScreen()));
            },
            child: Icon(Icons.feedback),
          ),
          FloatingActionButton.small(
            heroTag: null,
            child: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(context,
      //         MaterialPageRoute(builder: (context) => adminFeedbackScreen()));
      //   },
      //   child: Icon(Icons.feedback),
      // ),
      // body: SingleChildScrollView(
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       ElevatedButton(
      //           onPressed: () {
      //             Navigator.push(
      //                 context,
      //                 MaterialPageRoute(
      //                     builder: (context) => adminAnnouncementScreen()));
      //           },
      //           child: Text('Announcements'))
      //     ],
      //   ),
      // ),
    );
  }
}
