import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronapp/Model/Order.dart';
import 'package:uuid/uuid.dart';

class OrderService {
  final CollectionReference ordersCollection =
      FirebaseFirestore.instance.collection('orders');

  Future<void> createOrder(OrderModel order) async {
    await ordersCollection.doc(order.id).set({
      'id': order.id,
      'status': '확인중',
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

  Future<void> addOrder(
      String status,
      String userId,
      String picture,
      DateTime datetime,
      double price,
      List<String> type,
      String objUrl,
      String objName,
      double objPrice,
      int objCount,
      String objSize,
      double objMass,
      String deliveryName,
      String deliveryPhoneNumber,
      String deliveryAddress) async {
    Uuid uid = Uuid();

    String id = uid.v4();

    final objInfo = {
      'objUrl': objUrl,
      'objName': objName,
      'objPrice': objPrice,
      'objCount': objCount,
      'objSize': objSize,
      'objMass': objMass,
    };

    final deliveryInfo = {
      'name': deliveryName,
      'phoneNumber': deliveryPhoneNumber,
      'address': deliveryAddress,
    };

    await ordersCollection.doc(id).set({
      'id': id,
      'status': status,
      'userId': userId,
      'picture': picture,
      'datetime': datetime,
      'price': price,
      'type': type,
      'obj': objInfo,
      'deliveryInfo': deliveryInfo,
    });
  }

  Future<OrderModel?> getOrderById(String orderId) async {
    try {
      DocumentSnapshot orderSnapshot =
          await ordersCollection.doc(orderId).get();
      if (orderSnapshot.exists) {
        return OrderModel.fromMap(orderSnapshot.data() as Map<String, dynamic>);
      } else {
        return null; // 주문이 존재하지 않는 경우 null 반환
      }
    } catch (e) {
      print('Error getting order by ID: $e');
      return null; // 에러 발생 시 null 반환
    }
  }

  Stream<List<OrderModel>> getAllOrdersStream() {
    return FirebaseFirestore.instance
        .collection('orders')
        .orderBy('datetime', descending: true)
        .snapshots()
        .map((querySnapshot) {
      if (querySnapshot.docs.isEmpty) {
        print('Firestore returned no documents');
      } else {
        print('Firestore returned documents: ${querySnapshot.docs.length}');
      }
      List<OrderModel> allOrders = [];

      for (var doc in querySnapshot.docs) {
        allOrders.add(OrderModel.fromMap(doc.data()));
      }
      return allOrders;
    });
  }

// 다른 필요한 메서드 추가
}
