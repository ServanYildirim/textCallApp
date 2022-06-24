import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_rtc_template/controllers/usercontroller.dart';
import 'package:web_rtc_template/models/usermodel.dart';
import 'package:web_rtc_template/services/userservice.dart';
import 'package:web_rtc_template/views/homepage.dart';

class AuthService {
  final UserService userService = UserService();

  final _auth = FirebaseAuth.instance;

  Future<void> register({
    required String emailToAuth,
    required String passwordToAuth,
    required UserModel userModelToFirestore,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: emailToAuth, password: passwordToAuth).then((UserCredential user) {
        log(user.toString(), name: "UserCredential for register");
        userService.setUser(userModel: userModelToFirestore..id = user.user?.uid); // We need to set doc id in firestore user. (Auth uid = firestore doc id)
      });
    } catch (e) {
      Get.defaultDialog(
        title: "",
        middleText: e.toString(),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () => Get.back(),
          ),
        ],
      );
    }
  }

  Future<void> signIn({required String emailToAuth, required String passwordToAuth}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: emailToAuth, password: passwordToAuth).then((UserCredential user) {
        log(user.toString(), name: "UserCredential for login");
      });
    } catch (e) {
      Get.defaultDialog(
        title: "",
        middleText: e.toString(),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () => Get.back(),
          ),
        ],
      );
    }
  }
}
