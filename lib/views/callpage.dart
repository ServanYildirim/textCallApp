import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:lottie/lottie.dart';
import 'package:web_rtc_template/models/channelmodel.dart';
import 'package:web_rtc_template/services/meetingservice.dart';
import 'package:web_rtc_template/services/rtcservice.dart';
import 'package:web_rtc_template/services/userservice.dart';

class CallPage extends StatefulWidget {

  final ChannelModel channelModel;

  const CallPage({Key? key, required this.channelModel}) : super(key: key);

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> with TickerProviderStateMixin {

  final RtcService rtcService = RtcService();
  final UserService userService = UserService();
  final RTCVideoRenderer localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer remoteRenderer = RTCVideoRenderer();

  late final AnimationController lottieCtrl;

  @override
  void initState() {
    lottieCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        lottieCtrl.reverse();
      }

    });
    localRenderer.initialize();
    remoteRenderer.initialize();
    rtcService.onAddRemoteStream = ((stream) {
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
            icon: Icon(Icons.add),
            onPressed: () => MeetingService().createOrJoinMeeting(),
          ),
        ],
      ),
      body: Center(
        child: GestureDetector(
          child: Lottie.asset(
            "assets/lotties/videocall.json",
            repeat: lottieCtrl.isAnimating,
            animate: lottieCtrl.isAnimating,
            height: kToolbarHeight * 2,
            fit: BoxFit.contain,
          ),
          onTap: () {
            setState(() {
              if (!lottieCtrl.isAnimating) {
                lottieCtrl.forward();
              }
              else {
                lottieCtrl.stop();
                //lottieCtrl.reset();
              }
              log(lottieCtrl.isAnimating.toString(), name: "Status");
            });
          },
        ),
      ),
    );
  }
}
