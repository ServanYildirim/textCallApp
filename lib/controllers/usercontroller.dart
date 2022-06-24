import 'package:web_rtc_template/models/usermodel.dart';

class UserController {

  static UserModel? me;

  static UserModel servan = UserModel(
    userName: "servan",
    bio: "Sss",
    email: "prenez.sy@gmail.com",
    password: "123456",
    phone: "5456571471",
    birthDate: DateTime(2000, 01, 01),
  );

  static UserModel ercan = UserModel(
    userName: "ercan",
    bio: "Eee",
    email: "erci2000@gmail.com",
    password: "123456",
    phone: "5315201277",
    birthDate: DateTime(2000, 01, 01),
  );

}