import 'package:employeetracker/authenticate/authenticate-repository.dart';
import 'package:employeetracker/components/form/login-form.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final AuthenticateRepository authenticateRepository;

  LoginPage({Key key, @required this.authenticateRepository})
      : assert(authenticateRepository != null),
        super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
        ),
      ),
      body: LoginForm(authenticateRepository: widget.authenticateRepository),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
