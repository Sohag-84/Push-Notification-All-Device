// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class FirebaseServices {
  static storeData({required String title, required String description}) {
    CollectionReference data = firestore.collection("NotificationData");
    data.doc().set({
      "title": title,
      "description": description,
    }).then((value) {
      print("======== saved ======");
    }).catchError((error) {
      print("=====Error: $error==========");
    });
  }
}
