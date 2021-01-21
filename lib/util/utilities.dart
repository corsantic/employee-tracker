import 'package:intl/intl.dart';

class Utilities {
  static formatDateTime(String format, DateTime willBeFormatted) {
    // return DateFormat('yyyy-MM-dd – kk:mm').format(willBeFormatted);
    return DateFormat(format).format(willBeFormatted);
  }
}
