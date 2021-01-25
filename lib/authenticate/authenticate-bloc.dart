import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:employeetracker/authenticate/authenticate-repository.dart';
import 'package:employeetracker/services/user-service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'authenticate-event.dart';
import 'authenticate-state.dart';

final storage = new FlutterSecureStorage();

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticateRepository authenticationRepository;
  var userService = UserService();

  AuthenticationBloc(this.authenticationRepository)
      : assert(authenticationRepository != null),
        super(AuthenticationUninitialized());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    yield AuthenticationLoading();

    try {
      await Future.delayed(Duration(milliseconds: 500)); // a simulated delay

      if (event is AppStarted) {
        final bool hasToken = await authenticationRepository
            .hasToken()
            .catchError((onError) => add(LoggedOut()));
        if (hasToken) {
          try {
            var user = await setUserWithStorageUserId();
            print("authenticate");
            yield AuthenticationAuthenticated(user: user);
          } catch (error) {
            add(LoggedOut());
          }
        } else {
          yield AuthenticationUnauthenticated();
        }
      }

      if (event is LoggedIn) {
        yield AuthenticationLoading();
        if (event.token != "" && event.token != null) {
          print(" is Logged IN +++++++++++");
          print("event token ${event.token}");
          await authenticationRepository.persistToken(event.token);
          var user = await setUserWithStorageUserId();
          yield AuthenticationAuthenticated(user: user);
        } else
          yield AuthenticationUnauthenticated();
      }

      if (event is LoggedOut) {
        yield AuthenticationLoading();
        await authenticationRepository.deleteToken();
        yield AuthenticationUnauthenticated();
      }
    } catch (e) {
      yield AuthenticationFailure(
          message: e.message ?? 'An unknown error occurred');
    }
  }

  Future setUserWithStorageUserId() async {
    var user = await UserService.user;
    print(user.firstName);
    return user;
  }
}
