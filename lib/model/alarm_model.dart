import 'package:cloud_firestore/cloud_firestore.dart';

class AlarmModel {
  bool? isSeen;
  Timestamp? sentDate;
  int? type;
  String? userId;
  String? userName;
  String? key;

  AlarmModel(
      {this.isSeen,
        this.sentDate,
        this.type,
        this.userId,
        this.userName,
        this.key});

  AlarmModel.fromJson(Map<String, dynamic> json) {
    isSeen = json['isSeen'];
    sentDate = json['sent_date'];
    type = json['type'];
    userId = json['userId'];
    userName = json['userName'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSeen'] = this.isSeen;
    data['sent_date'] = this.sentDate;
    data['type'] = this.type;
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['key'] = this.key;
    return data;
  }
}
