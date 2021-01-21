import 'dart:convert';

import 'package:employeetracker/model/user.dart';
import 'package:employeetracker/model/vacation-request.dart';
import 'package:flutter/services.dart' show rootBundle;

class EmployeeService {
  Future<List<User>> getJson() async {
    var stringValue = await rootBundle.loadString('assets/user-data.json');

    var userList =
        (json.decode(stringValue)).map<User>((u) => User.fromJson(u)).toList();

    return userList;
  }

  Future<List<VacationRequest>> getVacationRequests() async {
    var stringValue =
        await rootBundle.loadString('assets/vacation-request-data.json');

    var vacationRequestList =
        (json.decode(stringValue)).map<VacationRequest>((u) => VacationRequest.fromJson(u)).toList();

    return vacationRequestList;
  }
}
