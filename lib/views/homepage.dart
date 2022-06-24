import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:lottie/lottie.dart';
import 'package:web_rtc_template/models/usermodel.dart';
import 'package:web_rtc_template/services/callservice.dart';
import 'package:web_rtc_template/services/rtcservice.dart';
import 'package:web_rtc_template/services/userservice.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RtcService rtcService = RtcService();
  final UserService userService = UserService();
  final CallService callService = CallService();
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  final TextEditingController textEditingController = TextEditingController();

  String? roomId;

  @override
  void initState() {
    _localRenderer.initialize();
    _remoteRenderer.initialize();
    rtcService.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("RTC"),
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: callService.docRef.snapshots(),
            builder: (ctx, AsyncSnapshot<DocumentSnapshot> onlineSnap) {
              if (!onlineSnap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              else if (onlineSnap.hasError) {
                return const Center(child: Text("An error occured."));
              }
              /*
              else if (onlineSnap.data!.) {
                return const Center(child: Text("User list is empty."));
              }

               */
              else {
                return GestureDetector(
                child: Lottie.asset(
                  "assets/lotties/videocall.json",
                  height: kToolbarHeight * 2,
                  fit: BoxFit.contain,
                ),
                onTap: () {},
              );
              }
            }
          ),
          /*
          StreamBuilder(
            stream: userService.userRef?.snapshots(),
            builder: (ctx, AsyncSnapshot<QuerySnapshot> userSnap) {
              if (!userSnap.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else if (userSnap.hasError) {
                return const Center(child: Text("An error occured."));
              } else if (userSnap.data!.docs.isEmpty) {
                return const Center(child: Text("User list is empty."));
              } else {
                return ListView(
                  shrinkWrap: true,
                  children: userSnap.data!.docs
                      .map(
                        (i) => ListTile(
                          title: Text(i.id),
                        ),
                      )
                      .toList(),
                );
              }
            },
          ),

           */

        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: ElevatedButton(
                child: Icon(Icons.delete_forever),
                onPressed: () => callService.deleteOnlineUser(uid: "docccc"),
              ),
            ),
          ],
        ),
      ),
      /*
      body: Column(
        children: [
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    rtcService.openUserMedia(localVideo: _localRenderer, remoteVideo: _remoteRenderer);
                    setState(() {});
                  },
                  child: const Text("Open camera & microphone"),
                ),
                const SizedBox(
                  width: 8,
                ),
                ElevatedButton(
                  onPressed: () async {
                    roomId = await rtcService.createRoom(remoteRenderer: _remoteRenderer);
                    textEditingController.text = roomId!;
                    setState(() {});
                  },
                  child: const Text("Create room"),
                ),
                const SizedBox(
                  width: 8,
                ),
                ElevatedButton(
                  onPressed: () {
                    // Add roomId
                    rtcService.joinRoom(roomId: textEditingController.text, remoteVideo: _remoteRenderer);
                    setState(() {});
                  },
                  child: const Text("Join room"),
                ),
                const SizedBox(
                  width: 8,
                ),
                ElevatedButton(
                  onPressed: () {
                    rtcService.hangUp(localVideo: _localRenderer);
                  },
                  child: const Text("Hangup"),
                )
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: RTCVideoView(_localRenderer, mirror: true)),
                  Expanded(child: RTCVideoView(_remoteRenderer)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Join the following Room: "),
                Flexible(
                  child: TextFormField(
                    controller: textEditingController,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 8)
        ],
      ),
      */
    );
  }
}
