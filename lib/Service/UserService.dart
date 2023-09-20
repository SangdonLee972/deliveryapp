import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future<UserInstance?> getUserFromID(String userID) async {
    try {
      DocumentSnapshot orderSnapshot =
      await usersCollection.doc(userID).get();
      if (orderSnapshot.exists) {
        return UserInstance.fromMap(
            orderSnapshot.data() as Map<String, dynamic>);
      } else {
        return null; // 주문이 존재하지 않는 경우 null 반환
      }
    } catch (e) {
      print('Error getting order by ID: $e');
      return null; // 에러 발생 시 null 반환
    }
  }


// 다른 필요한 메서드 추가
}
