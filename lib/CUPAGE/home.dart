import 'package:dronapp/CUPAGE/convination_page.dart';
import 'package:dronapp/CUPAGE/shopbasket_page.dart';
import 'package:flutter/material.dart';

class CuHomePage extends StatefulWidget {
  const CuHomePage({super.key});

  @override
  State<CuHomePage> createState() => _CuHomePageState();
}

class _CuHomePageState extends State<CuHomePage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: const Text('편의점 배송'),
          actions: <Widget>[shopBasketButton()],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              storeButton(screenWidth),
              Container(
                width: screenWidth * 0.9,
                height: screenWidth * 0.5,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                        color: Color.fromARGB(51, 97, 97, 97),
                        offset: Offset(3, 3),
                        spreadRadius: 3,
                        blurRadius: 3)
                  ],
                  borderRadius: BorderRadius.circular(20),
                ),
                //border: Border.all(color: Colors.black26, width: 1)),
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Image.asset(
                  'asset/image/commingsoon.jpg',
                  fit: BoxFit.fitHeight,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: screenWidth * 0.9,
                height: screenWidth * 0.5,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                        color: Color.fromARGB(51, 97, 97, 97),
                        offset: Offset(3, 3),
                        spreadRadius: 3,
                        blurRadius: 3)
                  ],
                  borderRadius: BorderRadius.circular(20),
                ),
                //border: Border.all(color: Colors.black26, width: 1)),
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Image.asset(
                  'asset/image/commingsoon.jpg',
                  fit: BoxFit.fitHeight,
                ),
              ),
            ],
          ),
        ));
  }

  Widget storeButton(double screenWidth) {
    return TextButton(
        onPressed: () async {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ConvinationPage()));
        },
        style: const ButtonStyle(
          overlayColor: MaterialStatePropertyAll(Colors.transparent),
          padding: MaterialStatePropertyAll(EdgeInsets.zero),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Column(
          children: [
            SizedBox(
              width: screenWidth,
            ),
            Container(
              width: screenWidth * 0.9,
              height: screenWidth * 0.5,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                      color: Color.fromARGB(51, 97, 97, 97),
                      offset: Offset(3, 3),
                      spreadRadius: 3,
                      blurRadius: 3)
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              //border: Border.all(color: Colors.black26, width: 1)),
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Image.asset(
                'asset/image/gs25.png',
                fit: BoxFit.fitHeight,
              ),
            ),
            SizedBox(
              height: screenWidth * 0.05,
            )
          ],
        ));
  }

  Widget shopBasketButton() {
    return TextButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ShoppingBasketPage()));
        },
        style: const ButtonStyle(
            overlayColor: MaterialStatePropertyAll(Colors.transparent),
            padding: MaterialStatePropertyAll(EdgeInsets.only(right: 10)),
            minimumSize: MaterialStatePropertyAll(Size(0, 0)),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap),
        child: const Icon(
          Icons.shopping_cart,
          color: Colors.black,
        ));
  }
}
