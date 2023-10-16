
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

class gmPageState extends State<gmPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  OrderService orderService = OrderService();
  bool isLoading = true;
  List<OrderModel> orderList = [];

  void fetchInitialData() async {
    // 여기서 데이터를 가져옵니다. 예를 들면:

    orderList = (await orderService.getAllOrdersStream()) as List<OrderModel>; // 이 함수는 실제로 구현해야 합니다.

    // 데이터가 로드된 후 isLoading 값을 false로 설정합니다.
    setState(() {
      isLoading = false;
    });
  }




  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  @override
  void dispose() {
    _tabController.dispose();  // Always dispose controllers when they're no longer needed
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return isLoading
        ? Scaffold(
        appBar: AppBar(
          title: Text('배송 신청 목록'),
          backgroundColor: Colors.blue,
          bottom: TabBar(
            controller: _tabController, // assign the controller
            tabs: [
              Tab(text: '택배배송'),
              Tab(text: '역배송'),
              Tab(text: '편의점배송'),
            ],

          ),
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

                      Text(
                        "관리자",
                        style: TextStyle(
                            color: Colors.white, fontSize: screenWidth * 0.035),
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

        body: TabBarView(
          controller: _tabController, // assign the controller
          children: [
            _buildOrderList('택배배송',screenWidth),
            _buildOrderList('역배송',screenWidth),
            _buildOrderList('편의점배송',screenWidth),
          ],
        )
    )
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

  Widget _buildOrderList(String type,double screenWidth) {
    return StreamBuilder<List<OrderModel>>(
      stream: orderService.getAllOrdersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<OrderModel> orders = snapshot.data!.where((order) => order.type.contains(type)).toList();

          if (type == '택배배송') {
            orders = snapshot.data!.where((order) => order.type.isEmpty || order.type.contains(type)).toList();
          } else {
            orders = snapshot.data!.where((order) => order.type.contains(type)).toList();
          }

          if (orders.isEmpty) {
            return Center(child: Text('$type 주문 내역이 없습니다.'));
          }


          if (orders.isEmpty) {
            return Center(child: Text('$type 주문 내역이 없습니다.'));
          }

          DateTime? lastDate;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              int reverseIndex = orders.length - 1 - index;
              Map<String, dynamic> orderMap = orders[index].toMap();
              DateTime nowDate = orders[index].datetime;

              if (lastDate == null ||
                  (lastDate!.year != nowDate.year ||
                      lastDate!.month != nowDate.month ||
                      lastDate!.day != nowDate.day)) {
                lastDate = orders[index].datetime;

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
                        SizedBox(width: 10, height: screenWidth * 0.1),
                        Text(
                          DateFormat('yyyy년MM월dd일').format(orders[index].datetime),
                          style: TextStyle(
                              fontSize: screenWidth * 0.033,
                              color: Colors.black26),
                        ),
                        SizedBox(width: 10),
                        Container(
                          width: screenWidth * 0.32,
                          height: 1,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                    ListItemWidget(orderMap, reverseIndex)
                  ],
                );
              }
              return ListItemWidget(orderMap, reverseIndex);
            },
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('에러 발생: ${snapshot.error}'));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

}
