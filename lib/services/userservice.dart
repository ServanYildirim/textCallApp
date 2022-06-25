import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:web_rtc_template/controllers/usercontroller.dart';
import 'package:web_rtc_template/models/usermodel.dart';
import 'package:web_rtc_template/views/homepage.dart';

class UserService {

  final String userColName = "users";

  late final CollectionReference? userRef = FirebaseFirestore.instance.collection(userColName).withConverter<UserModel>(
    fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
    toFirestore: (userModel, _) => userModel.toJson(),
  );

  Future<void> save({required UserModel userModel}) async {
    await userRef?.doc(userModel.id).set(userModel).then((_) {
      userRef?.doc(userModel.id).get().then((user) {
        UserController.me = user.data() as UserModel;
        log(UserController.me!.toJson().toString(), name: "Me");
        Get.to(const HomePage());
      });
    });
  }

}