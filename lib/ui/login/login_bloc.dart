import 'dart:async';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:rxdart/rxdart.dart';

import 'package:rxdart/subjects.dart';
import 'package:validators/validators.dart';

abstract class LoginBloc implements Bloc {
  ValueStream<String> get emailValidatedError;
  ValueStream<String> get passwordValidatedError;
  ValueStream<bool> get isLoading;
  ValueStream<bool> get loginSuccess;
  ValueStream<String> get error;

  void validateUserEmail(String value);

  void validatePassword(String value);

  void login(String email, String password);
}

class LoginBlocImpl extends LoginBloc {
  LoginBlocImpl();

  final _emailValidatedController = BehaviorSubject<String>();
  final _passwordValidatedController = BehaviorSubject<String>();
  final _isLoadingController = BehaviorSubject<bool>();
  final _loginSuccess = BehaviorSubject<bool>();
  final _error = BehaviorSubject<String>();

  StreamSubscription<bool> _loginSubscription;

  @override
  ValueStream<String> get emailValidatedError => _emailValidatedController;

  @override
  ValueStream<String> get passwordValidatedError =>
      _passwordValidatedController;

  @override
  ValueStream<bool> get isLoading => _isLoadingController;

  @override
  ValueStream<bool> get loginSuccess => _loginSuccess;

  @override
  ValueStream<String> get error => _error;

  @override
  void validateUserEmail(String value) {
    if (value.isEmpty) {
      _emailValidatedController.add("Email can't be empty");
    } else if (!isEmail(value)) {
      _emailValidatedController.add('Please enter a valid email address');
    } else {
      _emailValidatedController.add(null);
    }
  }

  @override
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

  @override
  void login(String email, String password) async {
    _isLoadingController.add(true);
    if (!_emailValidatedController.hasValue ||
        !_passwordValidatedController.hasValue) {
      _isLoadingController.add(false);
      _error.add("Please fill in email and password!");
      return;
    }
    _loginSubscription = await _emailValidatedController
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
    _loginSubscription.cancel();
  }

  @override
  void dispose() async {
    await _emailValidatedController.close();
    await _passwordValidatedController.close();
    await _isLoadingController.close();
    await _loginSuccess.close();
    await _error.close();
    await _loginSubscription?.cancel();
  }
}
