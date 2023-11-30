// ignore_for_file: prefer_const_constructors
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:untitled/services/firestore_services.dart';
import 'package:untitled/services/http_services.dart';
import 'package:untitled/services/notification_services.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context: context);

    notificationServices.getToken().then((value) {
      print("=== === Device Token: $value === ===");
    });
    notificationServices.setupInteractMessage(context: context);
    // notificationServices.refreshToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Notifications'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              )),
            ),
            SizedBox(height: 10),
            TextField(
              controller: descController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              )),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                notificationServices.getToken().then((value) async {
                  var data = {
                    "to": "/topics/all",
                    //"to": "/topics/allDevices",
                    //'to': value.toString(),
                    'notification': {
                      'title': titleController.text,
                      'body': descController.text,
                      "sound": "jetsons_doorbell.mp3"
                    },
                    'android': {
                      'notification': {
                        'notification_count': 23,
                      },
                    },
                    'data': {'type': 'msg', 'id': descController.text}
                  };

                  await http.post(
                      Uri.parse('https://fcm.googleapis.com/fcm/send'),
                      body: jsonEncode(data),
                      headers: {
                        'Content-Type': 'application/json; charset=UTF-8',
                        'Authorization':
                            'key=AAAANh2HznU:APA91bGEn-YZ-3VDV85IuUsyKHN7fW4S2L7cn-tUx45SKKfZCfMTBwYbIOgBN23raNhxbViZX0NPrpvIAgl-XBPbYdohzQJona_e3C7Ww3XTTkdWwf5h_FB8HZLgHnCtyATu1wdFhUth'
                      }).then((value) {
                    if (kDebugMode) {
                      print(value.body.toString());
                    }
                  }).onError((error, stackTrace) {
                    if (kDebugMode) {
                      print(error);
                    }
                  });
                });
                // HttpServices()
                //     .httpServices(
                //   title: titleController.text,
                //   description: descController.text,
                // )
                //     .then((value) {
                //   FirebaseServices.storeData(
                //       title: titleController.text,
                //       description: descController.text);
                // });
              },
              child: Text('Send Notifications'),
            ),
          ],
        ),
      ),
    );
  }
}
