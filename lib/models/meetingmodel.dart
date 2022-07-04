
class MeetingModel {

  String? id;
  String? client1Id;
  String? client2Id;
  String? roomId;

  MeetingModel({
    this.id,
    this.client1Id,
    this.client2Id,
    this.roomId,
  });

  factory MeetingModel.fromJson(Map<String, dynamic> json) {
    return MeetingModel(
      //id: json['id'],
      client1Id: json['client1Id'],
      client2Id: json['client2Id'],
      roomId: json['roomId'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    //data['id'] = id;
    data['client1Id'] = client1Id;
    data['client2Id'] = client2Id;
    data['roomId'] = roomId;
    return data;
  }
}