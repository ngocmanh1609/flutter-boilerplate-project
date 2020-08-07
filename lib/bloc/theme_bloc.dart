import 'package:bloc_provider/bloc_provider.dart';
import 'package:boilerplate/data/repository.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class ThemeBloc implements Bloc {
  final Repository _repository;

  ThemeBloc(this._repository) {
    _init();
  }

  final _darkMode = BehaviorSubject<bool>.seeded(false);

  ValueStream<bool> get darkMode => _darkMode;

  _init() async {
    _darkMode.add(await _repository?.isDarkMode ?? false);
  }

  Future changeBrightnessToDark(bool value) async {
    _darkMode.add(value);
    await _repository.changeBrightnessToDark(value);
  }

  bool isPlatformDark(BuildContext context) =>
      MediaQuery.platformBrightnessOf(context) == Brightness.dark;

  @override
  void dispose() {
    _darkMode.close();
  }
}
