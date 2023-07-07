import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nursecallingapp/views/mainscreen.dart';
import 'package:nursecallingapp/views/signupscreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Login Screen'),

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
                      controller: loginEmailController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.email),
                        hintText: 'Email',
                        enabledBorder: OutlineInputBorder(),
                      ),
                      validator: (value){
                        if(value!.isEmpty || value!.isNum)
                          return("Please Type Something");
                      },
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      controller: loginPasswordController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.remove_red_eye_outlined),
                        hintText: 'Password',
                        enabledBorder: OutlineInputBorder(),
                      ),
                      validator: (value){
                        if(value!.isEmpty)
                          return("Please Type Something");
                      },
                    ),
                  ),
                  SizedBox(height: 10,),
                  ElevatedButton(onPressed: ()async {
                    if(_formkey.currentState!.validate());
                    var loginEmail = loginEmailController.text.trim();
                    var loginPassword = loginPasswordController.text.trim();
                    try {
                      final User? firebaseUser =  ( await FirebaseAuth.instance.
                      signInWithEmailAndPassword(email: loginEmail,
                          password: loginPassword)).user;
                      if (firebaseUser!=null){
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainScreen(),), (route) => false);
                      }else{
                        print("Check Email or Password");
                      }
                    } on FirebaseAuthException catch (e) {
                      print("Error $e");
                    }
                  }
                  , child: Text('Login')),
                  SizedBox(height: 10,),
                  /*GestureDetector(
                    onTap: (){
                      //Get.to(()=>ForgetPasswordScreen());
                    },
                    child: Container(child: Card(child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text('Forget Passwod'),
                    )),),
                  ),*/
                  GestureDetector(
                    onTap: (){
                     Get.to(()=>SignUpScreen());
                    },
                    child: Container(child: Card(child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("Don't have an acount SignUp"),
                    )),),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

    );  }
}
