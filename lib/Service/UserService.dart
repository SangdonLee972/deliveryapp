import 'package:cloud_firestore/cloud_firestore.dart';

import '../Model/User.dart';

class UserService {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> createUser(UserInstance user) async {
    await usersCollection.add({
      'fcmid': user.fcmid,
      'id': user.id,
      'phoneNumber': user.phoneNumber,
      'address': user.address,
      'username': user.name,
      'orders': user.orders,
      'type': user.type,
    });
  }

  Future<void> addOrder(String userId, String orderId) async {
    await usersCollection.doc(userId).update({
      'orders': FieldValue.arrayUnion([orderId])
    });
  }

// 다른 필요한 메서드 추가
}
