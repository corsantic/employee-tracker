import 'package:flutter/services.dart' show rootBundle;

class EmployeeService {
  Future<String> getJson() {
    return rootBundle.loadString('assets/data.json');
  }
}
