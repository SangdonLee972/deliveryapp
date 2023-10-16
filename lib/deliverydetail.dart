import 'package:flutter/material.dart';
import 'package:dronapp/Model/Order.dart';

class DeliveryDetailPage extends StatefulWidget {
  final OrderModel order;

  DeliveryDetailPage({required this.order});

  @override
  _DeliveryDetailPageState createState() => _DeliveryDetailPageState();
}

class _DeliveryDetailPageState extends State<DeliveryDetailPage> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('배송 조회'),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.05),

            Center(
              child: Text(
                '현재 배송 사진',
                style: TextStyle(fontSize: screenWidth * 0.05),
              ),
            ),

            Center(child: Text('( 사진이 있을시 아래로 내려서 배송정보를 확인하실 수 있습니다. )',
            style: TextStyle(fontSize: screenWidth * 0.03
            ,color: Colors.black45),)),
            SizedBox(height: screenHeight * 0.03),

            // 이미지 표시 또는 "이미지 없음" 텍스트 표시
            widget.order.picture != null
                ? Center(
                    child: Image.network(
                      widget.order.picture,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        // 이미지 로딩 실패 시 표시할 오류 위젯 (텍스트 또는 다른 위젯)
                        return Text('(이미지를 불러올 수 없습니다)');
                      },
                    ),
                  )
                : Center(child: Text('(현재 업로드된 이미지가 없습니다)')),

            SizedBox(
              height: screenHeight * 0.05,
            ),
            drawLine(),
            // 주문 정보 표시

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Text(
                    '상품명 ',
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      widget.order.type.contains("편의점배송")
                          ? '${widget.order.items?[0].name ?? ''}'
                          : '${widget.order.obj.objName}',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            drawLine(),
            // 주문 정보 표시

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Text(
                    '받는분 ',
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Text(
                          '${widget.order.deliveryInfo.name}',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * 0.05,
                        ),
                        Text(
                          '${widget.order.deliveryInfo.phoneNumber}',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            drawLine(),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Text(
                    '현재 주문상태 ',
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      '${widget.order.status} ',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            drawLine(),

            // 다른 배송 정보 항목들을 여기에 추가
          ],
        ),
      )),
    );
  }

  Widget drawLine() {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Container(
          height: 1.0,
          width: screenWidth * double.maxFinite,
          color: Colors.black,
        ),
      ],
    );
  }
}
