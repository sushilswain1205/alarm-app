import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nursecallingapp/views/loginscreen.dart';

import 'controller/user_controller.dart';
import 'views/homenavigator.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  fcmNotification();
  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

fcmNotification() {
  UserController userController = Get.put(UserController());
  try {
    FirebaseMessaging.instance.requestPermission().then((value) async {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
      FirebaseMessaging.onMessageOpenedApp
          .listen((RemoteMessage message) async {

      });
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        print("=================on========= Message=============");
        print(message.data);
        print(message.data["type"].runtimeType);
        String notification ;
        userController.fetchActivity();
        userController.fetchInActivity();
        if(message.data["type"] == "1"){
          notification = "assets/ringtones/critical.mp3";
        }else if (message.data["type"]=="2"){
          notification = "assets/ringtones/emergency.mp3";
        }else{
          notification = "assets/ringtones/normal.wav";
        }
        AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
        assetsAudioPlayer.open( Audio(notification),
          autoStart: true,
          showNotification: true,);

        showDialog<String>(
          context: Get.context!,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Emergency'),
            content: const Text('Patient require '),
            actions: <Widget>[

              TextButton(
                onPressed: () {
                  userController.updateActivity(message.data["key"]);
                  Navigator.pop(context);
                  assetsAudioPlayer.pause();

                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      });
    });
  } catch (e) {
    throw e;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
debugShowCheckedModeBanner: false,
      home:HomeNavigator(),
    );
  }
}


