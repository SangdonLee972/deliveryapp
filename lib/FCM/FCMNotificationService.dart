import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
class FCMNotificationService{

  final pushFcmUrl = 'https://us-central1-dronquick-84db1.cloudfunctions.net/pushFcm';

  Future<void> pushAnswer(String token) async {
    try {
      final http.Response response = await http.post(
        Uri.parse('$pushFcmUrl/insu'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({'token': token}),
      );
      print('pushFCM: success');
    } catch (e) {
      print('pushFAQ: $e');
      throw Exception("pushFAQ: $e");
    }
  }


  //배송완료
  Future<void> pushAnswersuccess(String token) async {
    try {
      final http.Response response = await http.post(
        Uri.parse('$pushFcmUrl/success'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({'token': token}),
      );
      print('pushFCM: success');
    } catch (e) {
      print('pushFAQ: $e');
      throw Exception("pushFAQ: $e");
    }
  }




// Future<String?> postMessage(String fcmToken) async {
//   try {
//     String _accessToken = 'ya29.a0AfB_byDM52ROXL8UKULrfvkvQxcINXIb0Y8MlShvRqIJ9W-2bvnZ1Iwj-PtXKz8Q7NDhjD5pqda8Gws0d2XYgY9IY_hM2YWWIPjcAnQv9nj9ZNgyoI-SBUez9qZ6MhIe8p1-QbMXZ0KclQSHDBrOyXDw-l9FvDoTQQaCgYKARgSARESFQGOcNnC82vWyNYfuJ2sP6xFQiBhWQ0169';
//     http.Response _response = await http.post(
//         Uri.parse(
//           "https://fcm.googleapis.com/v1/projects/deliverydroneapp-89b9d/messages:send",
//         ),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $_accessToken',
//         },
//         body: json.encode({
//           "message": {
//             "token": fcmToken,
//             // "topic": "user_uid",
//
//             "notification": {
//               "title": "드론 배송어플리케이션",
//               "body": "주문이 인수 되었습니다.",
//             },
//             "data": {
//               "click_action": "FCM Test Click Action",
//             },
//             "android": {
//               "notification": {
//                 "click_action": "Android Click Action ",
//               }
//             },
//             "apns": {
//               "payload": {
//                 "aps": {
//                   "category": "Message Category",
//                   "content-available": 1
//                 }
//               }
//             }
//           }
//         }));
//     if (_response.statusCode == 200) {
//       return null;
//     } else {
//       return _response.statusCode.toString();
//     }
//   } on HttpException catch (error) {
//     return error.message;
//   }
// }

}