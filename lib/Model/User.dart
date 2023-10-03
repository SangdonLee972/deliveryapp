class UserInstance {
  String? name;
  String? fcmid;
  String? id;
  String? phoneNumber;
  List<String> orders;
  String? type;
  String? address;

  UserInstance(
      {this.name,
      this.fcmid,
      this.id,
      this.type,
      required this.orders,
      this.phoneNumber,
      this.address});

  static UserInstance instance = UserInstance(orders: []);

  static UserInstance fromMap(Map<String, dynamic> user) {
    return UserInstance(
        name: user['name'],
        phoneNumber: user['phoneNumber'],
        fcmid: user['fcmid'],
        id: user['id'],
        type: user['type'],
        address: user['address'],
        orders: List<String>.from(user['orders']));
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'type': type,
      'orders': orders,
      'id': id,
      'phoneNumber': phoneNumber,
      'fcmid': fcmid
    };
  }
}
