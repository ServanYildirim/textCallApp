
class UserModel {

  //String? id;
  String? userName;
  String? bio;
  String? email;
  String? password;
  String? phone;
  DateTime? birthDate;

  UserModel({
    //this.id,
    this.userName,
    this.bio,
    this.email,
    this.password,
    this.phone,
    this.birthDate,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      //id: json['id'],
      userName: json['userName'],
      bio: json['bio'],
      email: json['email'],
      password: json['password'],
      phone: json['phone'],
      birthDate: DateTime.fromMillisecondsSinceEpoch(json['birthDate'] * 1000),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    //data['id'] = id;
    data['userName'] = userName;
    data['bio'] = bio;
    data['email'] = email;
    data['password'] = password;
    data['phone'] = phone;
    data['birthDate'] = birthDate;
    return data;
  }
}