
import 'package:dronapp/MainPage/mainPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'LoginPage/loginPage.dart';
import 'LoginPage/login_function.dart';
import 'Model/User.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    //options: DefaultFirebaseOptions.currentPlatform,
  );

  if (FirebaseAuth.instance.currentUser != null) {
    EmailLogin login = EmailLogin();
    var a = await login.getData();
    if (!a) {
      login.signout();
    }
  }
 // await FirebaseApi().fcmSetting();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus(); // 키보드 닫기 이벤트
        },
        child: MaterialApp(
            title: 'D-NURI',
            theme: ThemeData(
              primarySwatch: Colors.purple,
            ),
            home: const LoginPage()


        ));
  }
}
