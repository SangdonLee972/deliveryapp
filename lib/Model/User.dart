import 'package:dronapp/Model/item.dart';

class UserInstance {
  String? name;
  String? fcmid;
  String? id;
  String? phoneNumber;
  List<String> orders;
  String? type;
  String? add;
  String? address;
  String? selectedStoreId;
  List<Item> shoppingBasket = [];

  UserInstance({
    this.name,
    this.fcmid,
    this.id,
    this.type,
    required this.orders,
    this.phoneNumber,
    this.add,
    this.address,
  });

  static UserInstance instance = UserInstance(orders: []);

  static UserInstance fromMap(Map<String, dynamic> user) {
    return UserInstance(
        name: user['name'],
        phoneNumber: user['phoneNumber'],
        fcmid: user['fcmid'],
        id: user['id'],
        type: user['type'],
        add: user['add'],
        address: user['address'],
        orders: List<String>.from(user['orders']));
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'add': add,
      'type': type,
      'orders': orders,
      'id': id,
      'phoneNumber': phoneNumber,
      'fcmid': fcmid
    };
  }
}
