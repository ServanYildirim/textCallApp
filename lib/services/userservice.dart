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

  Future<void> setUser({required UserModel userModel}) async {
    await userRef?.doc(userModel.id).set(userModel).then((_) {
      Get.to(const HomePage());
    });
  }

}