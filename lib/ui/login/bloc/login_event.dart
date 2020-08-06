part of 'login_bloc.dart';

abstract class LoginEvent extends BaseEvent {
  const LoginEvent();
}

class EmailChanged extends LoginEvent {
  final String email;

  const EmailChanged({@required this.email});
}

class PasswordChanged extends LoginEvent {
  final String password;

  const PasswordChanged({@required this.password});
}

class DoLoginEvent extends LoginEvent {
  final String email;
  final String password;

  const DoLoginEvent({@required this.email, @required this.password});
}
