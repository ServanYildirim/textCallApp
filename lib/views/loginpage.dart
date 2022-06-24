import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_rtc_template/components/customdatepickertile.dart';
import 'package:web_rtc_template/components/customtextfieldtile.dart';
import 'package:web_rtc_template/models/usermodel.dart';
import 'package:web_rtc_template/services/userservice.dart';
import 'package:web_rtc_template/views/homepage.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final UserService userService = UserService();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController userNameTextCtrl = TextEditingController();
  final TextEditingController bioTextCtrl = TextEditingController();
  final TextEditingController phoneTextCtrl = TextEditingController();
  final TextEditingController emailTextCtrl = TextEditingController();
  final TextEditingController password1TextCtrl = TextEditingController();
  final TextEditingController password2TextCtrl = TextEditingController();

  final ValueNotifier<DateTime?> selectedDate = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            CustomTextFieldTile(
              textCtrl: userNameTextCtrl,
              icon: Icons.person,
              label: "Username",
              textCapitalization: TextCapitalization.none,
              textInputType: TextInputType.name,
              validatorFunc: (input) {
                if (input!.trim().isEmpty) {
                  return "This field cannot be blank";
                }
                else {
                  return null;
                }
              },
            ),
            CustomTextFieldTile(
              textCtrl: bioTextCtrl,
              icon: Icons.description_outlined,
              label: "Bio",
              textCapitalization: TextCapitalization.sentences,
              textInputType: TextInputType.text,
              validatorFunc: (input) {
                if (input!.trim().isEmpty) {
                  return "This field cannot be blank";
                }
                else {
                  return null;
                }
              },
            ),
            CustomTextFieldTile(
              textCtrl: phoneTextCtrl,
              icon: Icons.phone,
              label: "Phone",
              textCapitalization: TextCapitalization.none,
              textInputType: TextInputType.phone,
              validatorFunc: (input) {
                if (input!.trim().isEmpty) {
                  return "This field cannot be blank";
                }
                else {
                  return null;
                }
              },
              isPhone: true,
            ),
            CustomTextFieldTile(
              textCtrl: emailTextCtrl,
              icon: Icons.email_outlined,
              label: "Email",
              textCapitalization: TextCapitalization.none,
              textInputType: TextInputType.emailAddress,
              validatorFunc: (input) {
                if (input!.trim().isEmpty) {
                  return "This field cannot be blank";
                }
                else if (!input.contains(".") || !input.contains("@")) {
                  return "Please enter a valid email";
                }
                else {
                  return null;
                }
              },
            ),
            CustomTextFieldTile(
              textCtrl: password1TextCtrl,
              icon: Icons.key,
              label: "Password",
              textCapitalization: TextCapitalization.none,
              textInputType: TextInputType.visiblePassword,
              validatorFunc: (input) {
                if (input!.trim().isEmpty) {
                  return "This field cannot be blank";
                }
                /*
                else if (input.length < 8) {
                  return "please enter at least 8 characters";
                }

                 */
                else {
                  return null;
                }
              },
              isPassword: true,
            ),
            CustomTextFieldTile(
              textCtrl: password2TextCtrl,
              icon: Icons.key,
              label: "Password (repeat)",
              textCapitalization: TextCapitalization.none,
              textInputType: TextInputType.visiblePassword,
              validatorFunc: (input) {
                if (input!.trim().isEmpty) {
                  return "This field cannot be blank";
                }
                else if (input != password1TextCtrl.text) {
                  return "Passwords do not match";
                }
                else {
                  return null;
                }
              },
              isPassword: true,
            ),
            CustomDatePickerCard(selectedDate: selectedDate),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: ElevatedButton(
                child: const Text("Sign Up"),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    if (selectedDate.value == null) {
                      Get.defaultDialog(
                        title: "",
                        middleText: "Please select your birthdate",
                        actions: [
                          TextButton(
                            child: const Text("OK"),
                            onPressed: () => Get.back(),
                          ),
                        ],
                      );
                    }
                    else {
                      userService.loginUser(
                        userModel: UserModel(
                          userName: userNameTextCtrl.text,
                          bio: bioTextCtrl.text,
                          email: emailTextCtrl.text,
                          password: password1TextCtrl.text,
                          phone: phoneTextCtrl.text,
                          birthDate: selectedDate.value,
                        ),
                      );
                    }
                  }
                },
              ),
            ),
            ListTile(
              title: ElevatedButton(
                child: const Text("Direct entry"),
                onPressed: () => Get.to(const HomePage()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
