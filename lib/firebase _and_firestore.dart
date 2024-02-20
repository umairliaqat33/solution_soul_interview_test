import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:solution_soul_interview_test/chat_model.dart';

class FirebaseAndFirestore {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final User? _user = FirebaseAuth.instance.currentUser;

  Future<UserCredential?> signUp(String email, String password) async {
    UserCredential? userCredential;
    try {
      userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      if (e == "email-already-in-use") {
        Fluttertoast.showToast(msg: 'Email already in use');
      } else {
        Fluttertoast.showToast(msg: "something went wrong");
      }
    }
    return userCredential;
  }

  Future<UserCredential?> signIn(
    String email,
    String password,
  ) async {
    UserCredential? userCredential;
    try {
      userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' ||
          e.code == 'user-not-found' ||
          e.code == 'invalid-credential') {
        Fluttertoast.showToast(msg: "Email or Password is incorrect");
      } else {
        Fluttertoast.showToast(msg: "something went wrong");
      }
    }
    return userCredential;
  }

  Future<void> sendMessage(ChatModel chat) async {
    try {
      await _firebaseFirestore
          .collection(getUserId.toString())
          .doc(chat.messageId)
          .set(chat.toJson());
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  String getUserId() {
    return _user!.uid;
  }

  User getUser() {
    return _user!;
  }

  bool checkLoginStatus() {
    if (_user != null) {
      return true;
    } else {
      return false;
    }
  }

  Stream<List<ChatModel>?> getMessages() {
    return _firebaseFirestore.collection(getUserId.toString()).snapshots().map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => ChatModel.fromJson(
                  doc.data(),
                ),
              )
              .toList(),
        );
  }
}
