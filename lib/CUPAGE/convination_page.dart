import 'package:dronapp/CUPAGE/menu_page.dart';
import 'package:dronapp/CUPAGE/shopbasket_page.dart';
import 'package:dronapp/Model/item.dart';
import 'package:dronapp/Service/Convenience.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConvinationPage extends StatefulWidget {
  const ConvinationPage({super.key});

  @override
  State<ConvinationPage> createState() => _ConvinationPageState();
}

class _ConvinationPageState extends State<ConvinationPage> {
  var f = NumberFormat('###,###,###,###');
  bool isLoading = true;
  List<Item> items = [
    Item(
        name: 'CJ 햇반200G(3입)',
        price: 5700,
        imgUrl: 'asset/image/rice.png',
        quantity: 1),
    Item(
        name: '오모리김치찌개라면(봉지)4입',
        price: 5800,
        imgUrl: 'asset/image/omori.png',
        quantity: 1),
    Item(
        name: '보솜이물티슈60매(캡형)',
        price: 5700,
        imgUrl: 'asset/image/tissue.png',
        quantity: 1),
    Item(
        name: '페이스6일회용면도기3입',
        price: 6900,
        imgUrl: 'asset/image/Shaver.png',
        quantity: 1),
    Item(
        name: '메디안커플치약칫솔세트',
        price: 5900,
        imgUrl: 'asset/image/toothbrush.png',
        quantity: 1)
  ];

  void getData() async {
    ConvenienceService service = ConvenienceService();
    items = await service.getMenus();
    setState(() {
      isLoading = true;
    });
  }

  @override
  void initState() {
    super.initState();
    //getData();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('GS25'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: <Widget>[shopBasketButton()],
      ),
      body: isLoading
          ? SingleChildScrollView(
              child: Column(children: [
                SizedBox(
                  width: screenWidth,
                ),
                for (int i = 0; i < items.length; i++)
                  item(screenWidth, items[i])
              ]),
            )
          : const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
    );
  }

  Widget item(double screenWidth, Item item) {
    return TextButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SelectMenuPage(
                      id: '12', imgUrl: item.imgUrl, menu: item)));
        },
        style: const ButtonStyle(
            padding:
                MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 10)),
            overlayColor: MaterialStatePropertyAll(Colors.transparent),
            foregroundColor: MaterialStatePropertyAll(Colors.black)),
        child: Container(
          width: screenWidth * 0.85,
          padding: EdgeInsets.symmetric(
              vertical: screenWidth * 0.05, horizontal: screenWidth * 0.055),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black12, width: 1),
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                    color: Color.fromARGB(31, 97, 97, 97),
                    offset: Offset(3, 3),
                    spreadRadius: 3,
                    blurRadius: 3)
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: screenWidth * 0.5,
                    child: Text(
                      '${item.name}',
                      style: TextStyle(
                          fontSize: screenWidth * 0.043,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: screenWidth * 0.02,
                  ),
                  Text(
                    '${f.format(item.price)}원',
                    style: TextStyle(fontSize: screenWidth * 0.04),
                  )
                ],
              ),
              ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    item.imgUrl,
                    fit: BoxFit.fitWidth,
                    width: screenWidth * 0.2,
                    height: screenWidth * 0.2,
                  )),
            ],
          ),
        ));
  }

  Widget shopBasketButton() {
    return TextButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ShoppingBasketPage()));
        },
        style: const ButtonStyle(
            overlayColor: MaterialStatePropertyAll(Colors.transparent),
            padding: MaterialStatePropertyAll(EdgeInsets.only(right: 10)),
            minimumSize: MaterialStatePropertyAll(Size(0, 0)),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap),
        child: const Icon(
          Icons.shopping_cart,
          color: Colors.black,
        ));
  }
}
