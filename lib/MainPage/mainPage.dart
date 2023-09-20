import 'package:dronapp/MainPage/profilePage.dart';
import 'package:dronapp/MainPage/recipent_History.dart';
import 'package:dronapp/Model/User.dart';
import 'package:dronapp/alert_error.dart';
import 'package:dronapp/sinchungsua/applicationPage.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          topRayout(screenWidth),
          Container(
            width: screenWidth,
            height: screenWidth * 0.6,
            color: Colors.black12,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            '  배송서비스별 빠르게 신청하기',
            style: TextStyle(
                fontSize: screenWidth * 0.045, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 10,
          ),
          MidButton(screenWidth),
        ],
      )),
    ));
  }

  Widget topRayout(double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
            onPressed: () async {
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfilePage()));
            },
            style: const ButtonStyle(
                overlayColor: MaterialStatePropertyAll(Colors.transparent)),
            child: Row(
              children: [
                Text(
                  '     ${UserInstance.instance.name!}님 ',
                  style: TextStyle(
                      fontSize: screenWidth * 0.045, color: Colors.black54),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: screenWidth * 0.04,
                  color: Colors.black54,
                )
              ],
            )),
        TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RecipientHistory()));
            },
            style: const ButtonStyle(
                overlayColor: MaterialStatePropertyAll(Colors.transparent)),
            child: Column(
              children: [
                Icon(
                  Icons.description,
                  color: Colors.black54,
                  size: screenWidth * 0.05,
                ),
                SizedBox(
                  height: screenWidth * 0.01,
                ),
                Text(
                  '신청내역',
                  style: TextStyle(
                      fontSize: screenWidth * 0.025, color: Colors.black54),
                )
              ],
            ))
      ],
    );
  }

  Widget MidButton(double screenWidth) {
    return Row(
      children: [
        Expanded(
            child: TextButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ApplicationPage()));
          },
          style: const ButtonStyle(
              overlayColor: MaterialStatePropertyAll(Colors.black12),
              padding: MaterialStatePropertyAll(EdgeInsets.zero),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap),
          child: Column(
            children: [
              Container(
                width: double.maxFinite,
                height: screenWidth * 0.5,
                color: Color.fromARGB(255, 144, 226, 147),
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                child: Center(
                  child: Image.asset('asset/image/box.png'),
                ),
              ),
              SizedBox(
                height: screenWidth * 0.03,
              ),
              Row(
                children: [
                  Container(
                    width: screenWidth * 0.03,
                    height: screenWidth * 0.25,
                    color: Colors.green,
                  ),
                  Expanded(
                      child: Container(
                    height: screenWidth * 0.25,
                    color: Colors.black12,
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.02,
                        vertical: screenWidth * 0.02),
                    child: Text(
                      '택배배송',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: screenWidth * 0.042,
                          fontWeight: FontWeight.w600),
                    ),
                  ))
                ],
              ),
            ],
          ),
        )),
        Expanded(
            child: TextButton(
          onPressed: () {
            OverlaySetting().showErrorAlert(context, '준비중입니다');
          },
          style: const ButtonStyle(
              overlayColor: MaterialStatePropertyAll(Colors.black12),
              padding: MaterialStatePropertyAll(EdgeInsets.zero)),
          child: Column(
            children: [
              Container(
                  width: double.maxFinite,
                  height: screenWidth * 0.5,
                  color: Color.fromARGB(255, 234, 117, 109),
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                  child: Image.asset('asset/image/mart.png')),
              SizedBox(
                height: screenWidth * 0.03,
              ),
              Row(
                children: [
                  Container(
                    width: screenWidth * 0.03,
                    height: screenWidth * 0.25,
                    color: const Color.fromARGB(255, 238, 87, 76),
                  ),
                  Expanded(
                      child: Container(
                    height: screenWidth * 0.25,
                    color: Colors.black12,
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.02,
                        vertical: screenWidth * 0.02),
                    child: Text(
                      '슈퍼,마트배송',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 238, 87, 76),
                          fontSize: screenWidth * 0.042,
                          fontWeight: FontWeight.w600),
                    ),
                  ))
                ],
              ),
            ],
          ),
        )),
        Expanded(
            child: TextButton(
          onPressed: () {
            OverlaySetting().showErrorAlert(context, '준비중입니다');
          },
          style: ButtonStyle(
              padding: MaterialStatePropertyAll(EdgeInsets.zero),
              overlayColor: MaterialStatePropertyAll(Colors.black12)),
          child: Column(
            children: [
              Container(
                width: double.maxFinite,
                height: screenWidth * 0.5,
                color: Color.fromARGB(255, 236, 236, 145),
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                child: Center(child: Image.asset('asset/image/back.png')),
              ),
              SizedBox(
                height: screenWidth * 0.03,
              ),
              Row(
                children: [
                  Container(
                    width: screenWidth * 0.03,
                    height: screenWidth * 0.25,
                    color: Colors.blue,
                  ),
                  Expanded(
                      child: Container(
                    height: screenWidth * 0.25,
                    color: Colors.black12,
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.02,
                        vertical: screenWidth * 0.02),
                    child: Text(
                      '역배송',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: screenWidth * 0.042,
                          fontWeight: FontWeight.w600),
                    ),
                  ))
                ],
              ),
            ],
          ),
        ))
      ],
    );
  }
}
