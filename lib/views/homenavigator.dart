import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nursecallingapp/controller/user_controller.dart';

import 'loginscreen.dart';
import 'mainscreen.dart';
class HomeNavigator extends StatelessWidget {
   HomeNavigator({Key? key}) : super(key: key);

  UserController userController = Get.find();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: FirebaseAuth.instance.userChanges(),builder:(context, snapshot) {
      if(snapshot.hasData){
        userController.fetchUserDetails();
        return MainScreen();
      }else{
        return LoginScreen();
      }
    }, );
  }
}
