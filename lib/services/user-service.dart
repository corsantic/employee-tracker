import 'dart:convert';

import 'package:employeetracker/model/user.dart';
import 'package:employeetracker/util/utilities.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

final storage = new FlutterSecureStorage();

class UserService {
  static User _user;

  static Future<User> get user async {
    if (_user == null) {
      setUser(await getUser());
    }
    return _user;
  }

  static setUser(user) {
    _user = user;
  }

  static getUser() async {
    var url = "${FlutterConfig.get('API_URL')}/User";
    var token = await storage.read(key: 'access_token');

    final response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    }).catchError((onError) => throw onError);

    try {
      var isOk = await Utilities.checkResponse(response);
      if (isOk == true) {
        User user = User.fromJson(json.decode(response.body));
        return user;
      }
      return null;
    } catch (e) {
      throw e;
    }
  }
}
