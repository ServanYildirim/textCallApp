import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_rtc_template/models/channelmodel.dart';

class ChannelService {

  final String channelColName = "channels";

  late final CollectionReference? channelRef = FirebaseFirestore.instance.collection(channelColName).withConverter<ChannelModel>(
    fromFirestore: (snapshot, _) => ChannelModel.fromJson(snapshot.data()!),
    toFirestore: (interest, _) => interest.toJson(),
  );

  Future<List<ChannelModel>?> getChannels() async {
    QuerySnapshot<Object?>? tempList = await channelRef?.get();
    return tempList?.docs.map((i) {
      log((i.data() as ChannelModel).name.toString(), name: i.id);
      return ChannelModel(
        id: i.id, // doc id
        name: (i.data() as ChannelModel).name,
      );
    }
    ).toList();
  }

  /*
  Future<void> setChannels() async {
    final List<String> channels = [
      "Game",
      "Sport",
      "Cars",
      "Fun",
      "News",
      "Software",
      "English",
      "Music",
      "Religion",
      "Friends with Benefits",
      "420 Friends",
      "Health",
      "Shopping",
      "Art",
      "Trip",
      "Science",
      "Book",
      "Friendship",
      "Crypto Currency",
      "Education",
      "Fashion",
      "Relationship",
      "Series & Movies"
      "Dance",
      "Food",
    ];
    for (String i in channels) {
      channelRef?.add(ChannelModel(name: i));
    }
  }
   */

}