import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nursecallingapp/views/loginscreen.dart';

import '../controller/controller.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController userPhoneController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  User? currentUser = FirebaseAuth.instance.currentUser;
  LoginController loginController = Get.put(LoginController());
  bool? isNurse;
  bool _obscureText = true;
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('SignUpScreen'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      controller: userNameController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.person),
                        hintText: 'User Name',
                        enabledBorder: OutlineInputBorder(),
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return("Please Type Something");
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      controller: userPhoneController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.phone),
                        hintText: 'Phone',
                        enabledBorder: OutlineInputBorder(),
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return("Please Type Something");
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      controller: userEmailController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.email),
                        hintText: 'Email',
                        enabledBorder: OutlineInputBorder(),
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return("Please Type Something");
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      obscureText: _obscureText,
                      controller: userPasswordController,
                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                            onTap:(){setState(() {
                              _obscureText = !_obscureText;
                            });},
                            child: Icon(Icons.remove_red_eye_outlined)),
                        hintText: 'Password',
                        enabledBorder: OutlineInputBorder(),
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return("Please Type Something");
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(padding: EdgeInsets.only(left: 30,right: 30),child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(
                        color: Colors.black,

                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: RadioListTile(
                            title: Text('Patient'),
                            value: false,
                            groupValue: isNurse,
                            onChanged: (value) {
                              setState(() {
                                isNurse = value;
                              });
                            },
                          ),
                        ),

                        Expanded(
                          child: RadioListTile(
                            title: Text('Nurse'),
                            value: true,
                            groupValue: isNurse,
                            onChanged: (value) {
                              setState(() {
                                isNurse = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),),
                  ElevatedButton(
                      onPressed: () async {
                        if(_formkey.currentState!.validate()){
                          var userName = userNameController.text.trim();
                          var userPhone = userPhoneController.text.trim();
                          var userEmail = userEmailController.text.trim();
                          var userPassword = userPasswordController.text.trim();
                          FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                              email: userEmail, password: userPassword)
                              .then((value) => {
                            log("User Created"),
                            loginController.signUpUser(
                                userName,
                                userPhone,
                                userEmail,
                                userPassword,
                                isNurse!
                            )
                          });
                        }

                      },
                      child: Text('SingUp')),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => LoginScreen());
                    },
                    child: Container(
                      child: Card(
                          child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text("Already have an acount"),
                      )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
