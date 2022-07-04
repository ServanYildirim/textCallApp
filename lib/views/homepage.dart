import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_rtc_template/models/channelmodel.dart';
import 'package:web_rtc_template/services/channelservice.dart';
import 'package:web_rtc_template/views/callpage.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final ChannelService channelService = ChannelService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Channels"),
      ),
      body: FutureBuilder(
        future: channelService.getChannels(),
        builder: (ctx, AsyncSnapshot<List<ChannelModel>?> channelSnap) {
          if (!channelSnap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          else if (channelSnap.hasError) {
            return const Center(child: Text("An error occured."));
          }
          else {
            return ListView(
              shrinkWrap: true,
              children: channelSnap.data!.map((i) => Card(
                child: ListTile(
                  title: Text(i.name.toString()),
                  onTap: () => Get.to(CallPage(channelModel: i)),
                ),
              ),
              ).toList(),
            );
          }
        },
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
                    rtcService.openUserMedia(localVideo: localRenderer, remoteVideo: remoteRenderer);
                    setState(() {});
                  },
                  child: const Text("Open camera & microphone"),
                ),
                const SizedBox(
                  width: 8,
                ),
                ElevatedButton(
                  onPressed: () async {
                    roomId = await rtcService.createRoom(remoteRenderer: remoteRenderer);
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
                    rtcService.joinRoom(roomId: textEditingController.text, remoteVideo: remoteRenderer);
                    setState(() {});
                  },
                  child: const Text("Join room"),
                ),
                const SizedBox(
                  width: 8,
                ),
                ElevatedButton(
                  onPressed: () {
                    rtcService.hangUp(localVideo: localRenderer);
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
                  Expanded(child: RTCVideoView(localRenderer, mirror: true)),
                  Expanded(child: RTCVideoView(remoteRenderer)),
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
