
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:web_rtc_template/controllers/usercontroller.dart';
import 'package:web_rtc_template/models/meetingmodel.dart';
import 'package:web_rtc_template/services/rtcservice.dart';

class MeetingService {

  final String meetingColName = "meetings";
  final String client2IdKey = "client2Id";
  final String roomIdKey = "roomId";
  final String defaultClient2Id = "";

  final RtcService rtcService = RtcService();

  late final CollectionReference? meetingRef = FirebaseFirestore.instance.collection(meetingColName).withConverter<MeetingModel>(
    fromFirestore: (snapshot, _) => MeetingModel.fromJson(snapshot.data()!),
    toFirestore: (interest, _) => interest.toJson(),
  );

  Future<void> createOrJoinMeeting() async {
    final QuerySnapshot? meetingSnap = await meetingRef?.get();
    if (
    meetingSnap == null
        || meetingSnap.size == 0
        || meetingSnap.docs.every((QueryDocumentSnapshot i) => (i.data() as MeetingModel).client2Id != "")
    ) {
      final String? roomId = await rtcService.createRoom();
      if (roomId != null) {
        meetingRef?.add(
          MeetingModel(
            client1Id: UserController.me!.id,
            client2Id: "",
            roomId: roomId,
          ),
        );
      }
    }
    else {
      final QueryDocumentSnapshot firstDoc = meetingSnap.docs.firstWhere((QueryDocumentSnapshot i) => (i.data() as MeetingModel).client2Id == "");
      rtcService.joinRoom(roomId: (firstDoc.data() as MeetingModel).roomId!);
      meetingRef?.doc(firstDoc.id).update(
        {
          client2IdKey: UserController.me!.id,
          roomIdKey: (firstDoc.data() as MeetingModel).roomId!,
        },
      );
    }
  }

}