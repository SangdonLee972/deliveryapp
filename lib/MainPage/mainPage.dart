
import 'package:dronapp/Model/User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';


class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => MainPageState();
}


class MainPageState extends State<MainPage> {

  // This widget is the root of your application.

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Center(
              child: TextButton(onPressed: () {
                print('유저데이터 테스트\n '
                    '유저 이름: ${UserInstance.instance.name}\n'
                    '유저 주소: ${UserInstance.instance.address}\n'
                    '유저 주문ID: ${UserInstance.instance.orders}\n'
                    '유저 전화번호: ${UserInstance.instance.phoneNumber}\n'
                    '유저 Type: ${UserInstance.instance.type}\n'
                    '유저 fcmToken: ${UserInstance.instance.fcmid}\n'

                );
              }
                  , child: Text('메인 Page ( User가 넘어올시 화면 )')),

            )

          ],
        ),
      )
    );
  }


}
