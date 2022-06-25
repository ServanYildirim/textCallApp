import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_rtc_template/models/interest.dart';

class InterestService {

  final String interestColName = "interests";

  late final CollectionReference? interestRef = FirebaseFirestore.instance.collection(interestColName).withConverter<Interest>(
    fromFirestore: (snapshot, _) => Interest.fromJson(snapshot.data()!),
    toFirestore: (interest, _) => interest.toJson(),
  );

  Future<List<Interest>?> getCategories() async {
    QuerySnapshot<Object?>? tempList = await interestRef?.get();
    return tempList?.docs.map((i) {
      log((i.data() as Interest).name.toString(), name: i.id);
      return Interest(
        id: i.id, // doc id
        name: (i.data() as Interest).name,
      );
    }
    ).toList();
  }

}