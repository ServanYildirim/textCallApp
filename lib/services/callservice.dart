
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CallService {

  final String onlineColName = "online";

  late final DocumentReference docRef = FirebaseFirestore.instance.collection(onlineColName).doc("1");

  void setOnlineUser({required String uid}) {
  final DocumentReference docRef = FirebaseFirestore.instance.collection(onlineColName).doc(uid);
    docRef.set({"status": true});
  }

  void deleteOnlineUser({required String uid}) {
    final DocumentReference docRef = FirebaseFirestore.instance.collection(onlineColName).doc(uid);
    docRef.delete();
  }

}