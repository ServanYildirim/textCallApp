
class ChannelModel {

  String? id;
  String? name;

  ChannelModel({
    this.id,
    this.name,
  });

  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    return ChannelModel(
      //id: json['id'], // Get from docRef
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    //data['id'] = id;
    data['name'] = name;
    return data;
  }
}