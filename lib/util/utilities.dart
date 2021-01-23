import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:intl/intl.dart';

class Utilities {
  static formatDateTime(String format, DateTime willBeFormatted) {
    // return DateFormat('yyyy-MM-dd – kk:mm').format(willBeFormatted);
    return DateFormat(format).format(willBeFormatted);
  }

  static String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }
}
