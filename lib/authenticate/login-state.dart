import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class LoginState extends Equatable {
  LoginState([List props = const []]) : super();
}

class LoginInitial extends LoginState {
  @override
  String toString() => 'LoginInitial';

  @override
  // TODO: implement props
  List<Object> get props => props;
}

class LoginLoading extends LoginState {
  @override
  String toString() => 'LoginLoading';

  @override
  // TODO: implement props
  List<Object> get props => props;
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure({@required this.error}) : super([error]);

  @override
  // TODO: implement props
  List<Object> get props => props;
  @override
  String toString() => 'LoginFailure { error: $error }';
}
