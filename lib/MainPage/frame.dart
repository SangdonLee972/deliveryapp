import 'package:dronapp/MainPage/mainPage.dart';
import 'package:dronapp/MainPage/profilePage.dart';
import 'package:dronapp/MainPage/recipent_History.dart';
import 'package:flutter/material.dart';

class UserMainFrame extends StatefulWidget {
  const UserMainFrame({super.key});

  @override
  State<UserMainFrame> createState() => _UserMainFrameState();
}

class _UserMainFrameState extends State<UserMainFrame> {
  int selectedIdx = 0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    List<Widget> widgets = [
      const MainPage(),
      const ProfilePage(),
      const RecipientHistory()
    ];
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: widgets[selectedIdx],
          ),
          Container(
            color: Colors.black,
            width: double.maxFinite,
            height: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              button(screenWidth, Icons.home, '홈', 0),
              button(screenWidth, Icons.person, '마이', 1),
              button(screenWidth, Icons.article_outlined, '이용내역', 2),
              button(screenWidth, Icons.verified, '혜택', 3),
              button(screenWidth, Icons.more_horiz, '더보기', 4)
            ],
          )
        ]),
      ),
    );
  }

  TextButton button(double screenWidth, IconData data, String text, int idx) {
    return TextButton(
        onPressed: () {
          if (selectedIdx != idx && idx < 3) {
            setState(() {
              selectedIdx = idx;
            });
          }
        },
        style: ButtonStyle(
            foregroundColor: MaterialStatePropertyAll(selectedIdx == idx
                ? const Color.fromARGB(255, 105, 186, 253)
                : Colors.black26),
            overlayColor: const MaterialStatePropertyAll(Colors.transparent)),
        child: Column(
          children: [
            Icon(
              data,
              size: screenWidth * 0.06,
            ),
            Text(
              text,
              style: TextStyle(fontSize: screenWidth * 0.03),
            )
          ],
        ));
  }
}
