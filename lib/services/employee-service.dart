import 'dart:convert';

import 'package:employeetracker/model/user.dart';
import 'package:employeetracker/model/vacation-request.dart';
import 'package:employeetracker/util/utilities.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class EmployeeService {
  final storage = new FlutterSecureStorage();
  Future<List<User>> getJson() async {
    var stringValue = await rootBundle.loadString('assets/user-data.json');

    var userList =
        (json.decode(stringValue)).map<User>((u) => User.fromJson(u)).toList();

    return userList;
  }

  Future<List<VacationRequest>> getVacationRequests() async {
    // var stringValue =
    //     await rootBundle.loadString('assets/vacation-request-data.json');
    var url = "${FlutterConfig.get('API_URL')}/Vacation";
    var token = await storage.read(key: 'access_token');

    final response = await http
        .get(url, headers: Utilities.getHeaders(token))
        .catchError(
            (onError) async => throw await Future.error("Error: $onError"));
    try {
      var isOk = await Utilities.checkResponse(response);
      if (isOk == true) {
        return mapRequest(response);
      }
      return null;
    } catch (e) {
      throw e;
    }
  }

  mapRequest(http.Response response) {
    var vacationRequestList = (json.decode(response.body))
        .map<VacationRequest>((u) => VacationRequest.fromJson(u))
        .toList();
    return vacationRequestList;
  }
}
