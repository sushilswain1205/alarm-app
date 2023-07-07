import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetailsModel {
  Timestamp? createdAt;
  String? userEmail;
  String? userId;
  String? userName;
  String? userPhone;
  String? fcm;
  bool? isNurse;

  UserDetailsModel(
      {this.createdAt,
        this.userEmail,
        this.userId,
        this.userName,
        this.userPhone,
      this.fcm,this.isNurse});

  UserDetailsModel.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    userEmail = json['userEmail'];
    userId = json['userId'];
    userName = json['userName'];
    userPhone = json['userPhone'];
    fcm = json['fcm'];
    isNurse = json['isNurse'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['userEmail'] = this.userEmail;
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['userPhone'] = this.userPhone;
    data['fcm'] = this.fcm;
    data['isNurse'] = this.isNurse;
    return data;
  }
}
