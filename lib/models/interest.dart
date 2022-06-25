
class Interest {

  String? id;
  String? name;

  Interest({
    this.id,
    this.name,
  });

  factory Interest.fromJson(Map<String, dynamic> json) {
    return Interest(
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