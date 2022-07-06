import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:lottie/lottie.dart';
import 'package:web_rtc_template/controllers/usercontroller.dart';
import 'package:web_rtc_template/models/channelmodel.dart';
import 'package:web_rtc_template/models/meetingmodel.dart';
import 'package:web_rtc_template/services/rtcservice.dart';

class CallPage extends StatefulWidget {

  final ChannelModel channelModel;

  const CallPage({Key? key, required this.channelModel}) : super(key: key);

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> with TickerProviderStateMixin, RtcService {

  late final AnimationController lottieCtrl;

  @override
  void initState() {
    lottieCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        lottieCtrl.reverse();
      }
    });
    localRenderer.initialize().then((_) => setState(() {}));
    remoteRenderer.initialize().then((_) => setState(() {}));
    streamStateCallback = ((stream) {
      remoteRenderer.srcObject = stream;
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    lottieCtrl.dispose();
    localRenderer.dispose();
    remoteRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.channelModel.name.toString()),
        actions: [
          IconButton(
            icon: const Icon(Icons.switch_camera),
            onPressed: () async => await switchCamera(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: GestureDetector(
                child: Lottie.asset(
                  "assets/lotties/videocall.json",
                  repeat: lottieCtrl.isAnimating,
                  animate: lottieCtrl.isAnimating,
                  height: kToolbarHeight * 2,
                  fit: BoxFit.contain,
                ),
                onTap: () async {
                  if (!lottieCtrl.isAnimating) {
                    setState(() {
                      lottieCtrl.forward();
                    });
                    await openUserMedia(localRenderer: localRenderer, remoteRenderer: remoteRenderer).then((_) {
                      createOrJoinMeeting(channelId: widget.channelModel.id.toString()).then((_) => setState(() {}));
                    });
                  }
                  else {
                    setState(() {
                      lottieCtrl.stop();
                      //lottieCtrl.reset();
                    });
                    //hangUp(localRenderer: localRenderer, roomId: roomId).then((_) => setState(() {}));
                  }
                  log(lottieCtrl.isAnimating.toString(), name: "Status");
                },
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: RTCVideoView(localRenderer, mirror: true)),
                Expanded(child: RTCVideoView(remoteRenderer)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
