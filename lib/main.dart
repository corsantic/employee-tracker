import 'package:bloc/bloc.dart';
import 'package:employeetracker/authenticate/authenticate-repository.dart';
import 'package:employeetracker/components/page/splash-page.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_config/flutter_config.dart';

import 'authenticate/authenticate-bloc.dart';
import 'authenticate/authenticate-event.dart';
import 'authenticate/authenticate-state.dart';
import 'components/page/home-page.dart';
import 'components/page/login-page.dart';

class MyApp extends BlocDelegate {
  @override
  void onTransition(Transition transition) {
    print(transition.toString());
  }
}

Future main() async {
  BlocSupervisor().delegate = MyApp();
  WidgetsFlutterBinding.ensureInitialized(); // Required by FlutterConfig
  await FlutterConfig.loadEnvVariables();
  FlutterConfig.variables.forEach((p, k) => print("${p}, ${k}"));

  runApp(App(authenticateRepository: AuthenticateRepository()));
}

class App extends StatefulWidget {
  final AuthenticateRepository authenticateRepository;

  App({Key key, @required this.authenticateRepository}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  AuthenticationBloc authenticationBloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  AuthenticateRepository get authenticationRepository =>
      widget.authenticateRepository;

  @override
  void initState() {
    authenticationBloc =
        AuthenticationBloc(authenticationRepository: authenticationRepository);
    authenticationBloc.dispatch(AppStarted());
    super.initState();
  }

  @override
  void dispose() {
    authenticationBloc.dispose();

    print("dispose main");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      bloc: authenticationBloc,
      child: MaterialApp(
        initialRoute: '/',
        home: new Scaffold(
          key: _scaffoldKey,
          body: new Container(
            child: new BlocBuilder<AuthenticationEvent, AuthenticationState>(
              bloc: authenticationBloc,
              builder: (BuildContext context, AuthenticationState state) {
                if (state is AuthenticationUninitialized) {
                  return Container(
                    child: Text("uninitialized"),
                  );
                }
                if (state is AuthenticationAuthenticated) {
                  return MyHomePage(
                    title: "Employee Control",
                  );
                }
                if (state is AuthenticationUnauthenticated) {
                  return LoginPage(
                      authenticateRepository: authenticationRepository);
                }
                if (state is AuthenticationLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                return SplashPage();
              },
            ),
          ),
        ),
      ),
    );
  }
}
