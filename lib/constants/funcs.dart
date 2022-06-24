import 'package:intl/intl.dart';

class Funcs {

  static final DateFormat dateFormat = DateFormat("dd.MM.yyyy");

  static String convertDateTimeToString({required DateTime dateTime}) {
    return dateFormat.format(DateTime.parse(dateTime.toString()));
  }

}