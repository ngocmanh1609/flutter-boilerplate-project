import 'package:bloc_provider/bloc_provider.dart';
import 'package:boilerplate/data/repository.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

abstract class ThemeBloc implements Bloc {
  ValueStream<bool> get darkMode;

  Future changeBrightnessToDark(bool value);

  bool isPlatformDark(BuildContext context);
}

class ThemeBlocImpl extends ThemeBloc {
  final Repository _repository;

  ThemeBlocImpl(this._repository) {
    _init();
  }

  final _darkMode = BehaviorSubject<bool>.seeded(false);

  @override
  ValueStream<bool> get darkMode => _darkMode;

  _init() async {
    _darkMode.add(await _repository?.isDarkMode ?? false);
  }

  @override
  Future changeBrightnessToDark(bool value) async {
    _darkMode.add(value);
    await _repository.changeBrightnessToDark(value);
  }

  @override
  bool isPlatformDark(BuildContext context) =>
      MediaQuery.platformBrightnessOf(context) == Brightness.dark;

  @override
  void dispose() {
    _darkMode.close();
  }
}
