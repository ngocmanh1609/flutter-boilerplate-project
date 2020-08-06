import 'dart:math';

import 'package:boilerplate/bloc/base/base_event.dart';
import 'package:boilerplate/bloc/base/base_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validators/validators.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(InitLoginState());

  @override
  void onTransition(Transition<LoginEvent, LoginState> transition) {
    print(transition);
    super.onTransition(transition);
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is EmailChanged) {
      yield* _onEmailChanged(event.email);
    } else if (event is PasswordChanged) {
      yield* _onPasswordChanged(event.password);
    } else if (event is DoLoginEvent) {
      yield* _login(event.email, event.password);
    }
  }

  Stream<LoginState> _onEmailChanged(String email) async* {
    yield ValidatedEmailLoginState(_getValidatedEmailError(email));
  }

  Stream<LoginState> _onPasswordChanged(String password) async* {
    yield ValidatedPasswordLoginState(_getValidatedPasswordError(password));
  }

  String _getValidatedEmailError(String email) {
    if (email.isEmpty) {
      return 'Email can\'t be empty.';
    } else if (!isEmail(email)) {
      return 'Please input correct email formatting!';
    } else {
      return null;
    }
  }

  String _getValidatedPasswordError(String password) {
    if (password.isEmpty) {
      return 'Password can\'t be empty.';
    } else if (password.length < 6) {
      return 'Password length must be at least 6 characters.';
    } else {
      return null;
    }
  }

  Stream<LoginState> _login(String email, String password) async* {
    String emailError = _getValidatedEmailError(email);
    String passwordError = _getValidatedPasswordError(password);
    if (emailError != null || passwordError != null) {
      yield ErrorLoginState('Please input email and password correctly.');
      return;
    }
    yield LoadingLoginState();
    await Future.delayed(Duration(milliseconds: 3000));
    yield LoginSucceedState();
  }
}
