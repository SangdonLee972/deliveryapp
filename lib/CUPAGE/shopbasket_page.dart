import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronapp/Model/DeliveryInformation.dart';
import 'package:dronapp/Model/OBJ.dart';
import 'package:dronapp/Model/Order.dart';
import 'package:dronapp/Model/User.dart';
import 'package:dronapp/Model/item.dart';
import 'package:dronapp/Service/Convenience.dart';
import 'package:dronapp/Service/OrderService.dart';
import 'package:dronapp/Service/UserService.dart';
import 'package:dronapp/alert_error.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class ShoppingBasketPage extends StatefulWidget {
  const ShoppingBasketPage({super.key});

  @override
  State<ShoppingBasketPage> createState() => _ShoppingBasketPageState();
}

class _ShoppingBasketPageState extends State<ShoppingBasketPage> {
  var f = NumberFormat('###,###,###,###');
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  Future<bool> order() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => const Scaffold(
              backgroundColor: Colors.black12,
              body: Center(
                  child: CircularProgressIndicator(
                color: Colors.black,
              )),
            ));
    String id = const Uuid().v4();
    OBJ obj = OBJ(
        objUrl: '',
        objName: '',
        objPrice: 0,
        objCount: 0,
        objSize: '',
        objMass: 0.0);
    DeliveryInformation deliveryInfo = DeliveryInformation(
        name: UserInstance.instance.name!,
        phoneNumber: UserInstance.instance.phoneNumber!,
        address:
            '${UserInstance.instance.add} ${UserInstance.instance.address}');
    OrderModel orderModel = OrderModel(
        id: id,
        status: '',
        userId: UserInstance.instance.id!,
        picture: '',
        datetime: DateTime.now(),
        price: 0,
        type: ['편의점배송'],
        obj: obj,
        deliveryInfo: deliveryInfo,
        items: UserInstance.instance.shoppingBasket);

    OrderService service = OrderService();
    try {
      await service.createOrder(orderModel);

      await UserService().addOrder(UserInstance.instance.id!, id);
      UserInstance.instance.orders.add(id);
      UserInstance.instance.shoppingBasket = [];
    } catch (e) {
      Navigator.pop(context);
      return false;
    }
    if (context.mounted) {
      Navigator.pop(context);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: const Text('장바구니'),
      ),
      body: UserInstance.instance.shoppingBasket.isEmpty
          ? Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_shopping_cart,
                      color: Colors.black38,
                      size: screenWidth * 0.3,
                    ),
                    SizedBox(
                      height: screenWidth * 0.04,
                    ),
                    Text(
                      '장바구니가 비워져있습니다.',
                      style: TextStyle(fontSize: screenWidth * 0.04),
                    )
                  ]),
            )
          : SafeArea(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: screenWidth * 0.05),
                  child: Text(
                    '    ${UserInstance.instance.name!}',
                    style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  color: Colors.black12,
                  width: screenWidth,
                  height: 1,
                ),
                //addressInput(screenWidth),
                Expanded(
                    child: ListView.builder(
                        itemCount: UserInstance.instance.shoppingBasket.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.05,
                                vertical: screenWidth * 0.034),
                            child: menuWidget(
                                UserInstance.instance.shoppingBasket[index]),
                          );
                        })),
                totalMoneyWidget(screenWidth),
                underButton(screenWidth)
              ],
            )),
    );
  }

  Widget addressInput(double screenWidth) {
    return Column(
      children: [
        Container(
          width: double.maxFinite,
          height: 1,
          color: Colors.black12,
        ),
        // SizedBox(
        //   height: screenWidth * 0.02,
        // ),
        // Row(
        //   children: [
        //     Text(
        //       '   주문자 정보   ',
        //       style: TextStyle(fontSize: screenWidth * 0.04),
        //     ),
        //     SizedBox(
        //         width: screenWidth * 0.8,
        //         height: screenWidth * 0.12,
        //         child: TextFormField(
        //           controller: controller,
        //           decoration: InputDecoration(
        //               hintText: '성명, 부서/직위, 연락처를 입력해주세요.',
        //               contentPadding: EdgeInsets.symmetric(
        //                 horizontal: screenWidth * 0.04,
        //               ),
        //               border: OutlineInputBorder(
        //                   borderRadius: BorderRadius.circular(30))),
        //         )),
        //   ],
        // ),
        SizedBox(
          height: screenWidth * 0.02,
        ),
        Container(
          width: double.maxFinite,
          height: 1,
          color: Colors.black12,
        ),
      ],
    );
  }

  Widget menuWidget(Item data) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.name,
              style: TextStyle(
                  fontSize: screenWidth * 0.046, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: screenWidth * 0.02,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '가격 : ${f.format(data.price)}원',
                      style: TextStyle(fontSize: screenWidth * 0.04),
                    ),
                    SizedBox(
                      height: screenWidth * 0.02,
                    ),
                    Text('${f.format(data.price * data.quantity)}원')
                  ],
                )
              ],
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextButton(
                onPressed: () {
                  UserInstance.instance.shoppingBasket.remove(data);
                  if (UserInstance.instance.shoppingBasket.isEmpty) {
                    UserInstance.instance.selectedStoreId = null;
                  }
                  setState(() {});
                },
                style: const ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: MaterialStatePropertyAll(EdgeInsets.zero),
                    overlayColor: MaterialStatePropertyAll(Colors.transparent),
                    minimumSize: MaterialStatePropertyAll(Size(0, 0))),
                child: Icon(
                  Icons.clear,
                  color: Colors.black,
                  size: screenWidth * 0.06,
                )),
            SizedBox(
              height: screenWidth * 0.2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: screenWidth * 0.015,
                      horizontal: screenWidth * 0.02),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12, width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    TextButton(
                        onPressed: () {
                          if (data.quantity > 1) {
                            setState(() {
                              data.quantity--;
                            });
                          }
                        },
                        style: const ButtonStyle(
                            overlayColor:
                                MaterialStatePropertyAll(Colors.transparent),
                            padding: MaterialStatePropertyAll(EdgeInsets.zero),
                            minimumSize: MaterialStatePropertyAll(Size(0, 0)),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                        child: Icon(
                          Icons.remove,
                          color: data.quantity == 1
                              ? Colors.black26
                              : Colors.black,
                        )),
                    SizedBox(
                      width: screenWidth * 0.03,
                    ),
                    Text('${data.quantity}개'),
                    SizedBox(
                      width: screenWidth * 0.03,
                    ),
                    TextButton(
                        onPressed: () {
                          if (data.quantity < 99) {
                            setState(() {
                              data.quantity++;
                            });
                          }
                        },
                        style: const ButtonStyle(
                            overlayColor:
                                MaterialStatePropertyAll(Colors.transparent),
                            padding: MaterialStatePropertyAll(EdgeInsets.zero),
                            minimumSize: MaterialStatePropertyAll(Size(0, 0)),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                        child: Icon(
                          Icons.add,
                          color: data.quantity == 99
                              ? Colors.black26
                              : Colors.black,
                        )),
                  ]),
                )
              ],
            ),
          ],
        )
      ],
    );
  }

  Widget totalMoneyWidget(double screnWidth) {
    int total = 0;
    for (int i = 0; i < UserInstance.instance.shoppingBasket.length; i++) {
      total += (UserInstance.instance.shoppingBasket[i].price) *
          (UserInstance.instance.shoppingBasket[i].quantity);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: double.maxFinite,
          height: 1,
          color: Colors.black12,
        ),
        SizedBox(
          height: screnWidth * 0.05,
        ),
        Text(
          '총 ${f.format(total)}원  ',
          style: TextStyle(
              color: Colors.purple,
              fontSize: screnWidth * 0.045,
              fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: screnWidth * 0.05,
        ),
        Container(
          width: double.maxFinite,
          height: 1,
          color: Colors.black12,
        ),
      ],
    );
  }

  Widget underButton(double screenWidth) {
    return Row(
      children: [
        Expanded(
            flex: 3,
            child: TextButton(
              onPressed: () {
                ConvenienceService service = ConvenienceService();
                service.addMenu(Item(
                    name: '포카칩',
                    price: 1000,
                    imgUrl:
                        'https://firebasestorage.googleapis.com/v0/b/dronquick-84db1.appspot.com/o/cu%2Fpokachip.jpg?alt=media&token=506d9a1f-f22d-45ed-bff3-f53494257dbf&_gl=1*1c4b57y*_ga*NzM1NDI0MjE0LjE2ODY1MjEzNDg.*_ga_CW55HF8NVT*MTY5Njg3NjIwNi4xNTMuMS4xNjk2ODc3MDMwLjU0LjAuMA..',
                    quantity: 1));
                print(UserInstance.instance.shoppingBasket[0].quantity);
                UserInstance.instance.shoppingBasket = [];
                setState(() {});
              },
              style: const ButtonStyle(
                  overlayColor: MaterialStatePropertyAll(Colors.transparent)),
              child: Container(
                height: screenWidth * 0.15,
                decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(15)),
                child: Center(
                    child: Text(
                  '취소',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.042,
                      fontWeight: FontWeight.w600),
                )),
              ),
            )),
        Expanded(
            flex: 5,
            child: TextButton(
              onPressed: () async {
                var isOrder = await order();
                if (isOrder) {
                  Navigator.pop(context);
                  OverlaySetting().showErrorAlert(context, '성공적으로 주문되었습니다.');
                } else {
                  OverlaySetting().showErrorAlert(
                      context, '주문 과정에서 오류가 발생했습니다.\n다시 시도해주세요');
                }
              },
              style: const ButtonStyle(
                  overlayColor: MaterialStatePropertyAll(Colors.transparent)),
              child: Container(
                height: screenWidth * 0.15,
                decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(15)),
                child: Center(
                    child: Text(
                  '주문하기',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.042,
                      fontWeight: FontWeight.w600),
                )),
              ),
            ))
      ],
    );
  }
}
