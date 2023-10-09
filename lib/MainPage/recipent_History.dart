import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronapp/Model/Order.dart';
import 'package:dronapp/Model/User.dart';
import 'package:dronapp/deliverydetail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecipientHistory extends StatefulWidget {
  const RecipientHistory({super.key});

  @override
  State<RecipientHistory> createState() => _RecipientHistoryState();
}

class _RecipientHistoryState extends State<RecipientHistory> {
  var f = NumberFormat('###,###,###,###');

  Stream<List<OrderModel>> getAllOrdersStream() {
    return FirebaseFirestore.instance
        .collection('orders')
        .orderBy('datetime', descending: true)
        .where('id',
            whereIn: UserInstance.instance.orders.isEmpty
                ? ['1']
                : UserInstance.instance.orders)
        .snapshots()
        .map((querySnapshot) {
      if (querySnapshot.docs.isEmpty) {
        print('Firestore returned no documents');
      } else {
        print('Firestore returned documents: ${querySnapshot.docs.length}');
      }
      List<OrderModel> allOrders = [];

      for (var doc in querySnapshot.docs) {
        allOrders.add(OrderModel.fromMap(doc.data()));
      }
      return allOrders;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text('신청내역조회'),
      ),
      body: StreamBuilder(
        stream: getAllOrdersStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error,
                    color: Colors.black12,
                    size: screenWidth * 0.3,
                  ),
                  const Text(
                    '데이터를 불러오는 중에 오류가 발생하였습니다.\n 다시 실행해주세요',
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            );
          }
          if (snapshot.hasData) {
            List<OrderModel> orderModels = snapshot.data ?? [];
            if (orderModels.isNotEmpty) {
              return SingleChildScrollView(
                  child: Column(
                children: [
                  SizedBox(
                    width: screenWidth,
                    height: screenWidth * 0.05,
                  ),
                  for (int i = 0; i < orderModels.length; i++)
                    Padding(
                      padding: EdgeInsets.only(bottom: screenWidth * 0.03),
                      child: recipientWidget(orderModels[i], screenWidth),
                    )
                ],
              ));
            }
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.post_add_outlined,
                  color: Colors.black12,
                  size: screenWidth * 0.25,
                ),
                const Text(
                  '신청내역이 존재하지 않습니다.',
                  textAlign: TextAlign.center,
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget recipientWidget(OrderModel orderModel, double screenWidth) {
    return TextButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) =>
                      DeliveryDetailPage(order: orderModel))));
        },
        style: const ButtonStyle(
            padding: MaterialStatePropertyAll(EdgeInsets.zero),
            overlayColor: MaterialStatePropertyAll(Color.fromARGB(10, 0, 0, 0)),
            foregroundColor: MaterialStatePropertyAll(Colors.black)),
        child: Container(
          width: screenWidth * 0.9,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(width: 1, color: Colors.black26)),
          child: Column(
            children: [
              Container(
                width: screenWidth * 0.9,
                height: 5,
                color: Colors.black,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenWidth * 0.05),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '[(주)나르마] 제주드론배송센터',
                            style: TextStyle(
                                fontSize: screenWidth * 0.036,
                                color: Color.fromARGB(255, 33, 79, 243)),
                          ),
                          Text(DateFormat('yyyy-MM-dd')
                              .format(orderModel.datetime))
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: screenWidth * 0.58,
                                child: Text(
                                  orderModel.obj.objName,
                                  maxLines: 1,
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: screenWidth * 0.045,
                                      color: const Color.fromARGB(
                                          255, 44, 23, 235),
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                '예상 배송비 : ${f.format(0)}원',
                                style: TextStyle(fontSize: screenWidth * 0.036),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                '최종 배송비 : ${f.format(0)}원',
                                style: TextStyle(fontSize: screenWidth * 0.036),
                              )
                            ],
                          ),
                          Container(
                            width: screenWidth * 0.17,
                            height: screenWidth * 0.18,
                            color: Colors.blue,
                            child: Center(
                              child: Text(
                                orderModel.status,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.032,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          )
                        ],
                      )
                    ]),
              )
            ],
          ),
        ));
  }
}
