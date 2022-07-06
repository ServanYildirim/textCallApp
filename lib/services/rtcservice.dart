import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:web_rtc_template/controllers/usercontroller.dart';
import 'package:web_rtc_template/models/meetingmodel.dart';

typedef StreamStateCallback = void Function(MediaStream stream);

class RtcService {

  final RTCVideoRenderer localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer remoteRenderer = RTCVideoRenderer();

  final Map<String, dynamic> configuration = {
    'iceServers': [
      {
        'urls': [
          'stun:stun1.l.google.com:19302',
          'stun:stun2.l.google.com:19302',
        ]
      }
    ]
  };

  final String roomColName = "rooms";
  final String callerSubColName = "callerCandidates";
  final String calleeSubColName = "calleeCandidates";

  RTCPeerConnection? peerConnection;
  MediaStream? localStream;
  MediaStream? remoteStream;
  StreamStateCallback? streamStateCallback;

  //String? roomId;

  Future<void> setPeerConnection() async {
    peerConnection = await createPeerConnection(configuration);
    log(configuration.toString(), name: "Peer Connection config");
    registerPeerConnectionListeners();
    localStream?.getTracks().forEach((track) {
      peerConnection?.addTrack(track, localStream!);
    });
  }

  void registerPeerConnectionListeners() {
    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      log(state.name.toString(), name: "onIceGatheringState");
    };
    peerConnection?.onConnectionState = (RTCPeerConnectionState state) {
      log(state.name.toString(), name: "onConnectionState");
    };
    peerConnection?.onIceConnectionState = (RTCIceConnectionState state) {
      log(state.name.toString(), name: "onIceConnectionState");
    };
    peerConnection?.onDataChannel = (RTCDataChannel channel) {
      log(channel.state.toString(), name: "onDataChannel");
    };
    peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
      log(candidate.toMap().toString(), name: "onIceCandidate");
    };
    peerConnection?.onAddTrack = (MediaStream stream, MediaStreamTrack track) {
      log(stream.ownerTag.toString(), name: "onAddTrack");
      log(track.getConstraints().toString(), name: "onAddTrack");
    };
    peerConnection?.onAddStream = (MediaStream stream) {
      log(stream.ownerTag.toString(), name: "onAddStream");
      streamStateCallback?.call(stream);
      remoteStream = stream;
    };
  }

  void collectIceCandidates({required DocumentReference roomRef, required String subColName}) {
    final candidateCol = roomRef.collection(subColName);
    peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
      log(candidate.toMap().toString(), name: "onIceCandidate");
      candidateCol.add(candidate.toMap());
    };
  }

  void addTrackToPeerConnection() {
    peerConnection?.onTrack = (RTCTrackEvent event) {
      log(event.streams[0].toString(), name: "Remote track");
      event.streams[0].getTracks().forEach((track) {
        remoteStream?.addTrack(track);
        log(track.toString(), name: "Added track to stream");
      });
    };
  }

  void listenCandidates({required DocumentReference roomRef, required String subColName}) {
    roomRef.collection(subColName).snapshots().listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          Map<String, dynamic> data = change.doc.data() as Map<String, dynamic>;
          log(jsonEncode(data), name: "New remote ICE candidate");
          peerConnection!.addCandidate(
            RTCIceCandidate(
              data['candidate'],
              data['sdpMid'],
              data['sdpMLineIndex'],
            ),
          );
        }
      }
    });
  }

  Future<String?> createRoom() async {
    DocumentReference roomRef = FirebaseFirestore.instance.collection(roomColName).doc();
    await setPeerConnection();
    collectIceCandidates(roomRef: roomRef, subColName: callerSubColName);
    // Add code for creating a room
    RTCSessionDescription offer = await peerConnection!.createOffer();
    await peerConnection!.setLocalDescription(offer);
    log(offer.toString(), name: "Offer has created.");
    final Map<String, dynamic> roomWithOffer = {'offer': offer.toMap()};
    await roomRef.set(roomWithOffer);
    final String roomId = roomRef.id;
    log(roomId, name: "Room has created.");
    // Created a Room
    addTrackToPeerConnection();
    // Listening for remote session description below
    roomRef.snapshots().listen((snapshot) async {
      log(snapshot.data().toString(), name: "snapshot data");
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      if (peerConnection?.getRemoteDescription() != null && data['answer'] != null) {
        var answer = RTCSessionDescription(data['answer']['sdp'], data['answer']['type']);
        await peerConnection?.setRemoteDescription(answer);
      }
    });
    // Listening for remote session description above
    listenCandidates(roomRef: roomRef, subColName: calleeSubColName);
    return roomId;
  }

  Future<void> joinRoom({required String roomIdToJoin}) async {
    DocumentReference roomRef = FirebaseFirestore.instance.collection(roomColName).doc(roomIdToJoin);
    var roomSnapshot = await roomRef.get();
    log(roomSnapshot.exists.toString(), name: "Room exist");
    if (roomSnapshot.exists) {
      await setPeerConnection();
      collectIceCandidates(roomRef: roomRef, subColName: callerSubColName);
      var calleeCandidatesCol = roomRef.collection(calleeSubColName);
      peerConnection?.onIceCandidate = (RTCIceCandidate? candidate) {
        if (candidate == null) {
          log("null", name: "onIceCandidate");
          return;
        } else {
          log(candidate.toString(), name: "onIceCandidate");
          calleeCandidatesCol.add(candidate.toMap());
        }
      };
      addTrackToPeerConnection();
      // Code for creating SDP answer below
      var data = roomSnapshot.data() as Map<String, dynamic>;
      var offer = data['offer'];
      await peerConnection?.setRemoteDescription(
        RTCSessionDescription(offer['sdp'], offer['type']),
      );
      log(data.toString(), name: "Got offer");
      var answer = await peerConnection!.createAnswer();
      log(answer.toString(), name: "Created answer");
      await peerConnection!.setLocalDescription(answer);
      Map<String, dynamic> roomWithAnswer = {
        'answer': {'type': answer.type, 'sdp': answer.sdp}
      };
      await roomRef.update(roomWithAnswer);
      // Finished creating SDP answer
      listenCandidates(roomRef: roomRef, subColName: callerSubColName);
    }
  }

  Future<void> openUserMedia({required RTCVideoRenderer localRenderer, required RTCVideoRenderer remoteRenderer}) async {
    var stream = await navigator.mediaDevices.getUserMedia({'video': true, 'audio': true});
    localRenderer.srcObject = stream;
    localStream = stream;
    remoteRenderer.srcObject = await createLocalMediaStream('key');
  }

  Future<void> switchCamera() async {
    Helper.switchCamera(localStream!.getVideoTracks().first);
  }

  Future<void> hangUp({required RTCVideoRenderer localRenderer, required String? roomId}) async {
    List<MediaStreamTrack> tracks = localRenderer.srcObject!.getTracks();
    for (var track in tracks) {
      track.stop();
    }
    if (remoteStream != null) remoteStream!.getTracks().forEach((track) => track.stop());
    if (peerConnection != null) peerConnection!.close();
    if (roomId != null) {
      var roomRef = FirebaseFirestore.instance.collection(roomColName).doc(roomId);
      var calleeCandidates = await roomRef.collection(calleeSubColName).get();
      for (var document in calleeCandidates.docs) {
        document.reference.delete();
      }
      var callerCandidates = await roomRef.collection(callerSubColName).get();
      for (var document in callerCandidates.docs) {
        document.reference.delete();
      }
      await roomRef.delete();
    }
    localStream?.dispose();
    remoteStream?.dispose();
    roomId = null;
  }

  // Below is meeting service.

  final String meetingColName = "meetings";
  final String client2IdKey = "client2Id";
  final String roomIdKey = "roomId";
  final String channelIdKey = "channelId";
  final String defaultClient2Id = "";

  late final CollectionReference? meetingRef = FirebaseFirestore.instance.collection(meetingColName).withConverter<MeetingModel>(
    fromFirestore: (snapshot, _) => MeetingModel.fromJson(snapshot.data()!),
    toFirestore: (interest, _) => interest.toJson(),
  );

  Future<void> createOrJoinMeeting({required String channelId}) async {
    final QuerySnapshot? meetingSnap = await meetingRef?.where(channelIdKey, isEqualTo: channelId).get();
    if (
    meetingSnap == null
        || meetingSnap.size == 0
        || meetingSnap.docs.every((QueryDocumentSnapshot i) => (i.data() as MeetingModel).client2Id != "")
    ) {
      final String? roomId = await createRoom();
      if (roomId != null) {
        await meetingRef?.add(
          MeetingModel(
            client1Id: UserController.me!.id,
            client2Id: "",
            roomId: roomId,
            channelId: channelId,
          ),
        );
      }
    }
    else {
      final QueryDocumentSnapshot firstDoc = meetingSnap.docs.firstWhere((QueryDocumentSnapshot i) => (i.data() as MeetingModel).client2Id == "");
      await joinRoom(roomIdToJoin: (firstDoc.data() as MeetingModel).roomId!);
      await meetingRef?.doc(firstDoc.id).update(
        {
          client2IdKey: UserController.me!.id,
          roomIdKey: (firstDoc.data() as MeetingModel).roomId!,
        },
      );
    }
  }

}
