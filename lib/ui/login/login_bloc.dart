import 'dart:async';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:rxdart/rxdart.dart';

import 'package:rxdart/subjects.dart';
import 'package:validators/validators.dart';

class LoginBloc implements Bloc {
  LoginBloc();
  final _emailValidatedController = BehaviorSubject<String>();
  final _passwordValidatedController = BehaviorSubject<String>();
  final _isLoadingController = BehaviorSubject<bool>();
  final _loginSuccess = BehaviorSubject<bool>();
  final _error = BehaviorSubject<String>();

  StreamSubscription loginSubscription;

  ValueStream<String> get emailValidatedError => _emailValidatedController;
  ValueStream<String> get passwordValidatedError =>
      _passwordValidatedController;
  ValueStream<bool> get isLoading => _isLoadingController;
  ValueStream<bool> get loginSuccess => _loginSuccess;
  ValueStream<String> get error => _error;

  void validateUserEmail(String value) {
    if (value.isEmpty) {
      _emailValidatedController.add("Email can't be empty");
    } else if (!isEmail(value)) {
      _emailValidatedController.add('Please enter a valid email address');
    } else {
      _emailValidatedController.add(null);
    }
  }

  void validatePassword(String value) {
    if (value.isEmpty) {
      _passwordValidatedController.add("Password can't be empty");
    } else if (value.length < 6) {
      _passwordValidatedController
          .add("Password must be at-least 6 characters long");
    } else {
      _passwordValidatedController.add(null);
    }
  }

  void login(String email, String password) async {
    _isLoadingController.add(true);
    if (!_emailValidatedController.hasValue ||
        !_passwordValidatedController.hasValue) {
      _isLoadingController.add(false);
      _error.add("Please fill in email and password!");
      return;
    }
    loginSubscription = await _emailValidatedController
        .zipWith(_passwordValidatedController, (emailError, passwordError) {
      return emailError == null && passwordError == null;
    }).listen((validated) async {
      if (validated) {
        await Future.delayed(Duration(seconds: 3));
        _isLoadingController.add(false);
        _loginSuccess.add(true);
      } else {
        _isLoadingController.add(false);
        _error.add("Please input email and password correctly!");
      }
    });
    loginSubscription.cancel();
  }

  @override
  void dispose() async {
    await _emailValidatedController.close();
    await _passwordValidatedController.close();
    await _isLoadingController.close();
    await _loginSuccess.close();
    await _error.close();
    await loginSubscription?.cancel();
  }
}
