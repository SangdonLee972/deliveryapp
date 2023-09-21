import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../Model/User.dart';

class EmailLogin {
  bool configured = false;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<int> signup(
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


      // 나머지 사용자 정보 설정 및 저장 작업 추가

      return 200;
    } on FirebaseAuthException catch (e) {
      // FirebaseAuthException을 캐치하여 예외 처리
      if (e.code == 'weak-password') {
        print('비밀번호가 너무 약합니다.');
        return 401;
        // 여기에서 사용자에게 적절한 오류 메시지를 표시하거나 처리할 동작을 수행할 수 있습니다.
      } else if (e.code == 'email-already-in-use') {
        print('이미 사용 중인 이메일 주소입니다.');
        return 402;
        // 여기에서 사용자에게 적절한 오류 메시지를 표시하거나 처리할 동작을 수행할 수 있습니다.
      }
      // 기타 Firebase 관련 예외에 대한 처리 추가 가능

      return 404;
    } catch (e) {
      // FirebaseAuthException 이외의 예외를 캐치하여 처리
      print('회원 가입 중 오류 발생: $e');
      return 405;
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
