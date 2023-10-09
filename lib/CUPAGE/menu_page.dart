import 'package:dronapp/Model/User.dart';
import 'package:dronapp/Model/item.dart';
import 'package:dronapp/alert_error.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelectMenuPage extends StatefulWidget {
  final String id;
  final String imgUrl;
  final Item menu;
  const SelectMenuPage(
      {required this.id, required this.imgUrl, required this.menu, super.key});

  @override
  State<SelectMenuPage> createState() => _SelectMenuPageState();
}

class _SelectMenuPageState extends State<SelectMenuPage> {
  var f = NumberFormat('###,###,###,###');
  int quantity = 1;

  void addShopBasket() async {
    if (UserInstance.instance.selectedStoreId != null) {
      if (UserInstance.instance.selectedStoreId != widget.id) {
        if (await changeStoreState()) {
          UserInstance.instance.shoppingBasket = [];
        } else {
          return;
        }
      }
    }
    UserInstance.instance.selectedStoreId = widget.id;
    for (var a in UserInstance.instance.shoppingBasket) {
      if (a.name == widget.menu.name) {
        a.quantity += quantity;
        Navigator.pop(context);
        OverlaySetting setting = OverlaySetting();
        setting.showErrorAlert(context, '장바구니에 담았습니다!');
        return;
      }
    }

    Item addmenu = widget.menu;
    addmenu.quantity = quantity;
    UserInstance.instance.shoppingBasket.add(addmenu);
    Navigator.pop(context);
    OverlaySetting setting = OverlaySetting();
    setting.showErrorAlert(context, '장바구니에 담았습니다!');
  }

  Future<bool> changeStoreState() async {
    bool isOut = false;
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: Column(
              children: const <Widget>[
                Text(
                  '장바구니에는 같은 가게의 메뉴만 담을 수 있습니다',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Center(
                  child: Text(
                    '선택하신 메뉴를 장바구니에 담을 경우 이전에 담은 메뉴가 삭제됩니다.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        height: 1.4, color: Colors.grey, fontSize: 14.5),
                  ),
                )
              ],
            ),
            actions: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: const ButtonStyle(
                          foregroundColor:
                              MaterialStatePropertyAll(Colors.black)),
                      child: const Text(
                        "취소",
                        style: TextStyle(),
                      ),
                      onPressed: () {
                        isOut = false;
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      style: const ButtonStyle(
                          foregroundColor:
                              MaterialStatePropertyAll(Colors.black)),
                      child: const Text(
                        "담기",
                        style: TextStyle(),
                      ),
                      onPressed: () {
                        isOut = true;
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              )
            ],
          );
        });

    return isOut;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            title: Text(widget.menu.name)),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              //if (widget.menu.MenuImage)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    Container(
                      color: Colors.black12,
                      width: screenWidth * 0.4,
                      height: screenWidth * 0.4,
                    ),
                    Image.network(
                      widget.imgUrl,
                      width: screenWidth * 0.4,
                      height: screenWidth * 0.4,
                      fit: BoxFit.fill,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.menu.name,
                        style: TextStyle(
                            fontSize: screenWidth * 0.075,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: screenWidth * 0.03,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '가격',
                            style: TextStyle(fontSize: screenWidth * 0.05),
                          ),
                          Text(
                            '${f.format(widget.menu.price)}원',
                            style: TextStyle(fontSize: screenWidth * 0.045),
                          )
                        ],
                      ),
                      SizedBox(
                        height: screenWidth * 0.05,
                      ),
                    ],
                  )),
              Container(
                color: const Color.fromARGB(15, 0, 0, 0),
                width: screenWidth,
                height: screenWidth * 0.03,
              ),
              SizedBox(
                height: screenWidth * 0.05,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '수량',
                      style: TextStyle(fontSize: screenWidth * 0.05),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: screenWidth * 0.03,
                          horizontal: screenWidth * 0.03),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(children: [
                        TextButton(
                            onPressed: () {
                              if (quantity > 1) {
                                setState(() {
                                  quantity--;
                                });
                              }
                            },
                            style: const ButtonStyle(
                                overlayColor: MaterialStatePropertyAll(
                                    Colors.transparent),
                                padding:
                                    MaterialStatePropertyAll(EdgeInsets.zero),
                                minimumSize:
                                    MaterialStatePropertyAll(Size(0, 0)),
                                tapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap),
                            child: Icon(
                              Icons.remove,
                              color:
                                  quantity == 1 ? Colors.black26 : Colors.black,
                            )),
                        SizedBox(
                          width: screenWidth * 0.03,
                        ),
                        Text('$quantity개'),
                        SizedBox(
                          width: screenWidth * 0.03,
                        ),
                        TextButton(
                            onPressed: () {
                              if (quantity < 99) {
                                setState(() {
                                  quantity++;
                                });
                              }
                            },
                            style: const ButtonStyle(
                                overlayColor: MaterialStatePropertyAll(
                                    Colors.transparent),
                                padding:
                                    MaterialStatePropertyAll(EdgeInsets.zero),
                                minimumSize:
                                    MaterialStatePropertyAll(Size(0, 0)),
                                tapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap),
                            child: Icon(
                              Icons.add,
                              color: quantity == 99
                                  ? Colors.black26
                                  : Colors.black,
                            )),
                      ]),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: screenWidth * 0.05,
              ),
              Expanded(
                  child: Container(
                color: const Color.fromARGB(15, 0, 0, 0),
                width: screenWidth,
              )),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  child: Container(
                    padding: EdgeInsets.only(top: screenWidth * 0.05),
                    color: Colors.white,
                    child: Container(
                      height: screenWidth * 0.15,
                      decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.circular(15)),
                      child: TextButton(
                          onPressed: () {
                            addShopBasket();
                          },
                          style: const ButtonStyle(
                              minimumSize: MaterialStatePropertyAll(Size(0, 0)),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              padding:
                                  MaterialStatePropertyAll(EdgeInsets.zero)),
                          child: Center(
                            child: Text(
                              '${f.format(widget.menu.price * quantity)}원 담기',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.04,
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                    ),
                  ))
            ],
          ),
        ));
  }
}
