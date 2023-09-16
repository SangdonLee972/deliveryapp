import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  final Map<String, dynamic> order; // 전체 주문 데이터를 저장하는 변수

  const DetailPage({Key? key, required this.order}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String status = ''; // 주문 상태를 저장할 변수

  @override
  void initState() {
    super.initState();
    // 초기 상태를 설정하려면 initState에서 설정할 수 있습니다.
    status = widget.order['status'];
  }


  Future<void> _updateStatus(String newStatus) async{
    String orderId = widget.order['id'];

// Firestore의 문서 참조 생성
    final DocumentReference orderRef = FirebaseFirestore.instance.collection('orders').doc(orderId);

// 데이터베이스 업데이트
    await orderRef.update({'status': newStatus});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('주문 상세 정보'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('주문 ID: ${widget.order['status']}'),
            // 상세 정보를 표시하는 다른 위젯들을 추가

            if (status == '확인중')
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () async {
                        _updateStatus('배송 수락');

                        Navigator.pop(context);

                      },
                      child: Text('배송 수락'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () {
                        _updateStatus('배송 불가');

                        Navigator.pop(context);
                      },
                      child: Text('배송 불가'),
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
