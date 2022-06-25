
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {

  String? id;
  String? userName;
  String? bio;
  String? email;
  DateTime? birthDate;

  UserModel({
    this.id,
    this.userName,
    this.bio,
    this.email,
    this.birthDate,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      //id: json['id'], // Get from docRef
      userName: json['userName'],
      bio: json['bio'],
      email: json['email'],
      birthDate: DateTime.fromMillisecondsSinceEpoch((json['birthDate'] as Timestamp).millisecondsSinceEpoch), // Timestamp to DateTime
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    //data['id'] = id;
    data['userName'] = userName;
    data['bio'] = bio;
    data['email'] = email;
    data['birthDate'] = birthDate;
    return data;
  }
}