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
  bool isLoading = false;
  List<Item> items = [];

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
    getData();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('CU'),
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
                  Text(
                    '${item.name}',
                    style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.w600),
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
                  child: Image.network(
                    item.imgUrl,
                    fit: BoxFit.fitHeight,
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
