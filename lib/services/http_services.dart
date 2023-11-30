import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/services/notification_services.dart';

class HttpServices {
  Future<void> httpServices(
      {required String title, required String description}) async {
    // send notification from one device to another
    NotificationServices().getToken().then((value) async {
      var data = {
        "to": "/topics/all",
        //'to': value.toString(),
        'notification': {
          'title': title,
          'body': description,
          "sound": "jetsons_doorbell.mp3"
        },
        'android': {
          'notification': {
            'notification_count': 23,
          },
        },
        'data': {'type': 'msg', 'id': title}
      };

      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
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
  }
}
