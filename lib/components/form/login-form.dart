import 'package:employeetracker/authenticate/authenticate-bloc.dart';
import 'package:employeetracker/authenticate/login-bloc.dart';
import 'package:employeetracker/authenticate/login-event.dart';
import 'package:employeetracker/authenticate/login-state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginForm extends StatefulWidget {
  final LoginBloc loginBloc;
  final AuthenticationBloc authenticationBloc;

  LoginForm({
    Key key,
    @required this.loginBloc,
    @required this.authenticationBloc,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  var usernameValid = false;
  var passwordValid = false;

  bool loginValid = false;
  LoginBloc get _loginBloc => widget.loginBloc;

  @override
  Widget build(BuildContext context) {
    final logoWidth = MediaQuery.of(context).size.width / 4;
    final logo = Hero(
        tag: 'EmployeeControl',
        child: CircleAvatar(
          backgroundColor:
              Colors.white, // ThemeService.StorexpressColors.light[900],
          radius: 50.0,
          child: IconButton(
            // onPressed: () {},
            iconSize: logoWidth,
            icon: Icon(Icons.ac_unit_sharp),
            onPressed: () {},
          ),
        ));

    return BlocBuilder<LoginEvent, LoginState>(
      bloc: _loginBloc,
      builder: (
        BuildContext context,
        LoginState state,
      ) {
        if (state is LoginFailure) {
          _onWidgetDidBuild(() {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          });
        }
        return Card(
            elevation: 2.0,
            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
            child: Container(
                height: (MediaQuery.of(context).size.height) / 2,
                decoration: BoxDecoration(
                    // color: ThemeService.StorexpressColors.light[50],
                    borderRadius: new BorderRadius.circular(3.0)),
                child: Form(
                  onChanged: () => checkControllers(),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 0.0),
                          child: logo,
                        ),
                        TextFormField(
                          autofocus: true,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.email,
                            ),
                            //                          icon: Icon(Icons.email,
                            //                              color: Theme.of(context).primaryColor),
                            labelText: 'email',
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 4.0, 20.0, 4.0),
                          ),
                          // ignore: missing_return
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Lütfen alanı doldurunuz";
                            }
                          },
                          controller: _usernameController,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'şifre',
                            prefixIcon: Icon(
                              Icons.lock,
                            ),
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 4.0, 20.0, 4.0),
                          ),
                          // ignore: missing_return
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Lütfen alanı doldurunuz";
                            }
                          },
                          controller: _passwordController,
                          obscureText: true,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            // GestureDetector(
                            //   child: Text(
                            //     "Şifremi Unuttum",
                            //     style: TextStyle(
                            //         decoration: TextDecoration.underline,
                            //         decorationStyle: TextDecorationStyle.solid),
                            //   ),
                            //   onTap: () {
                            //     Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //           builder: (context) => ForgotPasswordPage(
                            //             title: "Şifremi Unuttum",
                            //           ),
                            //         ));
                            //   },
                            // ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: RaisedButton(
                                    onPressed: loginValid
                                        ? state is! LoginLoading
                                            ? _onLoginButtonPressed
                                            : null
                                        : null,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 0, 8.0, 0),
                                            child: state is LoginLoading
                                                ? new SizedBox(
                                                    width: 16.0,
                                                    height: 16.0,
                                                    child:
                                                        new CircularProgressIndicator(
                                                      backgroundColor:
                                                          Colors.blue,
                                                    ))
                                                : Icon(
                                                    Icons.save,
                                                  ),
                                          ),
                                          (Text(
                                            'Giriş',
                                          ))
                                        ]),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    )),
                              ),
                            ),
                          ],
                        ),
                        // Container(
                        //   child: state is LoginLoading
                        //       ? new SizedBox(
                        //           width: 128.0,
                        //           height: 5.0,
                        //           child: new LinearProgressIndicator(
                        //             backgroundColor: ThemeService
                        //                 .StorexpressColors.dark[900],
                        //           ))
                        //       : null,
                        // ),
                        SizedBox(
                            height: MediaQuery.of(context).viewInsets.bottom),
                      ],
                    ),
                  ),
                )));
      },
    );
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  void checkControllers() {
    setState(() {
      if (_usernameController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty) {
        loginValid = true;
      } else {
        loginValid = false;
      }
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  _onLoginButtonPressed() {
    FocusScope.of(context).requestFocus(new FocusNode());
    _loginBloc.dispatch(LoginButtonPressed(
      username: _usernameController.text,
      password: _passwordController.text,
    ));
  }
}
