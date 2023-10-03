import 'package:dronapp/sinchungsua/applicationPage.dart';
import 'package:dronapp/sinchungsua/reverseDelivery.dart';
import 'package:flutter/material.dart';

class ReverseNotificationPage extends StatelessWidget {
  const ReverseNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('안내 페이지'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: screenWidth * 0.08, horizontal: screenWidth * 0.05),
            child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ReverseApplicationPage()));
                },
                child: Container(
                  width: screenWidth * 0.9,
                  height: screenWidth * 0.15,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey),
                  alignment: Alignment.center,
                  child: Text(
                    '신청서 작성하기',
                    style: TextStyle(
                        color: Colors.black, fontSize: screenWidth * 0.045),
                  ),
                )),
          )
        ],
      ),
    );
  }
}
