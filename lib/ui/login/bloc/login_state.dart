part of 'login_bloc.dart';

abstract class LoginState extends BaseState {
  const LoginState();
}

class InitLoginState extends LoginState {}

class ValidatedEmailLoginState extends LoginState {
  final String errorMessage;

  const ValidatedEmailLoginState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class ValidatedPasswordLoginState extends LoginState {
  final String errorMessage;

  const ValidatedPasswordLoginState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class LoadingLoginState extends LoginState {}

class LoginSucceedState extends LoginState {}

class ErrorLoginState extends LoginState {
  final String error;

  ErrorLoginState(this.error);

  @override
  List<Object> get props => [error];
}
