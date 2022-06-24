
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CallService {

  final String onlineCollectionName = "online";

  late final DocumentReference docRef = FirebaseFirestore.instance.collection(onlineCollectionName).doc("1");

  void setOnlineUser({required String uid}) {
  final DocumentReference docRef = FirebaseFirestore.instance.collection(onlineCollectionName).doc(uid);
    docRef.set({"status": true});
  }

  void deleteOnlineUser({required String uid}) {
    final DocumentReference docRef = FirebaseFirestore.instance.collection(onlineCollectionName).doc(uid);
    docRef.delete();
  }

}