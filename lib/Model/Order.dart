import 'package:cloud_firestore/cloud_firestore.dart';

import 'DeliveryInformation.dart';
import 'OBJ.dart';

class OrderModel {
  final String id;
  final String status;
  final String userId;
  final String picture;
  final DateTime datetime;
  final double price;
  final List<String> type;
  final OBJ obj;
  final DeliveryInformation deliveryInfo;

  OrderModel({
    required this.id,
    required this.status,
    required this.userId,
    required this.picture,
    required this.datetime,
    required this.price,
    required this.type,
    required this.obj,
    required this.deliveryInfo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status,
      'userId': userId,
      'picture': picture,
      'price': price,
      'type': type ?? [], // type이 null이면 빈 List 사용
      'datetime': datetime?.toIso8601String() ?? '', // datetime이 null이면 빈 문자열 사용

      'obj': obj?.toMap() ?? {}, // obj가 null이면 빈 Map 사용
      'deliveryInfo': deliveryInfo?.toMap() ?? {}, // deliveryInfo가 null이면 빈 Map 사용
    };
  }


  static OrderModel fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] ?? '',
      status: map['status'] ?? '',
      userId: map['userId'] ?? '',
      picture: map['picture'] ?? '',
      datetime: map['datetime'] is Timestamp
          ? (map['datetime'] as Timestamp).toDate()
          : DateTime.now(), // Timestamp 타입으로 변환
      price: map['price'] != null ? map['price'].toDouble() : 0.0,
      type: map['type'] != null ? List<String>.from(map['type']) : [],
      obj: map['obj'] != null ? OBJ.fromMap(map['obj']) : OBJ(
        objUrl: 'your_obj_url',
        objName: 'your_obj_name',
        objPrice: 10.0,
        objCount: 2,
        objSize: 'large',
        objMass: 0.5,
      ),
      deliveryInfo: map['deliveryInfo'] != null
          ? DeliveryInformation.fromMap(map['deliveryInfo'])
          : DeliveryInformation(
        name: 'John Doe',
        phoneNumber: '123-456-7890',
        address: '123 Main St',
      ),
    );
  }


}
