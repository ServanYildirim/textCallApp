import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

typedef StreamStateCallback = void Function(MediaStream stream);

class RtcService {

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
  String? roomId;
  StreamStateCallback? onAddRemoteStream;

  void registerPeerConnectionListeners() {
    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      log(state.toString(), name: "onIceGatheringState");
    };
    peerConnection?.onConnectionState = (RTCPeerConnectionState state) {
      log(state.toString(), name: "onConnectionState");
    };
    peerConnection?.onSignalingState = (RTCSignalingState state) {
      log(state.toString(), name: "onSignalingState");
    };
    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      log(state.toString(), name: "onIceGatheringState");
    };
    peerConnection?.onAddStream = (MediaStream stream) {
      log("", name: "onAddStream");
      onAddRemoteStream?.call(stream);
      remoteStream = stream;
    };
  }

  Future<void> setPeerConnection() async {
    peerConnection = await createPeerConnection(configuration);
    log(configuration.toString(), name: "Peer Connection config");
    registerPeerConnectionListeners();
    localStream?.getTracks().forEach((track) {
      peerConnection?.addTrack(track, localStream!);
    });
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

  Future<String> createRoom() async {
    DocumentReference roomRef = FirebaseFirestore.instance.collection(roomColName).doc();
    setPeerConnection();
    collectIceCandidates(roomRef: roomRef, subColName: "callerCandidates");
    // Add code for creating a room
    RTCSessionDescription offer = await peerConnection!.createOffer();
    await peerConnection!.setLocalDescription(offer);
    log(offer.toString(), name: "Offer has created.");
    final Map<String, dynamic> roomWithOffer = {'offer': offer.toMap()};
    await roomRef.set(roomWithOffer);
    String roomId = roomRef.id;
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

  Future<void> joinRoom({required String roomId}) async {
    DocumentReference roomRef = FirebaseFirestore.instance.collection(roomColName).doc(roomId);
    var roomSnapshot = await roomRef.get();
    log(roomSnapshot.exists.toString(), name: "Room exist");
    if (roomSnapshot.exists) {
      setPeerConnection();
      collectIceCandidates(roomRef: roomRef, subColName: callerSubColName);
      var calleeCandidatesCol = roomRef.collection(calleeSubColName);
      peerConnection?.onIceCandidate = (RTCIceCandidate? candidate) {
        if (candidate == null) {
          log("null", name: "onIceCandidate");
          return;
        } else {
          log(candidate.toMap(), name: "onIceCandidate");
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

  Future<void> openUserMedia({required RTCVideoRenderer localVideo, required RTCVideoRenderer remoteVideo}) async {
    var stream = await navigator.mediaDevices.getUserMedia({'video': true, 'audio': true});
    localVideo.srcObject = stream;
    localStream = stream;
    remoteVideo.srcObject = await createLocalMediaStream('key');
  }

  Future<void> hangUp({required RTCVideoRenderer localVideo}) async {
    List<MediaStreamTrack> tracks = localVideo.srcObject!.getTracks();
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
    localStream!.dispose();
    remoteStream?.dispose();
  }
}
