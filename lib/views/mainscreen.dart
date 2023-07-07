import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nursecallingapp/controller/controller.dart';
import 'package:nursecallingapp/controller/user_controller.dart';

import '../controller/send_alert_controller.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
 // bool isNurse = false;
  UserController userController = Get.find();
  SendAlertController sendAlertController = Get.put(SendAlertController());
  LoginController loginController = Get.put(LoginController());
  @override
  void initState() {
    // TODO: implement initState
    userController.fetchActivity();
    userController.fetchInActivity();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        leading: Image.asset('assets/ringtones/drawer.png',height: 10,),
        backgroundColor: Colors.grey[700],
        title: Text("Alarms",style: TextStyle(fontSize: 20),),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Obx(()=>Column(children: [
        myAlarm(),
        activeList(),
        recentList(),
      ],)),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          userController.fetchNurseList();
          userController.getUserDetails.isNurse != true ?
          sendAlarmToUsers() : (){};
        },
        child: Icon(Icons.notification_add),
      ),
    );
  }

  activeList(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20,),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text("Active",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
        ),
        SizedBox(height: 10,),
        SizedBox(
          height: MediaQuery.of(context).size.width/1.5,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: userController.getActiveAlarmList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: (){
                  userController.updateActivity(userController.getActiveAlarmList[index].key!);
                },
                child: Container(
                  height: 90,
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey))
                  ),
                  child: Row(children: [
                    Container(
                      width: 55,
                      height: 90,
                      color: alarmColor(userController.getActiveAlarmList[index].type!),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Icon(Icons.check_circle,color: Colors.white,),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 20),
                        width: 55,
                        color: Colors.white,
                        child: Column
                          (
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Patient is in truble",style: TextStyle(color: Colors.black),),
                              Text(userController.getActiveAlarmList[index].userName!,style: TextStyle(color: Colors.black,fontSize: 18),),
                            ]),
                      ),
                    ),
                  ],),
                ),

              );
              //  return
            },
          ),
        ),
        SizedBox(height: 10,)
      ],
    );
  }
  recentList(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //SizedBox(height: 20,),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text("Recent",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
        ),
        SizedBox(height: 10,),
        SizedBox(
          height: MediaQuery.of(context).size.width/1.5,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: userController.getInActiveAlarmList.length,
            itemBuilder: (context, index) {
              return Container(
                height: 90,
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey))
                ),
                child: Row(children: [
                  Container(
                    width: 55,
                    height: 90,
                    color: alarmColor(userController.getInActiveAlarmList[index].type!),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Icon(Icons.check_circle,color: Colors.white,),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 20),
                      width: 55,
                      color: Colors.white,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Patient is in trouble",style: TextStyle(color: Colors.black),),
                            Text(userController.getInActiveAlarmList[index].userName!,style: TextStyle(color: Colors.black,fontSize: 18),),
                          ]),
                    ),
                  ),
                ],),
              );
              //  return
            },
          ),
        ),
      ],
    );
  }
  myAlarm(){
    return Container(height: 80,
      child: Row(children: [
        Container(
          width: 55,
          height: 80,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Image.asset("assets/doctor.png",color: Colors.indigo,),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: 20),
            width: 55,
            color: Colors.indigo,
            child: Column
              (
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("MY CLAIMED ALARM",style: TextStyle(color: Colors.white),),
                  Text(userController.getUserDetails.userName==null? "":userController.getUserDetails.userName!,style: TextStyle(color: Colors.white,fontSize: 18),),
                  Text("Call Button Alarm Near Room 151",style: TextStyle(color: Colors.white),),
                ]),
          ),
        ),
      ],),
    );
  }
  sendAlarmToUsers(){
    showModalBottomSheet<void>(

      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
            ),
            child:Column(
              children: [
                SizedBox(height: 10,),
                Text("Send Alarm",style: TextStyle(fontSize: 18),),
                SizedBox(height: 5,),
                Container(height: 3,
                  width: 100,color: Colors.grey,),
                Expanded(child: Obx(()=>Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(height: 3,),
                    itemCount:  userController.getNurseList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 15,right: 15),
                        child: Container(
                          decoration:BoxDecoration(borderRadius: BorderRadius.circular(12),color: Colors.indigo.withOpacity(0.7),),
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(userController.getNurseList[index].userName!,style: TextStyle(fontSize: 16),),
                                  //Text(userController.getNurseList[index].userEmail!)
                                ],),
                              Row(children: [
                                InkWell(onTap: (){
                                  sendAlertController.sendAlarm(1, userController.getNurseList[index].userId!, userController.getUserDetails.userName!,userController.getNurseList[index].fcm!);
                                },child: Container(height:35,decoration:BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.red),padding: EdgeInsets.all(5),child: Center(child: Text("Critical")),),),
                                SizedBox(width: 10,),
                                InkWell(onTap:(){
                                  sendAlertController.sendAlarm(2, userController.getNurseList[index].userId!, userController.getUserDetails.userName!,userController.getNurseList[index].fcm!);
                                },child: Container(height:35,decoration:BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.amber),padding: EdgeInsets.all(5),child: Center(child: Text("Urgent")),),),
                                SizedBox(width: 10,),
                                InkWell(onTap: (){
                                  sendAlertController.sendAlarm(3, userController.getNurseList[index].userId!, userController.getUserDetails.userName!,userController.getNurseList[index].fcm!);
                                },child: Container(height:35,decoration:BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.green),padding: EdgeInsets.all(5),child: Center(child: Text("Normal")),),),
                              ],)
                            ],),
                        ),
                      );
                    },),
                ))),
              ],
            )
        );
      },
    );
  }

  Color alarmColor(int val){
    switch(val){
      case 1 :
        return Colors.red;
      case 2 :
        return Colors.yellow;
      case 3 :
        return Colors.green;
      default :
        return Colors.green;
    }
  }

}
