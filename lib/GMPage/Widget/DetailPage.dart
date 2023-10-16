import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronapp/FCM/FCMNotificationService.dart';
import 'package:dronapp/Model/User.dart';
import 'package:dronapp/Service/UserService.dart';
import 'package:dronapp/smsManager/smsManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'package:pull_down_button/pull_down_button.dart';

import '../../Model/Order.dart';
import '../../alert_error.dart';
import '../../deliverydetail.dart';

class DetailPage extends StatefulWidget {
  final Map<String, dynamic> order; // 전체 주문 데이터를 저장하는 변수

  const DetailPage({Key? key, required this.order}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String status = ''; // 주문 상태를 저장할 변수
  UserInstance? user;

  @override
  void initState()  {
    super.initState();
    // 초기 상태를 설정하려면 initState에서 설정할 수 있습니다.
    status = widget.order['status'];
    loadData();


  }
  Future<UserInstance?> loadData() async {
    UserService userService = UserService();
    return await userService.getUserFromID(widget.order['userId']);
  }


  Future<void> _updateStatus(String newStatus) async {
    String orderId = widget.order['id'];

// Firestore의 문서 참조 생성
    final DocumentReference orderRef =
    FirebaseFirestore.instance.collection('orders').doc(orderId);

// 데이터베이스 업데이트
    await orderRef.update({'status': newStatus});
  }

  Future<int> _uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';

      final File file = File(pickedFile.path); // Convert the path to a File

      final storageReference =
      FirebaseStorage.instance.ref().child('images/$fileName');
      await storageReference.putFile(file);
      final imageUrl = await storageReference.getDownloadURL();

      final firestore = FirebaseFirestore.instance;
      final orderDocument = firestore
          .collection('orders')
          .doc(widget.order['id']); // 'orders'는 컬렉션 이름, orderModel.id는 문서 식별자

      await orderDocument.update({
        'picture': imageUrl, // 'picture' 필드를 imageUrl 값으로 업데이트
        // 다른 필드들도 필요에 따라 업데이트
      });

      return 200;

      // The rest of your code for handling the upload and getting the URL remains the same
    } else {
      return 404;
      // Handle the case where the user didn't select an image
    }
  }

  String formatISOToFullDateTime(String isoString) {
    DateTime time = DateTime.parse(isoString);

    print("AA");
    String amPm = time.hour < 12 ? '오전' : '오후';

    // 12시간제로 시간 조정
    int hour12Format = time.hour > 12 ? time.hour - 12 : time.hour;
    if (hour12Format == 0) hour12Format = 12; // 12시 처리

    return '주문일자 : ${time.year}년 ${time.month}월 ${time.day}일 $amPm ${hour12Format.toString().padLeft(2, '0')}시:${time.minute.toString().padLeft(2, '0')}분';
  }



  @override
  Widget build(BuildContext context) {



    Map<String, dynamic> obj = widget.order['obj'];
    Map<String, dynamic> deliveryinfo = widget.order['deliveryInfo'];
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;


    return FutureBuilder<UserInstance?>(
      future: loadData(),
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(child: Text('오류 발생: ${snapshot.error}')),
            );
          }
          user = snapshot.data;
          print("유저 정보를 가지고 왔습니다. ${user?.name} ${user?.phoneNumber}");
          // Checking the order type
          if (widget.order['type'].contains("편의점배송")) {

            return   Scaffold(
              appBar: AppBar(
                title: Text('주문 상세 정보'),
                backgroundColor: Colors.blue,
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: screenWidth * 0.04,
                  ),

                  Text(
                    '배송신청서 정보',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                    ),
                  ),

                  SizedBox(
                    height: screenWidth * 0.05,
                  ),

                  Container(
                    width: screenWidth * 0.8, // 화면 너비의 80% 크기로 조절
                    decoration: BoxDecoration(
                      color: Colors.white, // 배경을 흰색으로 설정
                      borderRadius: BorderRadius.circular(10.0), // 테두리를 둥글게 파란색으로 설정
                      border: Border.all(color: Colors.blue, width: 3.0), // 파란색 테두리
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(30.0), // 내부 여백을 적절하게 조정
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text('배송물품 이름: ${widget.order['items'][0].name}'),
                          SizedBox(height: screenHeight * 0.02),
                          Text('배송물품 가격: ${widget.order['items'][0].price}'),
                          SizedBox(height: screenHeight * 0.02),
                          Text('배송물품 갯수: ${widget.order['items'][0].quantity}'),
                          SizedBox(height: screenHeight * 0.02),

                          Text('주문자 성명: ${user?.name}'),
                          SizedBox(height: screenHeight * 0.02),
                          Text('주문자 전화번호: ${deliveryinfo['phoneNumber']}'),
                          SizedBox(height: screenHeight * 0.02),
                          Text('주문자 주소: ${deliveryinfo['address']}'),
                          SizedBox(height: screenHeight * 0.02),


                          Text(formatISOToFullDateTime(widget.order['datetime'] as String)),
                          SizedBox(height: screenHeight * 0.02),

                          Text('배송 가격: 0원'),


                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: screenWidth * 0.06,
                  ),



                  if (widget.order['status'] == '배송 불가' ||
                      widget.order['status'] == '확인중')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('주문 현황: ${widget.order['status']}'),
                      ],
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('현재 주문 현황: ${widget.order['status']}'),
                        PullDownButton(
                          itemBuilder: (context) => [
                            PullDownMenuItem(
                              title: '배송중',
                              onTap: () async {
                                await _updateStatus('배송중');

                                UserService userService = UserService();
                                FCMNotificationService fcm = FCMNotificationService();
                                UserInstance? user = await userService.getUserFromID(widget.order['userId']);


                                String message = "상품 배송이 시작되었습니다.";
                                List<String> recipents = [deliveryinfo['phoneNumber']];

                                smsManager sms = smsManager();
                                sms.sendSMSManager(message, recipents);
                                
                                setState(()  {


                                  try {

                                    if (user != null && user.fcmid != null) {
                                      fcm.pushAnswer(user.fcmid!); // null이 아닌 경우에만 전달
                                    }
                                  } catch (e) {
                                    // 오류 처리
                                    print('오류 발생: $e');
                                  }



                                  widget.order['status'] = "배송중";
                                });
                                //  await _updateOrderStatus('상품 준비중');
                              },
                            ),
                            PullDownMenuItem(
                              title: '배송완료',
                              onTap: () async {
                                await _updateStatus('배송완료');
                                UserService userService = UserService();
                                FCMNotificationService fcm = FCMNotificationService();


                                UserInstance? user = await userService.getUserFromID(widget.order['userId']);
                                String message = "상품 배송이 완료되었습니다.";
                                List<String> recipents = [deliveryinfo['phoneNumber']];

                                smsManager sms = smsManager();
                                sms.sendSMSManager(message, recipents);

                                setState(() {


                                  try {

                                    if (user != null && user.fcmid != null) {
                                      fcm.pushAnswersuccess(user.fcmid!); // null이 아닌 경우에만 전달
                                    }
                                  } catch (e) {
                                    // 오류 처리
                                    print('오류 발생: $e');
                                  }





                                });
                                widget.order['status'] = "배송완료";

                                // await _updateOrderStatus('복귀 준비 완료');
                              },
                            ),
                            PullDownMenuItem(
                              title: '배송 입고처리',
                              onTap: () async {
                                await _updateStatus('결제완료');
                                UserService userService = UserService();
                                FCMNotificationService fcm = FCMNotificationService();


                                UserInstance? user = await userService.getUserFromID(widget.order['userId']);
                                final _firebaseMessaging = FirebaseMessaging.instance;
                                String? firebaseToken = await _firebaseMessaging.getToken();


                                setState(() {


                                  try {

                                    if (user != null && user.fcmid != null) {

                                      fcm.pushIpgo(user.fcmid!); // null이 아닌 경우에만 전달
                                      fcm.pushPay(firebaseToken!); // null이 아닌 경우에만 전달
                                    }
                                  } catch (e) {
                                    // 오류 처리
                                    print('오류 발생: $e');
                                  }
                                });
                                widget.order['status'] = "결제완료";

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

                  SizedBox(
                    height: screenWidth * 0.04,
                  ),

                  // 상세 정보를 표시하는 다른 위젯들을 추가

                  if (widget.order['status'] == '확인중')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: () {
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
                  else if (widget.order['status'] == '배송 불가')
                    Text('배송불가상품')
                  else
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
                              int resultcode = await _uploadImage(); // 이미지 업로드 함수 호출
                              Navigator.pop(context);

                              if (resultcode == 200) {
                                Fluttertoast.showToast(
                                  msg: "이미지 업로드에 성공하였습니다!", // 필수! 띄울 메세지
                                  toastLength: Toast.LENGTH_SHORT, // 얼마나 띄울지
                                  // Toast.LENGTH_SHORT 짧게
                                  // Toast.LENGTH_LONG  길게
                                  gravity: ToastGravity.BOTTOM, // 어디에 위치할지
                                  // ToastGravity.BOTTOM 화면아래
                                  // ToastGravity.CENTER 화면중앙
                                  // ToastGravity.TOP    화면상단
                                  backgroundColor: Colors.white, // toast 색상
                                  textColor: Colors.black, // toast 글씨 색상
                                  fontSize: 15.0, // toast 글씨 크기
                                );
                              } else if (resultcode == 404)
                                Fluttertoast.showToast(
                                  msg: "이미지 업로드에 실패하였습니다", // 필수! 띄울 메세지
                                  toastLength: Toast.LENGTH_SHORT, // 얼마나 띄울지
                                  // Toast.LENGTH_SHORT 짧게
                                  // Toast.LENGTH_LONG  길게
                                  gravity: ToastGravity.BOTTOM, // 어디에 위치할지
                                  // ToastGravity.BOTTOM 화면아래
                                  // ToastGravity.CENTER 화면중앙
                                  // ToastGravity.TOP    화면상단
                                  backgroundColor: Colors.white, // toast 색상
                                  textColor: Colors.black, // toast 글씨 색상
                                  fontSize: 15.0, // toast 글씨 크기
                                );
                            },
                            child: Text('배송조회 사진변경'),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: ()  async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DeliveryDetailPage(
                                    order: OrderModel.fromMap(widget.order), // widget.items 전체를 전달            // 다른 필요한 데이터도 전달할 수 있음
                                  ),
                                ),
                              );
                            },
                            child: Text('배송조회 페이지 방문'),
                          ),
                        ),
                      ],
                    )
                ],
              ),
            );
          } else {

            return Scaffold(
              appBar: AppBar(
                title: Text('주문 상세 정보'),
                backgroundColor: Colors.blue,
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: screenWidth * 0.04,
                  ),

                  Text(
                    '배송신청서 정보',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                    ),
                  ),

                  SizedBox(
                    height: screenWidth * 0.05,
                  ),

                  Container(
                    width: screenWidth * 0.8, // 화면 너비의 80% 크기로 조절
                    decoration: BoxDecoration(
                      color: Colors.white, // 배경을 흰색으로 설정
                      borderRadius: BorderRadius.circular(10.0), // 테두리를 둥글게 파란색으로 설정
                      border: Border.all(color: Colors.blue, width: 3.0), // 파란색 테두리
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(30.0), // 내부 여백을 적절하게 조정
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text('배송물품 URL: ${obj['objUrl'] == null || obj['objUrl'].trim() == '' ? '없음' : obj['objUrl']}'),
                          SizedBox(height: screenHeight * 0.02),
                          Text('배송물품 이름: ${obj['objName']}'),
                          SizedBox(height: screenHeight * 0.02),
                          Text('배송물품 가격: ${obj['objPrice']}'),
                          SizedBox(height: screenHeight * 0.02),
                          Text('배송물품 갯수: ${obj['objCount']}'),
                          SizedBox(height: screenHeight * 0.02),
                          Text('배송물품 사이즈: ${obj['objSize']}'),
                          SizedBox(height: screenHeight * 0.02),
                          Text('배송물품 무게: ${obj['objMass']}'),
                          SizedBox(height: screenHeight * 0.02),
                          Text('주문자 성명: ${user?.name}'),
                          SizedBox(height: screenHeight * 0.02),
                          Text('주문자 전화번호: ${user?.phoneNumber}'),
                          SizedBox(height: screenHeight * 0.02),
                          Text('주문자 주소: ${deliveryinfo['address']}'),
                          SizedBox(height: screenHeight * 0.02),


                          Text(formatISOToFullDateTime(widget.order['datetime'] as String)),
                          SizedBox(height: screenHeight * 0.02),

                          Text('배송 가격: 0원'),


                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: screenWidth * 0.06,
                  ),



                  if (widget.order['status'] == '배송 불가' ||
                      widget.order['status'] == '확인중')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('주문 현황: ${widget.order['status']}'),
                      ],
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('현재 주문 현황: ${widget.order['status']}'),
                        PullDownButton(
                          itemBuilder: (context) => [
                            PullDownMenuItem(
                              title: '배송중',
                              onTap: () async {
                                await _updateStatus('배송중');

                                UserService userService = UserService();
                                FCMNotificationService fcm = FCMNotificationService();
                                UserInstance? user = await userService.getUserFromID(widget.order['userId']);

                                String message = "상품 배송이 시작되었습니다.";
                                List<String> recipents = [widget.order['userId']];

                                smsManager sms = smsManager();
                                sms.sendSMSManager(message, recipents);

                                setState(()  {


                                  try {

                                    if (user != null && user.fcmid != null) {
                                      fcm.pushAnswer(user.fcmid!); // null이 아닌 경우에만 전달
                                    }
                                  } catch (e) {
                                    // 오류 처리
                                    print('오류 발생: $e');
                                  }



                                  widget.order['status'] = "배송중";
                                });
                                //  await _updateOrderStatus('상품 준비중');
                              },
                            ),
                            PullDownMenuItem(
                              title: '배송완료',
                              onTap: () async {
                                await _updateStatus('배송완료');
                                UserService userService = UserService();
                                FCMNotificationService fcm = FCMNotificationService();


                                UserInstance? user = await userService.getUserFromID(widget.order['userId']);
                                String message = "상품 배송이 완료되었습니다.";
                                List<String> recipents = [widget.order['userId']];

                                smsManager sms = smsManager();
                                sms.sendSMSManager(message, recipents);

                                setState(() {


                                  try {

                                    if (user != null && user.fcmid != null) {
                                      fcm.pushAnswersuccess(user.fcmid!); // null이 아닌 경우에만 전달
                                    }
                                  } catch (e) {
                                    // 오류 처리
                                    print('오류 발생: $e');
                                  }





                                });
                                widget.order['status'] = "배송완료";

                                // await _updateOrderStatus('복귀 준비 완료');
                              },
                            ),
                            PullDownMenuItem(
                              title: '배송 입고처리',
                              onTap: () async {
                                await _updateStatus('결제완료');
                                UserService userService = UserService();
                                FCMNotificationService fcm = FCMNotificationService();


                                UserInstance? user = await userService.getUserFromID(widget.order['userId']);
                                final _firebaseMessaging = FirebaseMessaging.instance;
                                String? firebaseToken = await _firebaseMessaging.getToken();

                                String message = "배송이 입고처리되었습니다.";
                                List<String> recipents = [widget.order['userId']];

                                smsManager sms = smsManager();
                                sms.sendSMSManager(message, recipents);


                                setState(() {


                                  try {

                                    if (user != null && user.fcmid != null) {

                                      fcm.pushIpgo(user.fcmid!); // null이 아닌 경우에만 전달
                                      fcm.pushPay(firebaseToken!); // null이 아닌 경우에만 전달
                                    }
                                  } catch (e) {
                                    // 오류 처리
                                    print('오류 발생: $e');
                                  }
                                });
                                widget.order['status'] = "결제완료";

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

                  SizedBox(
                    height: screenWidth * 0.04,
                  ),

                  // 상세 정보를 표시하는 다른 위젯들을 추가

                  if (widget.order['status'] == '확인중')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: () {
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
                  else if (widget.order['status'] == '배송 불가')
                    Text('배송불가상품')
                  else
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
                              int resultcode = await _uploadImage(); // 이미지 업로드 함수 호출
                              Navigator.pop(context);

                              if (resultcode == 200) {
                                Fluttertoast.showToast(
                                  msg: "이미지 업로드에 성공하였습니다!", // 필수! 띄울 메세지
                                  toastLength: Toast.LENGTH_SHORT, // 얼마나 띄울지
                                  // Toast.LENGTH_SHORT 짧게
                                  // Toast.LENGTH_LONG  길게
                                  gravity: ToastGravity.BOTTOM, // 어디에 위치할지
                                  // ToastGravity.BOTTOM 화면아래
                                  // ToastGravity.CENTER 화면중앙
                                  // ToastGravity.TOP    화면상단
                                  backgroundColor: Colors.white, // toast 색상
                                  textColor: Colors.black, // toast 글씨 색상
                                  fontSize: 15.0, // toast 글씨 크기
                                );
                              } else if (resultcode == 404)
                                Fluttertoast.showToast(
                                  msg: "이미지 업로드에 실패하였습니다", // 필수! 띄울 메세지
                                  toastLength: Toast.LENGTH_SHORT, // 얼마나 띄울지
                                  // Toast.LENGTH_SHORT 짧게
                                  // Toast.LENGTH_LONG  길게
                                  gravity: ToastGravity.BOTTOM, // 어디에 위치할지
                                  // ToastGravity.BOTTOM 화면아래
                                  // ToastGravity.CENTER 화면중앙
                                  // ToastGravity.TOP    화면상단
                                  backgroundColor: Colors.white, // toast 색상
                                  textColor: Colors.black, // toast 글씨 색상
                                  fontSize: 15.0, // toast 글씨 크기
                                );
                            },
                            child: Text('배송조회 사진변경'),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: ()  async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DeliveryDetailPage(
                                    order: OrderModel.fromMap(widget.order), // widget.items 전체를 전달            // 다른 필요한 데이터도 전달할 수 있음
                                  ),
                                ),
                              );
                            },
                            child: Text('배송조회 페이지 방문'),
                          ),
                        ),
                      ],
                    )
                ],
              ),
            );
          }
        }
        return SizedBox();
      },
    );

  }
}
