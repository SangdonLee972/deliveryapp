// ListItemWidget.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronapp/Model/Order.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../Service/OrderService.dart';
import 'DetailPage.dart';



class ListItemWidget extends StatefulWidget {
  final Map<String, dynamic> items;
  final int number;

  const ListItemWidget(this.items, this.number, {Key? key}) : super(key: key);

  @override
  ListItemWidgetState createState() => ListItemWidgetState();
}

class ListItemWidgetState extends State<ListItemWidget> {
  String formatISOToFullDateTime(String isoString) {
    DateTime time = DateTime.parse(isoString);




    print("AA");
    String amPm = time.hour < 12 ? '오전' : '오후';

    // 12시간제로 시간 조정
    int hour12Format = time.hour > 12 ? time.hour - 12 : time.hour;
    if (hour12Format == 0) hour12Format = 12; // 12시 처리

    return '주문일자 : ${time.year}년 ${time.month}월 ${time.day}일 $amPm ${hour12Format.toString().padLeft(2, '0')}시:${time.minute.toString().padLeft(2, '0')}분';
  }


  bool isOrderSucess = false;





  OrderService orderService = OrderService();
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> objMap = widget.items['obj'];

    Map<String,dynamic> deliveryInfo = widget.items['deliveryInfo'];
    if (widget.items['status'] == null) {
      // 'status'가 null인 경우에 대한 처리
      print("status is null");
    } else if (widget.items['status'] == '배송 불가') {
      // 'status'가 '배송 불가'인 경우에 대한 처리
      print("status is decept");

    } else if (widget.items['status'] == '확인중') {
      print("status is check");

      // 'status'가 '확인중'인 경우에 대한 처리
    } else {
      print("status is 변수");

      // 위의 조건에 해당하지 않는 경우에 대한 처리
    }

    return Card(
      elevation: 4.0, // <-- 카드의 그림자 깊이
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // <-- 카드의 모서리 둥글게 설정
      ),
      child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                          '주문 ${widget.number.toString()} 주문 가능여부: '),

                      if(widget.items['status'] == '배송 불가' )
                        Row(
                          children: [
                            Icon(Icons.cancel_outlined,
                                color: Colors.red), // 체크 아이콘 추가
                            Text('배송 불가',
                                style: TextStyle(color: Colors.red)),
                          ],
                        )

                      else if (widget.items['status'] == '확인중')
                          Text('관리자 승인 대기중...')
                        else if (widget.items['status'] != '배송 불가' ||
                        widget.items['status'] != '확인중')
                            Row(
                              children: [
                                Icon(Icons.check_circle,
                                    color: Colors.blue), // 체크 아이콘 추가
                                Text('주문 접수', style: TextStyle(color: Colors.blue)),
                              ],
                            ),
                    ],
                  ),
                  Text(formatISOToFullDateTime(widget.items['datetime'] as String)),
                  Text('주문자 정보 : ${deliveryInfo['name']}'),
                  if (widget.items['obj'] != null)

                Text(
                '- ${objMap['objPrice']}  ${objMap['objName']} ${objMap['objSize']}',
                style: TextStyle(color: Colors.black45, fontSize: 14),
                ),
                  Text(
                    '  총합 가격: 0 원',
                    style: TextStyle(
                      color: Colors.black45,
                    ),
                  ),
                  if (widget.items['status'] == '배송 수락')
                    Row(
                      children: [
                        Text('현재 주문 현황: ${widget.items['status']}'),
                        PullDownButton(
                          itemBuilder: (context) => [
                            PullDownMenuItem(
                              title: '상품 준비중',
                              onTap: () async {

                              //  await _updateOrderStatus('상품 준비중');
                              },
                            ),

                            PullDownMenuItem(
                              title: '복귀 준비 완료',
                              onTap: () async {
                               // await _updateOrderStatus('복귀 준비 완료');
                              },
                            ),
                          ],
                          buttonBuilder: (context, showMenu) => CupertinoButton(
                            onPressed: showMenu,
                            padding: EdgeInsets.zero,
                            child: const Icon(CupertinoIcons.ellipsis_circle),
                          ),
                        )
                      ],

                    ),



                ],
              ),

              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: IconButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue
                      ),
                      onPressed: () {
                        setState(() async{
                          // 주문 거절인 경우
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(
                                order: widget.items, // widget.items 전체를 전달            // 다른 필요한 데이터도 전달할 수 있음
                              ),
                            ),
                          );

                        });

                        // Get the store ID from the items map (assuming it's stored there)
                      }, icon: Icon(Icons.add),



                  )
              ),
            ],
          )),
    );
  }
}
