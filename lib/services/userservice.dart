import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:web_rtc_template/controllers/usercontroller.dart';
import 'package:web_rtc_template/models/usermodel.dart';
import 'package:web_rtc_template/services/channelservice.dart';
import 'package:web_rtc_template/views/homepage.dart';

class UserService {

  final String userColName = "users";
  final String statusKey = "status";

  final ChannelService channelService = ChannelService();

  late final CollectionReference? userRef = FirebaseFirestore.instance.collection(userColName).withConverter<UserModel>(
    fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
    toFirestore: (userModel, _) => userModel.toJson(),
  );

  Future<void> getSetUser({required String userId}) async {
    await userRef?.doc(userId).get().then((user) {
      UserController.me = (user.data() as UserModel)..id = user.id;
      log(UserController.me!.toJson().toString(), name: "Me");
      Get.to(HomePage());
    });
  }

  Future<void> save({required UserModel userModel}) async {
    await userRef?.doc(userModel.id).set(userModel).then((_) {
      getSetUser(userId: userModel.id.toString());
    });
  }

  Future<void> addInterest({required String interestId}) async {
    await userRef?.doc(UserController.me?.id).update(
      {channelService.channelColName: FieldValue.arrayUnion([interestId])},
    );
  }

  Future<void> removeInterest({required String interestId}) async {
    await userRef?.doc(UserController.me?.id).update(
      {channelService.channelColName: FieldValue.arrayRemove([interestId])},
    );
  }

  Future<void> setStatus({required bool status}) async {
    await userRef?.doc(UserController.me?.id).update(
      {statusKey: status},
    );
  }

}

