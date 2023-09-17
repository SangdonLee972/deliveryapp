import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
Future<void> handleBackgroundMessage(RemoteMessage message)async {
  print('Title: ${message.notification?.title}');
  print('body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;



  Future<String?> fcmSetting() async {




    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    FlutterLocalNotificationsPlugin _localNotification =
    FlutterLocalNotificationsPlugin();
    AndroidInitializationSettings initSettingsAndroid =
    const AndroidInitializationSettings('@mipmap/ic_launcher');
    DarwinInitializationSettings initSettingsIOS =
    const DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    InitializationSettings initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );
    await _localNotification.initialize(
      initSettings,
    );




    final AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.', // description
      importance: Importance.max,
    );
    // 2.
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      print('got a Message whilist in the foreground');
      print('Message data: ${message.data}');


      NotificationDetails _details = const NotificationDetails(
        android: AndroidNotificationDetails('alarm 1', '1번 푸시'),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );


      if (message.notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(notification.hashCode,
            notification?.title, notification?.body,
            _details);

        print('message also contained a notification: ${message.notification}');
      }
    });
    String? firebaseToken = await messaging.getToken();
    print('firebaseFCMToken : ${firebaseToken}');

    return firebaseToken;
  }
}