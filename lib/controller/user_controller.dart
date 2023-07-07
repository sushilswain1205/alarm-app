import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../model/alarm_model.dart';
import '../model/user_details_model.dart';

class UserController extends GetxController {
  var userDetails = UserDetailsModel().obs;
  UserDetailsModel get getUserDetails => userDetails.value;
  set setUserDetails(UserDetailsModel val) {
    userDetails.value = val;
    userDetails.refresh();
  }

  fetchUserDetails() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setUserDetails = UserDetailsModel.fromJson(value.data()!);
    });
  }

  var nurseList= <UserDetailsModel>[].obs;
 List<UserDetailsModel> get getNurseList => nurseList.value;
  set setNurseList(UserDetailsModel val) {
    if(val.userId != FirebaseAuth.instance.currentUser!.uid.toString())
    nurseList.value.add(val);
    nurseList.refresh();
  }
  var isNurseListLoaded = false.obs;
  bool get getIsNurseListLoaded => isNurseListLoaded.value;
  set setIsNurseListLoaded(bool val){
    isNurseListLoaded.value = val;
    isNurseListLoaded.refresh();
  }
  fetchNurseList()async{
    nurseList.value.clear();
    nurseList.refresh();
    setIsNurseListLoaded = false;
    FirebaseFirestore.instance.collection("users").get().then((value) {
      if(value.size == 0){
        setIsNurseListLoaded = true;
      }
      value.docs.forEach((element) {
        setNurseList = UserDetailsModel.fromJson(element.data());
        setIsNurseListLoaded = true;
      });

    }).onError((error, stackTrace) {
      setIsNurseListLoaded = true;
    });
  }

  var activeAlarmList = <AlarmModel>[].obs;
  List<AlarmModel> get getActiveAlarmList => activeAlarmList.value;
  set setActiveAlarmList(AlarmModel val){
    if(getActiveAlarmList.where((element) => element.key ==val.key).toList().length == 0 ){
      print("================List================");
      activeAlarmList.value.add(val);
      activeAlarmList.refresh();
    }

  }

  var isActiveListLoaded = false.obs;
  bool get getIsActiveListLoaded => isActiveListLoaded.value;
  set setIsActiveListLoaded(bool val){
    isActiveListLoaded.value = val;
    isActiveListLoaded.refresh();
  }
  fetchActivity()async{
    FirebaseFirestore.instance.collection("alarm").where("isSeen",isEqualTo: false).orderBy("sent_date",descending:false ).get().then((value) {
      print("================userController.Active.userName!=============");
      print(value.size);
      if(value.size == 0){
        setIsActiveListLoaded = true;
      }
      value.docs.forEach((element) {
        print("object");
        print(element.data());
        AlarmModel alarmModel =AlarmModel.fromJson(element.data());
        alarmModel.key = element.id;
        setActiveAlarmList = alarmModel;
        setIsActiveListLoaded = true;
      });
    }).onError((error, stackTrace) {
      setIsActiveListLoaded = true;
    });;
  }
  updateActivity(String doc){
    FirebaseFirestore.instance.collection("alarm").doc(doc).update({
      "isSeen":true
    }).then((value) {
      activeAlarmList.value.removeWhere((element) => element.key == doc);
      activeAlarmList.refresh();
      fetchInActivity();
      fetchActivity();
    });
  }

  var inActiveAlarmList = <AlarmModel>[].obs;
  List<AlarmModel> get getInActiveAlarmList => inActiveAlarmList.value;
  set setInActiveAlarmList(AlarmModel val){
    inActiveAlarmList.value.add(val);
    inActiveAlarmList.refresh();
  }

  var isInActiveListLoaded = false.obs;
  bool get getIsInActiveListLoaded => isInActiveListLoaded.value;
  set setIsInActiveListLoaded(bool val){
    isActiveListLoaded.value = val;
    isActiveListLoaded.refresh();
  }
  fetchInActivity()async{
    inActiveAlarmList.value.clear();
    inActiveAlarmList.refresh();
    FirebaseFirestore.instance.collection("alarm").where("isSeen",isEqualTo: true).orderBy("sent_date",descending:false ).get().then((value) {
      print("========================userController.getUserDetails.userName!");
      print(value.size);
      if(value.size == 0){
        setIsInActiveListLoaded = true;
      }
      value.docs.forEach((element) {
        print("================inActive============");
        print(element.data());
        AlarmModel alarmModel =AlarmModel.fromJson(element.data());
        alarmModel.key = element.id;
        setInActiveAlarmList = alarmModel;
        setIsInActiveListLoaded = true;
      });
    }).onError((error, stackTrace) {
      setIsInActiveListLoaded = true;
    });
  }
}
