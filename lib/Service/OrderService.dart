import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronapp/Model/Order.dart';

class OrderService {
  final CollectionReference ordersCollection =
  FirebaseFirestore.instance.collection('orders');

  Future<void> createOrder(OrderModel order) async {
    await ordersCollection.add({
      'id': order.id,
      'status': order.status,
      'userId': order.userId,
      'picture': order.picture,
      'datetime': order.datetime,
      'price': order.price,
      'type': order.type,
      'obj': {
        'objUrl': order.obj.objUrl,
        'objName': order.obj.objName,
        'objPrice': order.obj.objPrice,
        'objCount': order.obj.objCount,
        'objSize': order.obj.objSize,
        'objMass': order.obj.objMass,
      },
      'deliveryInfo': {
        'name': order.deliveryInfo.name,
        'phoneNumber': order.deliveryInfo.phoneNumber,
        'address': order.deliveryInfo.address,
      },
    });
  }

// 다른 필요한 메서드 추가
}