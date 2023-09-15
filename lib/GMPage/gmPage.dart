// cushopPage.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronedelivery/Model/Menuinfo.dart';
import 'package:dronedelivery/Model/orderinfo.dart';
import 'package:dronedelivery/Service/OrderService.dart';
import 'package:dronedelivery/User/profile_page.dart';
import 'package:dronedelivery/User/user_Info.dart';
import 'package:dronedelivery/Widget/ListItemWidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Model/Order.dart';
import '../Model/User.dart';

class CuShopPage extends StatefulWidget {
  const CuShopPage({Key? key}) : super(key: key);

  @override
  State<CuShopPage> createState() => CuShopPageState();
}

class CuShopPageState extends State<CuShopPage> {
  OrderService orderService = OrderService();
  bool isLoading = true;
  List<OrderInfo> orderList = [];

  void addmenu() async {
    MenuInfo sampleMenu = MenuInfo(
      Menuname: "샘플 메뉴",
      MenuImage: "sample_image_url.jpg",
      price: 10000,
      num: 1,
      MenuInfoString: "이것은 샘플 메뉴 설명입니다.",
    );

    List<Map<String, dynamic>> menus = [];
    menus.add(sampleMenu.toJson());
    menus.add(sampleMenu.toJson());
    menus.add(sampleMenu.toJson());

    OrderService orderService = OrderService();
    OrderInfo orderInfo = OrderInfo(
        id: '1',
        isStore: null,
        isManager: null,
        status: '1',
        menuInfo: '1',
        FCMID: UserInstance.instance.fcmid as String,
        menus: menus,
        userId: UserInstance.instance.email as String,
        storeID: 'aa@naver.com',
        userAddress: '수원시 팔달구 우만동 62번지 삼우빌 205호',
        storetype: '편의점',
        time: DateTime.now());

    orderService.addOrderToHistory(
        UserInstance.instance.email as String, orderInfo);
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
          title: Text('편의점 관리자 페이지'),
        ),
        drawer: Drawer(
            child: ListView(padding: EdgeInsets.zero, children: [
              Container(
                padding: EdgeInsets.only(left: 15, bottom: 15),
                height: screenWidth * 0.4,
                decoration: const BoxDecoration(
                    color: Colors.purple,
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
                        child: Text(UserInstance.instance.email!,
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
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfilePage()));
                  setState(() {});
                },
                title: Text('회원정보'),
              ),
            ])),
        body: StreamBuilder<List<OrderModel>>(
          stream: orderService.getOrderHistoryStream(
              UserInstance.instance.id as String), // 스트림을 얻는 메서드 활용
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<OrderModel> orderHistory = snapshot.data!;

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
                                  .format(orderHistory[index].time),
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
