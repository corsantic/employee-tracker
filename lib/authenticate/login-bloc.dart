import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:employeetracker/authenticate/authenticate-repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'authenticate-bloc.dart';
import 'authenticate-event.dart';
import 'login-event.dart';
import 'login-state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticateRepository authenticateRepository;
  final AuthenticationBloc authenticationBloc;
  final storage = new FlutterSecureStorage();
  LoginBloc({
    @required this.authenticateRepository,
    @required this.authenticationBloc,
  })  : assert(authenticateRepository != null),
        assert(authenticationBloc != null);

  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();
      try {
        final token = await authenticateRepository.authenticate(
          password: event.password,
          username: event.username,
        );
        // var storeId =
        // var userId = await storage.read(key: "userId");
        //     await storeUserService.getStoreIdWithUserId(int.parse(userId),token);
        // print("storeId :  $storeId");
        // storage.write(key: 'storeId', value: storeId.toString());

        authenticationBloc.dispatch(LoggedIn(token: token));
        yield LoginInitial();
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
  }
}
