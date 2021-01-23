import 'package:employeetracker/model/user.dart';

class UserService {
  static User _user;

  static User get user {
    return _user;
  }

  static setUser(user) {
    _user = user;
  }
}
