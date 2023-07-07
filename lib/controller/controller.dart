
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nursecallingapp/views/loginscreen.dart';
import 'package:nursecallingapp/views/mainscreen.dart';

class LoginController extends GetxController {
  signUpUser(String userName, String userPhone, String userEmail,
      String userPassword,bool isNurse) async {
    User? userid = FirebaseAuth.instance.currentUser;
    final token = await FirebaseMessaging.instance.getToken();
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userid!.uid)
          .set({
        'userName': userName,
        'userPhone': userPhone,
        'userEmail': userEmail,
        'createdAt': DateTime.now(),
        'userId': userid.uid,
        "isNurse": isNurse,
        'fcm':token
      }).then((value) => {

               Navigator.pushAndRemoveUntil(Get.context!, MaterialPageRoute(builder: (context) => MainScreen(),), (route) => false)
              });
    } on FirebaseAuthException catch (e) {
      print("Error $e");
    }
  }
}
