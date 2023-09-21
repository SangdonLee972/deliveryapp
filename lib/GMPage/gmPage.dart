
import 'package:dronapp/LoginPage/login_function.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../LoginPage/loginPage.dart';
import '../Model/Order.dart';
import '../Model/User.dart';
import '../Service/OrderService.dart';
import 'Widget/GmPageWidget.dart';

class gmPage extends StatefulWidget {
  const gmPage({Key? key}) : super(key: key);

  @override
  State<gmPage> createState() => gmPageState();
}

class gmPageState extends State<gmPage> {
  OrderService orderService = OrderService();
  bool isLoading = true;
  List<OrderModel> orderList = [];

  void addmenu() async {
    OrderService orderService = OrderService();

// 주문 추가 예시
    await orderService.addOrder(
      '확인중', // status
      'user123', // userId
      '', // picture
      DateTime.now(), // datetime
      50.0, // price
      ['type1', 'type2'], // type
      'obj_url', // objUrl
      'obj_name', // objName
      10.0, // objPrice
      2, // objCount
      'large', // objSize
      0.5, // objMass
      'John Doe', // deliveryName
      '123-456-7890', // deliveryPhoneNumber
      '123 Main St', // deliveryAddress
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return isLoading
        ? Scaffold(
            appBar: AppBar(
              title: Text('배송 신청 목록'),
              backgroundColor: Colors.blue,
            ),
            drawer: Drawer(
                child: ListView(padding: EdgeInsets.zero, children: [
              Container(
                padding: EdgeInsets.only(left: 15, bottom: 15),
                height: screenWidth * 0.4,
                decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(30))),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        UserInstance.instance.name!,
                        style: TextStyle(
                            color: Colors.white, fontSize: screenWidth * 0.055),
                      ),
                      SizedBox(
                        width: screenWidth * 0.6,
                        child: Text(UserInstance.instance.id!,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.035)),
                      ),
                      SizedBox(
                        height: screenWidth * 0.01,
                      ),
                    ]),
              ),
              ListTile(
                leading: Icon(Icons.person,
                    color: Colors.grey[850]), // 좌측기준 스위프트에서 leading
                onTap: () async {
                  // await Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const ProfilePage()));
                  // setState(() {});

                    FirebaseAuth.instance.signOut();
                    Navigator.popUntil(context, (route) => false);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                     setState(() {});
                },
                title: Text('로그아웃'),
              ),
            ])),
            body: StreamBuilder<List<OrderModel>>(
              stream: orderService.getAllOrdersStream(), // 스트림을 얻는 메서드 활용
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<OrderModel> orderHistory = snapshot.data!;

                  if (orderHistory.isEmpty) {
                    return Center(child: Text('주문 내역이 없습니다.'));
                  }

              if (orderHistory.isEmpty) {
                return Center(child: Text('주문 내역이 없습니다.'));
              }

              DateTime? lastDate;
              // '상품 인수'인 주문만 필터링하고 '상품 인수'인 주문이 있을 때 print를 실행합니다.

                  return ListView.builder(
                    itemCount: orderHistory.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> orderMap =
                          orderHistory[index].toMap();
                      DateTime nowDate = orderHistory[index].datetime;
                      print(nowDate);
                      if (lastDate == null ||
                          (lastDate!.year != nowDate.year ||
                              lastDate!.month != nowDate.month ||
                              lastDate!.day != nowDate.day)) {
                        lastDate = orderHistory[index].datetime;
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: screenWidth * 0.32,
                                  height: 1,
                                  color: Colors.black26,
                                ),
                                SizedBox(
                                  width: 10,
                                  height: screenWidth * 0.1,
                                ),
                                Text(
                                  DateFormat('yyyy년MM월dd일')
                                      .format(orderHistory[index].datetime),
                                  style: TextStyle(
                                      fontSize: screenWidth * 0.033,
                                      color: Colors.black26),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: screenWidth * 0.32,
                                  height: 1,
                                  color: Colors.black26,
                                ),
                              ],
                            ),
                            ListItemWidget(orderMap, index)
                          ],
                        );
                      }
                      return ListItemWidget(orderMap, index);
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('에러 발생: ${snapshot.error}'));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ))
        : Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: Text(
              '로딩중',
              style: TextStyle(
                fontSize: 100,
              ),
            ),
          );
  }
}
