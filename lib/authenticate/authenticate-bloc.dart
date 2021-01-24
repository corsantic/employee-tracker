import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:employeetracker/authenticate/authenticate-repository.dart';
import 'package:employeetracker/services/user-service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

import 'authenticate-event.dart';
import 'authenticate-state.dart';

final storage = new FlutterSecureStorage();

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticateRepository authenticationRepository;
  var userService = UserService();

  AuthenticationBloc({@required this.authenticationRepository})
      : assert(authenticationRepository != null);

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      final bool hasToken = await authenticationRepository
          .hasToken()
          .catchError((onError) => dispatch(LoggedOut()));
      if (hasToken) {
        try {
          // await setUserWithStorageUserId();
          print("authenticate");
          yield AuthenticationAuthenticated();
        } catch (error) {
          dispatch(LoggedOut());
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
        // await setUserWithStorageUserId();

        yield AuthenticationAuthenticated();
      } else
        yield AuthenticationUnauthenticated();
    }

    if (event is LoggedOut) {
      yield AuthenticationLoading();
      await authenticationRepository.deleteToken();
      yield AuthenticationUnauthenticated();
    }
  }

  // Future setUserWithStorageUserId() async {
  //   var userId = int.parse(await storage.read(key: "userId"));
  //   await userService.setUser(userId).catchError((onError) => throw onError);
  // }
}
