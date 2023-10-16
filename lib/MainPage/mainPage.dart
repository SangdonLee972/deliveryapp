import 'package:card_swiper/card_swiper.dart';
import 'package:dronapp/CUPAGE/home.dart';
import 'package:dronapp/LoginPage/loginPage.dart';
import 'package:dronapp/MainPage/profilePage.dart';
import 'package:dronapp/MainPage/recipent_History.dart';
import 'package:dronapp/Model/User.dart';
import 'package:dronapp/alert_error.dart';
import 'package:dronapp/sinchungsua/applicationPage.dart';
import 'package:dronapp/sinchungsua/notification.dart';
import 'package:dronapp/sinchungsua/reverseDelivery.dart';
import 'package:dronapp/sinchungsua/reverseNotification.dart';
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
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          'asset/image/mainlogo.png',
          fit: BoxFit.fitWidth,
        ),
        Expanded(
            child: SingleChildScrollView(
          child: Column(children: [
            topRayout(screenWidth),
            SizedBox(
              width: double.infinity,
              height: 230.0,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  final imagePath =
                      'images/${(index + 1).toString().padLeft(3, '0')}.png';

                  return Image.asset(
                    imagePath,
                    fit: BoxFit.fitWidth,
                  );
                },
                itemCount: 3,
                viewportFraction: 1,
                scale: 0.9,
                autoplay: true, // 자동 재생 활성화
                autoplayDelay: 3000,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              '  배송서비스별 빠르게 신청하기',
              style: TextStyle(
                  fontSize: screenWidth * 0.045, fontWeight: FontWeight.w800),
            ),
            const SizedBox(
              height: 10,
            ),
            midButton(screenWidth),
            bottomRogo()
          ]),
        )),
      ],
    ));
  }

  Widget topRayout(double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
            onPressed: () async {
              if (UserInstance.instance.name != null) {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage()));
              } else {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              }
            },
            style: const ButtonStyle(
                overlayColor: MaterialStatePropertyAll(Colors.transparent)),
            child: Row(
              children: [
                Text(
                  UserInstance.instance.name != null
                      ? '   ${UserInstance.instance.name!}'
                      : '   로그인하기',
                  style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600),
                ),
                UserInstance.instance.name != null
                    ? Text('님 ',
                        style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500))
                    : Text(''),
                Icon(
                  Icons.arrow_forward_ios,
                  size: screenWidth * 0.04,
                  color: Colors.black54,
                )
              ],
            )),
        // TextButton(
        //     onPressed: () {
        //       Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //               builder: (context) => const RecipientHistory()));
        //     },
        //     style: const ButtonStyle(
        //         overlayColor: MaterialStatePropertyAll(Colors.transparent)),
        //     child: Column(
        //       children: [
        //         Icon(
        //           Icons.description,
        //           color: Colors.black54,
        //           size: screenWidth * 0.05,
        //         ),
        //         SizedBox(
        //           height: screenWidth * 0.01,
        //         ),
        //         Text(
        //           '신청내역',
        //           style: TextStyle(
        //               fontSize: screenWidth * 0.025, color: Colors.black54),
        //         )
        //       ],
        //     ))
      ],
    );
  }

  Widget midButton(double screenWidth) {
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
                color: Color.fromARGB(255, 169, 230, 222),
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
                    color: Color.fromARGB(255, 66, 154, 147),
                  ),
                  Expanded(
                      child: Container(
                    height: screenWidth * 0.25,
                    color: Colors.black12,
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.02,
                        vertical: screenWidth * 0.08),
                    child: Text(
                      '택배배송',
                      style: TextStyle(
                          color: Color.fromARGB(255, 52, 121, 103),
                          fontSize: screenWidth * 0.044,
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
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => CuHomePage()));
          },
          style: const ButtonStyle(
              overlayColor: MaterialStatePropertyAll(Colors.black12),
              padding: MaterialStatePropertyAll(EdgeInsets.zero)),
          child: Column(
            children: [
              Container(
                  width: double.maxFinite,
                  height: screenWidth * 0.5,
                  color: Color.fromARGB(255, 248, 193, 189),
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                      vertical: screenWidth * 0.1),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'asset/image/gs25.png',
                      fit: BoxFit.fitWidth,
                    ),
                  )),
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
                        vertical: screenWidth * 0.08),
                    child: Text(
                      '편의점배송',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 238, 87, 76),
                          fontSize: screenWidth * 0.045,
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
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ReverseApplicationPage()));
          },
          style: const ButtonStyle(
              padding: MaterialStatePropertyAll(EdgeInsets.zero),
              overlayColor: MaterialStatePropertyAll(Colors.black12)),
          child: Column(
            children: [
              Container(
                width: double.maxFinite,
                height: screenWidth * 0.5,
                color: Color.fromARGB(255, 206, 209, 254),
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                child: Center(
                    child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset('asset/image/seafood.png'),
                )),
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
                        vertical: screenWidth * 0.05),
                    child: Text(
                      '특산물\n역배송',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: screenWidth * 0.044,
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

  Widget bottomRogo() {
    double screenWidth = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Image.asset(
          'asset/image/logo1.png',
          width: screenWidth * 0.2,
          fit: BoxFit.fitWidth,
        ),
        Image.asset(
          'asset/image/logo3.png',
          width: screenWidth * 0.2,
          fit: BoxFit.fitWidth,
        ),
        Image.asset(
          'asset/image/logo2.png',
          width: screenWidth * 0.2,
          fit: BoxFit.fitWidth,
        ),
        Image.asset(
          'asset/image/logo5.png',
          width: screenWidth * 0.2,
          fit: BoxFit.fitWidth,
        ),
        Image.asset(
          'asset/image/logo4.png',
          width: screenWidth * 0.2,
          fit: BoxFit.fitWidth,
        ),
      ],
    );
  }
}
