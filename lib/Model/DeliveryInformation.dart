class DeliveryInformation {
  final String name;
  final String phoneNumber;
  final String address;

  DeliveryInformation({
    required this.name,
    required this.phoneNumber,
    required this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'address': address,
    };
  }

  static DeliveryInformation fromMap(Map<String, dynamic> map) {
    return DeliveryInformation(
      name: map['name'],
      phoneNumber: map['phoneNumber'],
      address: map['address'],
    );
  }
}
