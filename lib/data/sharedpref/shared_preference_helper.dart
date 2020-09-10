import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/preferences.dart';

abstract class SharedPreferenceHelper {
  Future<String> get authToken;

  Future<bool> get isLoggedIn;

  Future<bool> get isDarkMode;

  Future<String> get currentLanguage;

  Future<void> saveAuthToken(String authToken);

  Future<void> removeAuthToken();

  Future<void> changeBrightnessToDark(bool value);

  Future<void> changeLanguage(String language);
}

class SharedPreferenceHelperImpl extends SharedPreferenceHelper {
  // shared pref instance
  final Future<SharedPreferences> _sharedPreference;

  // constructor
  SharedPreferenceHelperImpl(this._sharedPreference);

  // General Methods: ----------------------------------------------------------
  @override
  Future<String> get authToken async {
    return _sharedPreference.then((preference) {
      return preference.getString(Preferences.auth_token);
    });
  }

  @override
  Future<void> saveAuthToken(String authToken) async {
    return _sharedPreference.then((preference) {
      preference.setString(Preferences.auth_token, authToken);
    });
  }

  @override
  Future<void> removeAuthToken() async {
    return _sharedPreference.then((preference) {
      preference.remove(Preferences.auth_token);
    });
  }

  @override
  Future<bool> get isLoggedIn async {
    return _sharedPreference.then((preference) {
      return preference.getString(Preferences.auth_token) ?? false;
    });
  }

  // Theme:------------------------------------------------------
  @override
  Future<bool> get isDarkMode {
    return _sharedPreference.then((prefs) {
      return prefs.getBool(Preferences.is_dark_mode) ?? false;
    });
  }

  @override
  Future<void> changeBrightnessToDark(bool value) {
    return _sharedPreference.then((prefs) {
      return prefs.setBool(Preferences.is_dark_mode, value);
    });
  }

  // Language:---------------------------------------------------
  @override
  Future<String> get currentLanguage {
    return _sharedPreference.then((prefs) {
      return prefs.getString(Preferences.current_language);
    });
  }

  @override
  Future<void> changeLanguage(String language) {
    return _sharedPreference.then((prefs) {
      return prefs.setString(Preferences.current_language, language);
    });
  }
}
