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
      'datetime': datetime,
      'price': price,
      'type': type,
      'obj': obj.toMap(), // OBJ 객체를 Map으로 변환
      'deliveryInfo': deliveryInfo.toMap(), // DeliveryInformation 객체를 Map으로 변환
    };
  }

  static OrderModel fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'],
      status: map['status'],
      userId: map['userId'],
      picture: map['picture'],
      datetime: map['datetime'],
      price: map['price'],
      type: List<String>.from(map['type']),
      obj: OBJ.fromMap(map['obj']), // Map을 OBJ 객체로 변환
      deliveryInfo: DeliveryInformation.fromMap(map['deliveryInfo']), // Map을 DeliveryInformation 객체로 변환
    );
  }

}
