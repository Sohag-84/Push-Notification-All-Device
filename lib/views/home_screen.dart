// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:untitled/services/firestore_services.dart';
import 'package:untitled/services/http_services.dart';
import 'package:untitled/services/notification_services.dart';

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
                HttpServices()
                    .httpServices(
                  title: titleController.text,
                  description: descController.text,
                )
                    .then((value) {
                  FirebaseServices.storeData(
                      title: titleController.text,
                      description: descController.text);
                });
              },
              child: Text('Send Notifications'),
            ),
          ],
        ),
      ),
    );
  }
}
