class Item {
  String name;
  String imgUrl;
  int price;
  int quantity;

  Item({
    required this.name,
    required this.price,
    required this.imgUrl,
    required this.quantity,
  });

  // Item 객체를 Map으로 변환하는 메서드
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imgUrl': imgUrl,
      'price': price,
      'quantity': quantity,
    };
  }

  // Map에서 Item 객체를 만드는 팩토리 메서드
  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      name: map['name'],
      imgUrl: map['imgUrl'],
      price: map['price'],
      quantity: map['quantity'],
    );
  }
}
