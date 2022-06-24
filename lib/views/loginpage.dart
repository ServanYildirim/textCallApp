import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_rtc_template/controllers/usercontroller.dart';
import 'package:web_rtc_template/services/authservice.dart';
import 'package:web_rtc_template/views/registerpage.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            title: ElevatedButton(
              child: const Text("Login with Ercan"),
              onPressed: () => authService.signIn(emailToAuth: UserController.ercan.email.toString(), passwordToAuth: UserController.ercan.password.toString()),
            ),
          ),
          ListTile(
            title: ElevatedButton(
              child: const Text("Login with Servan"),
              onPressed: () => authService.signIn(emailToAuth: UserController.servan.email.toString(), passwordToAuth: UserController.servan.password.toString()),
            ),
          ),
          ListTile(
            title: ElevatedButton(
              child: const Text("Register"),
              onPressed: () => Get.to(RegisterPage()),
            ),
          ),
        ],
      ),
    );
  }
}
