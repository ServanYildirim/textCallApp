import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_rtc_template/controllers/usercontroller.dart';
import 'package:web_rtc_template/models/usermodel.dart';
import 'package:web_rtc_template/services/userservice.dart';
import 'package:web_rtc_template/views/homepage.dart';

class AuthService {

  final auth = FirebaseAuth.instance;
  final UserService userService = UserService();

  void showErrorDialog({required var error}) => Get.defaultDialog(
    title: "",
    middleText: error.toString(),
    actions: [
      TextButton(
        child: const Text("OK"),
        onPressed: () => Get.back(),
      ),
    ],
  );

  Future<void> register({
    required String emailToAuth,
    required String passwordToAuth,
    required UserModel userModelToFirestore,
  }) async {
    try {
      await auth.createUserWithEmailAndPassword(email: emailToAuth, password: passwordToAuth).then((UserCredential user) {
        log(user.toString(), name: "UserCredential for register");
        userService.save(userModel: userModelToFirestore..id = user.user?.uid); // We need to set doc id in firestore user. (Auth uid = firestore doc id)
      });
    }catch (e) {
      showErrorDialog(error: e);
    }
  }

  Future<void> login({required String emailToAuth, required String passwordToAuth}) async {
    try {
      await auth.signInWithEmailAndPassword(email: emailToAuth, password: passwordToAuth).then((UserCredential user) {
        log(user.toString(), name: "UserCredential for login");
        Get.to(const HomePage());
      });
    } catch (e) {
      showErrorDialog(error: e);
    }
  }
}
