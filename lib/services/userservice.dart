import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:web_rtc_template/controllers/usercontroller.dart';
import 'package:web_rtc_template/models/usermodel.dart';
import 'package:web_rtc_template/views/homepage.dart';

class UserService {

  final String userCollectionName = "users";

  late final CollectionReference? userRef = FirebaseFirestore.instance.collection(userCollectionName).withConverter<UserModel>(
    fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
    toFirestore: (userModel, _) => userModel.toJson(),
  );

  void loginUser({required UserModel userModel}) {
    userRef?.add(userModel).then((DocumentReference userDoc) {
      Get.to(const HomePage());
    });
  }

}