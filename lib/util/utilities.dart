import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';

import 'package:http/http.dart' as http;

import 'package:intl/intl.dart';

class Utilities {
//business
  static formatDateTime(String format, DateTime willBeFormatted) {
    // return DateFormat('yyyy-MM-dd – kk:mm').format(willBeFormatted);
    return DateFormat(format).format(willBeFormatted);
  }

  static String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

//Http Helper
  static Future<bool> checkResponse(http.Response response) async {
    if (response.statusCode == HttpStatus.ok) {
      return true;
    } else if (response.statusCode == HttpStatus.unauthorized ||
        response.statusCode == HttpStatus.badRequest)
      throw await new Future.error("You dont have permission to do that");
    else if (response.statusCode >= HttpStatus.internalServerError &&
        response.statusCode <= HttpStatus.networkAuthenticationRequired)
      throw await new Future.error(
          "Cannot reach server. Error Code: ${response.statusCode}");
    else
      throw await new Future.error("Error");
  }

  static getHeaders(String token) {
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };
  }
}
