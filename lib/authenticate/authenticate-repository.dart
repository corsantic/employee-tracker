import 'dart:convert';
import 'dart:io';

import 'package:employeetracker/model/user.dart';
import 'package:employeetracker/services/user-service.dart';
import 'package:employeetracker/util/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';

class AuthenticateRepository {
  final storage = new FlutterSecureStorage();
  Future<String> authenticate({
    @required String username,
    @required String password,
  }) async {
    var url = "${FlutterConfig.get('API_URL')}/User/authenticate";
    // "${config['host']}/${config['page']}${config['path']['user']}/${config['auth']}";
    print(url);

    password = Utilities.generateMd5(password);
    print("password: $password");

    // var connectivityResult = await (Connectivity().checkConnectivity());
    // if (connectivityResult == ConnectivityResult.none) {
    //   throw await new Future.error(
    //       "İnternetiniz kapalı. Lütfen kontrol ediniz");
    // }
    // await Helper.checkInternetConnectivity();
    final response = await http.post(
      url,
      body: json.encode({'userName': username, 'password': password}),
      headers: {"Content-Type": "application/json"},
    ).catchError((onError) async =>
        throw await new Future.error("Hata oluştu $onError"));

    if (response.statusCode == HttpStatus.ok) {
      var userId = json.decode(response.body)['id'];
      storage.write(key: 'userId', value: userId.toString());
      String token = json.decode(response.body)['token'];

      UserService.setUser(User.fromJson(json.decode(response.body)));
      print(UserService.user.email);

      return token;
    } else if (response.statusCode == HttpStatus.unauthorized ||
        response.statusCode == HttpStatus.badRequest)
      throw await new Future.error("Kullanıcı adı veya şifre hatalı");
    else if (response.statusCode >= HttpStatus.internalServerError &&
        response.statusCode <= HttpStatus.networkAuthenticationRequired)
      throw await new Future.error(
          "Sunucuya ulaşılamadı. Error Code: ${response.statusCode}");
    else
      throw await new Future.error("Error");
  }

  // Future<User> getUserWithToken(token) async {
  //   var url = "${config['host']}/${config['page']}${config['path']['user']}";

  //   final response = await http.post(url, headers: {
  //     "Content-Type": "application/json",
  //     "Authorization": "Bearer $token"
  //   }).catchError((onError) => throw onError);

  //   if (response.statusCode >= 200 && response.statusCode < 300) {
  //     User user = User.fromJson(json.decode(response.body));
  //     return user;
  //   } else {
  //     throw Exception('Failed to post get user');
  //   }
  // }

  Future<void> deleteToken() async {
    /// delete from keystore/keychain
    await storage.deleteAll();
    print('Deleting all from storage including token');
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<void> persistToken(String token) async {
    /// write to keystore/keychain

    await storage.write(key: 'access_token', value: token);

    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<bool> hasToken() async {
    /// read from keystore/keychain
    String token = await storage.read(key: 'access_token');
    if (token != null && token != "") {
      return true;
    } else
      return false;
  }
}
