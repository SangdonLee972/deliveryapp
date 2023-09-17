import 'package:dronapp/Model/DeliveryInformation.dart';
import 'package:dronapp/Model/OBJ.dart';
import 'package:dronapp/Model/Order.dart';
import 'package:dronapp/Model/User.dart';
import 'package:dronapp/Service/OrderService.dart';
import 'package:dronapp/Service/UserService.dart';
import 'package:dronapp/alert_error.dart';
import 'package:flutter/material.dart';
import 'package:remedi_kopo/remedi_kopo.dart';
import 'package:uuid/uuid.dart';

class ApplicationPage extends StatefulWidget {
  const ApplicationPage({super.key});

  @override
  State<ApplicationPage> createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
  TextEditingController urlController = TextEditingController();
  TextEditingController productNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController widthController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController lengthController = TextEditingController();
  TextEditingController recipientController = TextEditingController();
  TextEditingController recipientPhoneController = TextEditingController();
  TextEditingController recipientAddressController = TextEditingController();
  List<FocusNode> focusnodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode()
  ];

  bool standardMore = false;
  bool isAgree = false;
  bool isMore = false;
  double? agreeHeight;
  bool isAgree2 = false;
  bool isMore2 = false;
  double? agreeHeight2;
  String? recipientAddress;
  String standard = '50cm 이하';
  Color leftColor = const Color.fromARGB(18, 0, 0, 0);

  List<String> standardList = [
    '50cm 이하',
    '60cm 이하',
    '70cm 이하',
    '80cm 이하',
    '100cm 이하',
    '120cm 이하',
    '120cm 이상'
  ];
  int quantity = 1;

  void dispose() {
    urlController.dispose();
    productNameController.dispose();
    priceController.dispose();
    weightController.dispose();
    widthController.dispose();
    heightController.dispose();
    lengthController.dispose();
    recipientController.dispose();
    recipientPhoneController.dispose();
    recipientAddressController.dispose();
    for (int i = 0; i < 10; i++) {
      focusnodes[i].dispose();
    }

    super.dispose();
  }

  bool isClick = false;

  bool checkCanApply() {
    OverlaySetting setting = OverlaySetting();
    if (urlController.text.isEmpty) {
      setting.showErrorAlert(context, 'url을 입력해주세요');
      return false;
    }
    if (productNameController.text.isEmpty) {
      setting.showErrorAlert(context, '상품명을 입력해주세요');
      return false;
    }
    if (priceController.text.isEmpty) {
      setting.showErrorAlert(context, '가격을 입력해주세요');
      return false;
    }
    if (int.tryParse(priceController.text) == null) {
      setting.showErrorAlert(context, '가격를 숫자로만 입력해주세요');
      return false;
    }
    if (weightController.text.isEmpty) {
      setting.showErrorAlert(context, '무게를 입력해주세요');
      return false;
    }
    if (int.tryParse(weightController.text) == null) {
      setting.showErrorAlert(context, '무게를 숫자로만 입력해주세요');
      return false;
    }
    if (lengthController.text.isEmpty) {
      setting.showErrorAlert(context, '세로길이를 입력해주세요');
      return false;
    }
    if (int.tryParse(lengthController.text) == null) {
      setting.showErrorAlert(context, '세로길이를 숫자로만 입력해주세요');
      return false;
    }
    if (widthController.text.isEmpty) {
      setting.showErrorAlert(context, '가로길이를 입력해주세요');
      return false;
    }
    if (int.tryParse(widthController.text) == null) {
      setting.showErrorAlert(context, '가로길이를 숫자로만 입력해주세요');
      return false;
    }
    if (heightController.text.isEmpty) {
      setting.showErrorAlert(context, '높이를 입력해주세요');
      return false;
    }
    if (int.tryParse(heightController.text) == null) {
      setting.showErrorAlert(context, '높이를 숫자로만 입력해주세요');
      return false;
    }
    if (recipientController.text.isEmpty) {
      setting.showErrorAlert(context, '수령자명을 입력해주세요');
      return false;
    }
    if (recipientPhoneController.text.isEmpty) {
      setting.showErrorAlert(context, '수령인 번호를 입력해주세요');
      return false;
    }
    if (recipientAddress == null) {
      setting.showErrorAlert(context, '주소를 입력해주세요');
      return false;
    }
    if (recipientAddressController.text.isEmpty) {
      setting.showErrorAlert(context, '상세주소를 입력해주세요');
      return false;
    }
    if (!isAgree2) {
      setting.showErrorAlert(context, '동의사항에 동의를 해주세요');
      return false;
    }

    return true;
  }

  Future<bool> apply() async {
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
    String id = Uuid().v4();
    OBJ obj = OBJ(
        objUrl: urlController.text,
        objName: productNameController.text,
        objPrice: double.parse(priceController.text),
        objCount: quantity,
        objSize: standard,
        objMass: double.parse(weightController.text));
    DeliveryInformation deliveryInfo = DeliveryInformation(
        name: recipientController.text,
        phoneNumber: recipientPhoneController.text,
        address: '$recipientAddress ${recipientAddressController.text}');
    OrderModel orderModel = OrderModel(
        id: id,
        status: '',
        userId: UserInstance.instance.id!,
        picture: '',
        datetime: DateTime.now(),
        price: 0,
        type: [],
        obj: obj,
        deliveryInfo: deliveryInfo);
    OrderService service = OrderService();
    try {
      await service.createOrder(orderModel);

      await UserService().addOrder(UserInstance.instance.id!, id);
      UserInstance.instance.orders.add(id);
    } catch (e) {
      Navigator.pop(context);
      return false;
    }
    Navigator.pop(context);
    return true;
  }

  Future<void> changeStandard(double screenWidth) async {
    await showDialog(
        context: context,
        builder: (context) {
          return Scaffold(
            backgroundColor: Color.fromARGB(33, 0, 0, 0),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  for (int i = 0; i < 7; i++)
                    TextButton(
                        onPressed: () {
                          setState(() {
                            standard = standardList[i];
                          });
                          Navigator.pop(context);
                        },
                        style: const ButtonStyle(
                            padding: MaterialStatePropertyAll(EdgeInsets.zero),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            overlayColor: MaterialStatePropertyAll(
                                Color.fromARGB(50, 0, 0, 0))),
                        child: Container(
                          width: screenWidth * 0.8,
                          height: screenWidth * 0.15,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                  top: i == 0
                                      ? Radius.circular(5)
                                      : Radius.circular(0),
                                  bottom: i == 6
                                      ? Radius.circular(5)
                                      : Radius.circular(0)),
                              color: Colors.white),
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.08),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                standardList[i],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: screenWidth * 0.04),
                              ),
                              if (standardList[i] == standard)
                                Icon(
                                  Icons.check,
                                  color: Colors.blue,
                                  size: screenWidth * 0.06,
                                )
                            ],
                          ),
                        ))
                ])),
          );
        });
  }

  void focusBoard(int i) {
    FocusScope.of(context).requestFocus(focusnodes[i]);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (isMore) {
      agreeHeight = null;
    } else {
      agreeHeight = screenWidth * 0.2;
    }
    if (isMore2) {
      agreeHeight2 = null;
    } else {
      agreeHeight2 = screenWidth * 0.2;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text('신청서 작성하기'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: screenWidth * 0.05,
            ),
            Text(
              '배송대행지',
              style: TextStyle(
                  fontWeight: FontWeight.w600, fontSize: screenWidth * 0.043),
            ),
            SizedBox(
              height: screenWidth * 0.02,
            ),
            Container(
              width: screenWidth * 0.88,
              height: screenWidth * 0.09,
              decoration: BoxDecoration(
                  border: Border.all(color: leftColor, width: 1),
                  borderRadius: BorderRadius.circular(5)),
              alignment: Alignment.centerLeft,
              child: Text(
                '   [(주)나르마] 제주드론배송센터',
                style:
                    TextStyle(fontSize: screenWidth * 0.04, color: Colors.grey),
              ),
            ),
            SizedBox(
              height: screenWidth * 0.05,
            ),
            Text(
              '배송상품 정보',
              style: TextStyle(
                  fontWeight: FontWeight.w600, fontSize: screenWidth * 0.043),
            ),
            SizedBox(
              height: screenWidth * 0.02,
            ),
            Container(
              width: screenWidth * 0.88,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26, width: 1),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(children: [
                Row(
                  children: [
                    Container(
                      width: screenWidth * 0.23,
                      height: screenWidth * 0.16,
                      decoration: BoxDecoration(
                          color: leftColor,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10))),
                      child: Center(
                          child: Text(
                        '쇼핑몰 URL',
                        style: TextStyle(
                            fontSize: screenWidth * 0.032,
                            fontWeight: FontWeight.w600),
                      )),
                    ),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.02,
                      ),
                      child: SizedBox(
                        height: screenWidth * 0.11,
                        child: TextFormField(
                          onFieldSubmitted: (v) => changeStandard(screenWidth),
                          controller: urlController,
                          focusNode: focusnodes[0],
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.02),
                              focusedBorder: const OutlineInputBorder(),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(30, 0, 0, 0)))),
                        ),
                      ),
                    ))
                  ],
                ),
                Container(
                  width: screenWidth * 0.88,
                  height: 1,
                  color: Colors.black26,
                ),
                Row(
                  children: [
                    Container(
                      width: screenWidth * 0.23,
                      height: screenWidth * 0.15,
                      color: leftColor,
                      child: Center(
                          child: Text(
                        '규격',
                        style: TextStyle(
                            fontSize: screenWidth * 0.032,
                            fontWeight: FontWeight.w600),
                      )),
                    ),
                    SizedBox(
                      width: screenWidth * 0.02,
                    ),
                    Container(
                      width: screenWidth * 0.6,
                      height: screenWidth * 0.11,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.black12)),
                      alignment: Alignment.centerLeft,
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '$standard',
                              style: TextStyle(fontSize: screenWidth * 0.035),
                            ),
                            TextButton(
                                onPressed: () async {
                                  await changeStandard(screenWidth);
                                  focusBoard(1);
                                },
                                style: ButtonStyle(
                                    overlayColor:
                                        const MaterialStatePropertyAll(
                                            Colors.transparent),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    minimumSize: const MaterialStatePropertyAll(
                                        Size(0, 0)),
                                    padding: MaterialStatePropertyAll(
                                        EdgeInsets.symmetric(
                                            horizontal: screenWidth * 0.01))),
                                child: Text(
                                  '변경',
                                  style: TextStyle(
                                      fontSize: screenWidth * 0.04,
                                      color: Colors.blue),
                                ))
                          ]),
                    ),
                  ],
                ),
                Container(
                  width: screenWidth * 0.88,
                  height: 1,
                  color: Colors.black26,
                ),
                Row(
                  children: [
                    Container(
                      width: screenWidth * 0.23,
                      height: screenWidth * 0.16,
                      color: leftColor,
                      child: Center(
                          child: Text(
                        '상품명',
                        style: TextStyle(
                            fontSize: screenWidth * 0.032,
                            fontWeight: FontWeight.w600),
                      )),
                    ),
                    Expanded(
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.02),
                            child: SizedBox(
                              height: screenWidth * 0.11,
                              child: TextFormField(
                                controller: productNameController,
                                onFieldSubmitted: (v) => focusBoard(2),
                                focusNode: focusnodes[1],
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.02),
                                    focusedBorder: OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Color.fromARGB(30, 0, 0, 0)))),
                              ),
                            )))
                  ],
                ),
                Container(
                  width: screenWidth * 0.88,
                  height: 1,
                  color: Colors.black26,
                ),
                Row(
                  children: [
                    Container(
                      width: screenWidth * 0.23,
                      height: screenWidth * 0.16,
                      color: leftColor,
                      child: Center(
                          child: Text(
                        '구매금액',
                        style: TextStyle(
                            fontSize: screenWidth * 0.032,
                            fontWeight: FontWeight.w600),
                      )),
                    ),
                    Expanded(
                        child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                      child: TextFormField(
                          controller: priceController,
                          focusNode: focusnodes[2],
                          keyboardType: TextInputType.number,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            suffixText: '원',
                            suffixStyle:
                                TextStyle(fontSize: screenWidth * 0.035),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.02),
                            focusedBorder: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(30, 0, 0, 0))),
                          )),
                    ))
                  ],
                ),
                Container(
                  width: screenWidth * 0.88,
                  height: 1,
                  color: Colors.black26,
                ),
                Row(
                  children: [
                    Container(
                      height: screenWidth * 0.15,
                      width: screenWidth * 0.23,
                      color: leftColor,
                      child: Center(
                          child: Text(
                        '수량',
                        style: TextStyle(
                            fontSize: screenWidth * 0.032,
                            fontWeight: FontWeight.w600),
                      )),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: screenWidth * 0.03,
                        ),
                        TextButton(
                            onPressed: () {
                              if (quantity > 1) {
                                setState(() {
                                  quantity--;
                                });
                              }
                            },
                            style: ButtonStyle(
                              minimumSize: MaterialStatePropertyAll(Size(0, 0)),
                              padding:
                                  MaterialStatePropertyAll(EdgeInsets.zero),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Container(
                              width: screenWidth * 0.1,
                              height: screenWidth * 0.1,
                              decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(5))),
                              child: Icon(
                                Icons.remove,
                                size: screenWidth * 0.05,
                                color: Colors.white,
                              ),
                            )),
                        Container(
                          width: screenWidth * 0.38,
                          height: screenWidth * 0.1,
                          color: leftColor,
                          child: Center(
                              child: Text(
                            quantity.toString(),
                            style: TextStyle(fontSize: screenWidth * 0.035),
                          )),
                        ),
                        TextButton(
                            onPressed: () {
                              if (quantity < 10) {
                                setState(() {
                                  quantity++;
                                });
                              }
                            },
                            style: const ButtonStyle(
                              minimumSize: MaterialStatePropertyAll(Size(0, 0)),
                              padding:
                                  MaterialStatePropertyAll(EdgeInsets.zero),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Container(
                              width: screenWidth * 0.1,
                              height: screenWidth * 0.1,
                              decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.horizontal(
                                      right: Radius.circular(5))),
                              child: Icon(
                                Icons.add,
                                size: screenWidth * 0.05,
                                color: Colors.white,
                              ),
                            ))
                      ],
                    )
                  ],
                ),
                Container(
                  width: screenWidth * 0.88,
                  height: 1,
                  color: Colors.black26,
                ),
                Row(
                  children: [
                    Container(
                      width: screenWidth * 0.23,
                      height: screenWidth * 0.16,
                      color: leftColor,
                      child: Center(
                          child: Text(
                        '무게',
                        style: TextStyle(
                            fontSize: screenWidth * 0.032,
                            fontWeight: FontWeight.w600),
                      )),
                    ),
                    Expanded(
                        child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                      child: TextFormField(
                        controller: weightController,
                        onFieldSubmitted: (v) => focusBoard(4),
                        focusNode: focusnodes[3],
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            suffixText: 'KG',
                            suffixStyle:
                                TextStyle(fontSize: screenWidth * 0.035),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.02),
                            focusedBorder: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(30, 0, 0, 0)))),
                      ),
                    ))
                  ],
                ),
                Container(
                  width: screenWidth * 0.88,
                  height: 1,
                  color: Colors.black26,
                ),
                Row(
                  children: [
                    Container(
                      width: screenWidth * 0.23,
                      height: screenWidth * 0.16,
                      color: leftColor,
                      child: Center(
                          child: Text(
                        '가로',
                        style: TextStyle(
                            fontSize: screenWidth * 0.032,
                            fontWeight: FontWeight.w600),
                      )),
                    ),
                    Expanded(
                        child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                      child: TextFormField(
                        controller: widthController,
                        onFieldSubmitted: (v) => focusBoard(5),
                        focusNode: focusnodes[4],
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            suffixText: 'cm',
                            suffixStyle:
                                TextStyle(fontSize: screenWidth * 0.037),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.02),
                            focusedBorder: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(30, 0, 0, 0)))),
                      ),
                    ))
                  ],
                ),
                Container(
                  width: screenWidth * 0.88,
                  height: 1,
                  color: Colors.black26,
                ),
                Row(
                  children: [
                    Container(
                      width: screenWidth * 0.23,
                      height: screenWidth * 0.16,
                      color: leftColor,
                      child: Center(
                          child: Text(
                        '세로',
                        style: TextStyle(
                            fontSize: screenWidth * 0.032,
                            fontWeight: FontWeight.w600),
                      )),
                    ),
                    Expanded(
                        child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                      child: TextFormField(
                        controller: lengthController,
                        onFieldSubmitted: (v) => focusBoard(6),
                        focusNode: focusnodes[5],
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            suffixText: 'cm',
                            suffixStyle:
                                TextStyle(fontSize: screenWidth * 0.037),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.02),
                            focusedBorder: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(30, 0, 0, 0)))),
                      ),
                    ))
                  ],
                ),
                Container(
                  width: screenWidth * 0.88,
                  height: 1,
                  color: Colors.black26,
                ),
                Row(
                  children: [
                    Container(
                      width: screenWidth * 0.23,
                      height: screenWidth * 0.16,
                      decoration: BoxDecoration(
                          color: leftColor,
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(10))),
                      child: Center(
                          child: Text(
                        '높이',
                        style: TextStyle(
                            fontSize: screenWidth * 0.032,
                            fontWeight: FontWeight.w600),
                      )),
                    ),
                    Expanded(
                        child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                      child: TextFormField(
                        controller: heightController,
                        focusNode: focusnodes[6],
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            suffixText: 'cm',
                            suffixStyle:
                                TextStyle(fontSize: screenWidth * 0.037),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.02),
                            focusedBorder: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(30, 0, 0, 0)))),
                      ),
                    ))
                  ],
                ),
              ]),
            ),
            SizedBox(
              height: screenWidth * 0.05,
            ),
            Text(
              '배송방법',
              style: TextStyle(
                  fontWeight: FontWeight.w600, fontSize: screenWidth * 0.043),
            ),
            SizedBox(
              height: screenWidth * 0.03,
            ),
            Container(
              width: screenWidth * 0.88,
              height: screenWidth * 0.12,
              decoration: BoxDecoration(
                  border: Border.all(color: leftColor, width: 1),
                  borderRadius: BorderRadius.circular(5)),
              alignment: Alignment.centerLeft,
              child: Text(
                '  ⦁ 드론 배송',
                style:
                    TextStyle(fontSize: screenWidth * 0.04, color: Colors.grey),
              ),
            ),
            SizedBox(
              height: screenWidth * 0.05,
            ),
            Container(
              width: screenWidth * 0.88,
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05, vertical: screenWidth * 0.04),
              decoration: BoxDecoration(
                  color: Color.fromARGB(66, 35, 35, 80),
                  borderRadius: BorderRadius.circular(5)),
              child: Row(children: [
                Text(
                  '예상 배송비 : ',
                  style: TextStyle(fontSize: screenWidth * 0.035),
                ),
                Text(
                  '0원',
                  style: TextStyle(
                      fontSize: screenWidth * 0.035, color: Colors.blue),
                )
              ]),
            ),
            SizedBox(
              height: screenWidth * 0.05,
            ),
            Text(
              '배송지 정보',
              style: TextStyle(
                  fontWeight: FontWeight.w600, fontSize: screenWidth * 0.043),
            ),
            SizedBox(
              height: screenWidth * 0.02,
            ),
            Container(
              width: screenWidth * 0.88,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26, width: 1),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(children: [
                Row(
                  children: [
                    Container(
                      width: screenWidth * 0.23,
                      height: screenWidth * 0.16,
                      decoration: BoxDecoration(
                          color: leftColor,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10))),
                      child: Center(
                          child: Text(
                        '수령자명',
                        style: TextStyle(
                            fontSize: screenWidth * 0.032,
                            fontWeight: FontWeight.w600),
                      )),
                    ),
                    Expanded(
                        child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                      child: TextFormField(
                        controller: recipientController,
                        focusNode: focusnodes[7],
                        onFieldSubmitted: (v) => focusBoard(8),
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.02),
                            focusedBorder: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(30, 0, 0, 0)))),
                      ),
                    ))
                  ],
                ),
                Container(
                  width: screenWidth * 0.88,
                  height: 1,
                  color: Colors.black26,
                ),
                Row(
                  children: [
                    Container(
                      width: screenWidth * 0.23,
                      height: screenWidth * 0.16,
                      color: leftColor,
                      child: Center(
                          child: Text(
                        '연락처',
                        style: TextStyle(
                            fontSize: screenWidth * 0.032,
                            fontWeight: FontWeight.w600),
                      )),
                    ),
                    Expanded(
                        child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                      child: TextFormField(
                        controller: recipientPhoneController,
                        focusNode: focusnodes[8],
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.02),
                            focusedBorder: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(30, 0, 0, 0)))),
                      ),
                    ))
                  ],
                ),
                Container(
                  width: screenWidth * 0.88,
                  height: 1,
                  color: Colors.black26,
                ),
                Row(
                  children: [
                    Container(
                      width: screenWidth * 0.23,
                      height: screenWidth * 0.32,
                      decoration: BoxDecoration(
                          color: leftColor,
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(10))),
                      child: Center(
                          child: Text(
                        '주소',
                        style: TextStyle(
                            fontSize: screenWidth * 0.032,
                            fontWeight: FontWeight.w600),
                      )),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: screenWidth * 0.12,
                              width: screenWidth * 0.44,
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.01),
                              decoration: BoxDecoration(
                                  color: recipientAddress == null
                                      ? Colors.transparent
                                      : Color.fromARGB(30, 0, 0, 0),
                                  border: Border.all(
                                      color: Color.fromARGB(30, 0, 0, 0),
                                      width: 1),
                                  borderRadius: BorderRadius.circular(5)),
                              alignment: Alignment.center,
                              child: Text(
                                recipientAddress ?? '',
                                maxLines: 2,
                                style: TextStyle(
                                    color: Colors.black45,
                                    overflow: TextOverflow.visible),
                              ),
                            ),
                            SizedBox(
                              width: screenWidth * 0.01,
                            ),
                            TextButton(
                                onPressed: () async {
                                  KopoModel? model = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RemediKopo()));
                                  setState(() {
                                    if (model != null) {
                                      recipientAddress =
                                          '${model.address!} ${model.buildingName}';
                                    }
                                  });
                                },
                                style: const ButtonStyle(
                                    minimumSize:
                                        MaterialStatePropertyAll(Size(0, 0)),
                                    padding: MaterialStatePropertyAll(
                                        EdgeInsets.zero),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap),
                                child: Container(
                                  width: screenWidth * 0.16,
                                  height: screenWidth * 0.12,
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 88, 166, 230),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Center(
                                      child: Text(
                                    '검색',
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.038,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  )),
                                ))
                          ],
                        ),
                        SizedBox(
                          height: screenWidth * 0.02,
                        ),
                        SizedBox(
                            height: screenWidth * 0.12,
                            width: screenWidth * 0.64,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.02),
                              child: TextFormField(
                                controller: recipientAddressController,
                                focusNode: focusnodes[9],
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                    hintText: '상세주소',
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.02),
                                    focusedBorder: OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Color.fromARGB(30, 0, 0, 0)))),
                              ),
                            )),
                      ],
                    )
                  ],
                ),
              ]),
            ),
            SizedBox(
              height: screenWidth * 0.06,
            ),
            Text(
              '동의사항',
              style: TextStyle(
                  fontWeight: FontWeight.w600, fontSize: screenWidth * 0.043),
            ),
            SizedBox(
              height: screenWidth * 0.02,
            ),
            // Container(
            //   width: screenWidth * 0.88,
            //   height: screenWidth * 0.13,
            //   padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
            //   decoration: BoxDecoration(
            //       color: leftColor,
            //       borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
            //       border: Border.all(color: Colors.black26, width: 1)),
            //   child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Row(
            //           children: [
            //             TextButton(
            //                 onPressed: () {
            //                   setState(() {
            //                     isAgree = !isAgree;
            //                   });
            //                 },
            //                 style: const ButtonStyle(
            //                     overlayColor: MaterialStatePropertyAll(
            //                         Colors.transparent),
            //                     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //                     minimumSize:
            //                         MaterialStatePropertyAll(Size(0, 0)),
            //                     padding:
            //                         MaterialStatePropertyAll(EdgeInsets.zero)),
            //                 child: Icon(
            //                   isAgree
            //                       ? Icons.check_box
            //                       : Icons.check_box_outline_blank,
            //                   color: isAgree
            //                       ? const Color.fromARGB(255, 88, 166, 230)
            //                       : Colors.black26,
            //                   size: screenWidth * 0.06,
            //                 )),
            //             Text(
            //               '  [필수] ',
            //               style: TextStyle(
            //                   fontWeight: FontWeight.w600,
            //                   color: Colors.red,
            //                   fontSize: screenWidth * 0.035),
            //             ),
            //             SizedBox(
            //               width: screenWidth * 0.46,
            //               child: Text(
            //                 '배송대행 서비스 신청 유의사항',
            //                 style: TextStyle(fontSize: screenWidth * 0.035),
            //               ),
            //             )
            //           ],
            //         ),
            //         TextButton(
            //             onPressed: () {
            //               setState(() {
            //                 isMore = !isMore;
            //               });
            //             },
            //             style: const ButtonStyle(
            //                 overlayColor:
            //                     MaterialStatePropertyAll(Colors.transparent),
            //                 padding: MaterialStatePropertyAll(EdgeInsets.zero),
            //                 tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //                 minimumSize: MaterialStatePropertyAll(Size(0, 0))),
            //             child: Row(
            //               children: [
            //                 Icon(
            //                   isMore ? Icons.expand_less : Icons.expand_more,
            //                   color: Colors.blue,
            //                   size: screenWidth * 0.06,
            //                 ),
            //                 Text(
            //                   '더보기',
            //                   style: TextStyle(
            //                       color: Colors.blue,
            //                       fontSize: screenWidth * 0.035),
            //                 )
            //               ],
            //             ))
            //       ]),
            // ),
            // Container(
            //   width: screenWidth * 0.88,
            //   height: agreeHeight,
            //   decoration: BoxDecoration(
            //       borderRadius:
            //           const BorderRadius.vertical(bottom: Radius.circular(10)),
            //       border: Border.all(color: Colors.black26, width: 1)),
            //   child: SingleChildScrollView(
            //     padding: EdgeInsets.symmetric(
            //         vertical: screenWidth * 0.04,
            //         horizontal: screenWidth * 0.04),
            //     child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text('1123123'),
            //           Text('1123123'),
            //           Text('1123123'),
            //           Text('1123123'),
            //           Text('1123123')
            //         ]),
            //   ),
            // ),
            Container(
              width: screenWidth * 0.88,
              height: screenWidth * 0.13,
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
              decoration: BoxDecoration(
                  color: leftColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
                  border: Border.all(color: Colors.black26, width: 1)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        TextButton(
                            onPressed: () {
                              setState(() {
                                isAgree2 = !isAgree2;
                              });
                            },
                            style: const ButtonStyle(
                                overlayColor: MaterialStatePropertyAll(
                                    Colors.transparent),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                minimumSize:
                                    MaterialStatePropertyAll(Size(0, 0)),
                                padding:
                                    MaterialStatePropertyAll(EdgeInsets.zero)),
                            child: Icon(
                              isAgree2
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: isAgree2
                                  ? const Color.fromARGB(255, 88, 166, 230)
                                  : Colors.black26,
                              size: screenWidth * 0.06,
                            )),
                        Text(
                          '  [필수] ',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                              fontSize: screenWidth * 0.035),
                        ),
                        SizedBox(
                          width: screenWidth * 0.46,
                          child: Text(
                            '배송대행 서비스 신청 유의사항',
                            style: TextStyle(fontSize: screenWidth * 0.035),
                          ),
                        )
                      ],
                    ),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            isMore2 = !isMore2;
                          });
                        },
                        style: const ButtonStyle(
                            overlayColor:
                                MaterialStatePropertyAll(Colors.transparent),
                            padding: MaterialStatePropertyAll(EdgeInsets.zero),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            minimumSize: MaterialStatePropertyAll(Size(0, 0))),
                        child: Row(
                          children: [
                            Icon(
                              isMore2 ? Icons.expand_less : Icons.expand_more,
                              color: Colors.blue,
                              size: screenWidth * 0.06,
                            ),
                            Text(
                              '더보기',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: screenWidth * 0.035),
                            )
                          ],
                        ))
                  ]),
            ),
            Container(
              width: screenWidth * 0.88,
              height: agreeHeight2,
              decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(10)),
                  border: Border.all(color: Colors.black26, width: 1)),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    vertical: screenWidth * 0.04,
                    horizontal: screenWidth * 0.04),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                          '- 구매상품 상세페이지 내 실제 크기 확인하신 후 신청서 작성 시 해당 규격을 선택해주시기 바랍니다.'),
                      Text('- 실제 상품과 다른 상품규격 선택 시 배송비가 변경될 수 있습니다.'),
                      Text(
                          '- 드론 배송 가능한 규격 및 무게 초과 시 신청 건이 취소될 수 있으며 관련하여 운송사 및 운영기관에서는 일체 반송서비스를 제공하지 않습니다.'),
                      Text('- 신청서 수정 및 취소는 주문한 상품이 제주드론배송센터로 배송출발전인 경우 가능합니다.'),
                      Text('- 제주드론배송센터로의 배송진행상태는 상품 판매자에게 직접 문의해주시기 바랍니다.'),
                      Text(
                          '- 고객님께서 주문하신 상품이 실제로 제주드론배송센터로 배송중인 상태이거나, 입고된 경우에는 신청을 취소 할 수 없습니다.'),
                      Text(
                          '- 상품이 제주드론배송센터 입고 후 반품을 원할 경우 신청자 본인이 직접 택배사를 통해 접수처리 하여야 하며, 센터 내 보관기간은 최대 7일 입니다. 7일 이후에도 상품회수가 되지 않을 경우 상품파기비용이 실비로 청구됩니다. 파기비용은 상품의 규격에 따라 정해집니다.'),
                      Text('- 제주드론배송센터에서는 제품의 착불 배송비를 지불할 수 없습니다.'),
                      Text('- 냉동‧냉장 식품일 경우, 운송사와 반드시 협의 후 신청하시기 바랍니다.'),
                      Text(
                          '- 원제조사-제주드론배송센터 간 배송 중 파손이 발생할 가능성이 있음을 유의하시고, 물품 최초 발송시 최대한 꼼꼼히 포장해주시기 바랍니다.'),
                      Text('- 배송일 및 배송시간 지정은 불가합니다. (운송사와 직접 조율 필요)'),
                      Text('- 운송사와 운영기관에서는 운송중 파손에 관하여 일체 책임지지 않습니다.')
                    ]),
              ),
            ),
            SizedBox(
              height: screenWidth * 0.04,
            ),
            TextButton(
              onPressed: () async {
                if (!isClick) {
                  if (checkCanApply()) {
                    isClick = true;
                    var isApply = await apply();
                    if (isApply) {
                      Navigator.pop(context);
                      OverlaySetting().showErrorAlert(context, '성공적으로 신청했습니다');
                    } else {
                      OverlaySetting()
                          .showErrorAlert(context, '오류가 발생했습니다\n다시 시도해주세요');
                    }
                  }
                  isClick = false;
                }
              },
              style: ButtonStyle(
                  overlayColor: MaterialStatePropertyAll(Colors.transparent)),
              child: Container(
                  width: screenWidth * 0.88,
                  height: screenWidth * 0.15,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                      child: Text(
                    '신청하기',
                    style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ))),
            )
          ]),
        ),
      ),
    );
  }
}
