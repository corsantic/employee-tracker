import 'package:employeetracker/authenticate/authenticate-bloc.dart';
import 'package:employeetracker/authenticate/authenticate-repository.dart';
import 'package:employeetracker/authenticate/login-bloc.dart';
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
  LoginBloc _loginBloc;
  AuthenticationBloc _authenticationBloc;

  AuthenticateRepository get _authenticateRepository =>
      widget.authenticateRepository;

  @override
  void initState() {
    _authenticationBloc =
        AuthenticationBloc(authenticationRepository: _authenticateRepository);
    _loginBloc = LoginBloc(
      authenticateRepository: _authenticateRepository,
      authenticationBloc: _authenticationBloc,
    );
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
      body: LoginForm(
        authenticationBloc: _authenticationBloc,
        loginBloc: _loginBloc,
      ),
    );
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }
}
