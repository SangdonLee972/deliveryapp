import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:uuid/uuid.dart';

import '../Model/User.dart';

class EmailLogin {
  bool configured = false;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<bool> singup(
      {required String email,
      required String password,
      required String name,
      required String address,
      required String fcmid,
      required String phoneNumber}) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final String uid = userCredential.user!.uid;
      await userCollection.doc(uid).set({
        'name': name,
        'id': uid,
        'type': 'user',
        'orders': [],
        'address': address,
        'fcmid': fcmid,
        'phoneNumber': phoneNumber
      });
      UserInstance.instance.name = name;
      UserInstance.instance.phoneNumber = phoneNumber;
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<int> login({required String email, required String password}) async {
    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      var doc = await userCollection
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (doc.exists) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'fcmid': fcmToken,
        });

        UserInstance.instance =
            UserInstance.fromMap(doc.data() as Map<String, dynamic>);
        return 1;
      } else {
        print("뷁");
        return -1;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print("유저없음");
        return -2;
      } else if (e.code == 'wrong-password') {
        print("비번틀림");
        return -1;
      } else if (e.code == 'invalid-email') {
        print("이메일틀림");
        return -3;
      }
      return -2;
    }
  }

  Future<bool> getData() async {
    try {
      var doc = await userCollection
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (doc.exists) {
        UserInstance.instance =
            UserInstance.fromMap(doc.data() as Map<String, dynamic>);
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> signout() async {
    FirebaseAuth.instance.signOut();
  }
}
