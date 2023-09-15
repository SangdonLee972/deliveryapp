// ListItemWidget.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronapp/Model/Order.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../Service/OrderService.dart';



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

    String amPm = time.hour < 12 ? '오전' : '오후';

    // 12시간제로 시간 조정
    int hour12Format = time.hour > 12 ? time.hour - 12 : time.hour;
    if (hour12Format == 0) hour12Format = 12; // 12시 처리

    return '주문일자 : ${time.year}년 ${time.month}월 ${time.day}일 $amPm ${hour12Format.toString().padLeft(2, '0')}시:${time.minute.toString().padLeft(2, '0')}분';
  }

  int _calculateAmount() {
    int amount = 0;

    if (widget.items['menus'] != null) {
      for (Map<String, dynamic> menu in widget.items['menus']) {
        amount += menu['price'] * menu['num'] as int;
      }
    }
    return amount;
  }

  bool isOrderSucess = false;
  // Future<void> _updateOrderStatus(String newStatus) async {
  //   // 주문 상태 업데이트
  //   widget.items['status'] = newStatus;
  //
  //   // 주문 정보 객체 업데이트
  //   OrderModel updatedOrderInfo = OrderModel(
  //     id: widget.items['id'] as String,
  //     isStore: widget.items['isStore'],
  //     FCMID:widget.items['FCMID'],
  //
  //     storeID: widget.items['storeID'],
  //     isManager: widget.items['isManager'],
  //     status: newStatus, // 변경된 상태로 업데이트
  //     menuInfo: widget.items['menuInfo'],
  //     menus: widget.items['menus'],
  //     userId: widget.items['userId'],
  //     userAddress: widget.items['userAddress'],
  //     storetype: widget.items['storetype'],
  //     time: DateTime.parse(widget.items['time']),
  //     // ... 다른 필드들은 필요에 따라
  //   );
  //
  //   // 백엔드에 주문 정보 업데이트
  //   String storeId = widget.items['storeID'];
  //   await orderService.updateOrderInHistory(storeId, updatedOrderInfo);
  //
  //
  //   // 위젯 상태 업데이트
  //   setState(() {});
  //
  // }




  OrderService orderService = OrderService();
  @override
  Widget build(BuildContext context) {


    return Card(
      elevation: 4.0, // <-- 카드의 그림자 깊이
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // <-- 카드의 모서리 둥글게 설정
      ),
      child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                      '주문 ${widget.items['storetype']} ${widget.number.toString()} 주문 가능여부: '),
                  if (widget.items['isStore'] == null)
                    ElevatedButton(
                        onPressed: () async {
                          setState(() {
                          });


                        },
                        child: Text('주문 수락')),
                  if (widget.items['isStore'] == null)
                    ElevatedButton(
                        onPressed: () {
                          setState(() async {

                          });

                          // Get the store ID from the items map (assuming it's stored there)
                        },
                        child: Text('주문 거절')),
                  if (widget.items['isManager'] == false &&
                      widget.items['isStore'] == true)
                    Row(
                      children: [
                        Icon(Icons.cancel_outlined,
                            color: Colors.red), // 체크 아이콘 추가
                        Text('작업자가 취소한 주문',
                            style: TextStyle(color: Colors.red)),
                      ],
                    )
                  else if (widget.items['isStore'] != null &&
                      !widget.items['isStore'])
                    Row(
                      children: [
                        Icon(Icons.cancel_outlined,
                            color: Colors.red), // 체크 아이콘 추가
                        Text('주문 취소', style: TextStyle(color: Colors.red)),
                      ],
                    )
                  else if (widget.items['isStore'] != null &&
                        widget.items['isStore'] &&
                        widget.items['isManager'] == null)
                      Text('관리자 승인 대기중...')
                    else if (widget.items['isManager'] == true &&
                          widget.items['isStore'])
                        Row(
                          children: [
                            Icon(Icons.check_circle,
                                color: Colors.blue), // 체크 아이콘 추가
                            Text('주문 접수', style: TextStyle(color: Colors.blue)),
                          ],
                        ),
                ],
              ),
              Text(formatISOToFullDateTime(widget.items['time'] as String)),
              Text('주문자 정보 : ${widget.items['userAddress']}'),
              if (widget.items['menus'] != null)
                for (Map<String, dynamic> menu in widget.items['menus'])
                  Text(
                    '- ${menu['Menuname']}  ${menu['num'].toString()}개 ',
                    style: TextStyle(color: Colors.black45, fontSize: 14),
                  ),
              Text(
                '  총합 가격: ${_calculateAmount()} 원',
                style: TextStyle(
                  color: Colors.black45,
                ),
              ),
              if (widget.items['isManager'] == true && widget.items['isStore'])
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
          )),
    );
  }
}
