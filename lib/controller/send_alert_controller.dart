import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class SendAlertController extends GetxController{

  sendAlarm(int type,String uId,String userName,String? token){
    FirebaseFirestore.instance.collection("alarm").add({
      "userId":uId,
      "sent_date":Timestamp.now(),
      "type":type,
      "isSeen":false,
      "userName":userName
    }).then((value) {
      sendNotification(subject: 'Patient ${userName} is suffering and he/she required your help, kindly check!!',title: "Alert",token: token,type: type,key: value.id);
     // constructFCMPayload(token,type);
    });
  }



  Future<void> sendNotification({subject, title, token,type,key}) async {

    final postUrl = 'https://fcm.googleapis.com/fcm/send';

    final data = {
      "notification": {"body": subject, "title": title},
      "priority": "high",
      "data": {
         "type": type,
         "sound": 'critical.mp3',
         "key":key
      },
      "android": {
        "priority": "high",
      },
      "to": token
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization': 'key=AAAAzpij4yA:APA91bG-xSEhvMM5K9c1TaoXMWkoDC2tklPZgkp-x3o9hR_G0W9RWtP0Go88R9_xbFrW3ySb6Xnc7_TneUrTur0EePl-k5RwKTitqJjjg_ouiOr6eRrBrzZTOgQM0a2Ub0FVSyzQueIA'
    };

    final response = await Dio().post(postUrl,
        data: json.encode(data),
        options: Options(headers: headers));

    if (response.statusCode == 200) {
// on success do
      print("true");
    } else {
// on failure do
      print("false");
    }
  }
}