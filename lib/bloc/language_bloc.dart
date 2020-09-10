import 'package:bloc_provider/bloc_provider.dart';
import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/models/language/Language.dart';
import 'package:rxdart/rxdart.dart';

abstract class LanguageBloc implements Bloc {
  List<Language> supportedLanguages;
  ValueStream<String> get locale;
  ValueStream<String> get code;

  void changeLanguage(String value);
  String getLanguage();
}

class LanguageBlocImpl extends LanguageBloc {
  // repository instance
  final Repository _repository;

  LanguageBlocImpl(this._repository) {
    _init();
  }

  // supported languages
  @override
  List<Language> supportedLanguages = [
    Language(code: 'US', locale: 'en', language: 'English'),
    Language(code: 'DK', locale: 'da', language: 'Danish'),
    Language(code: 'ES', locale: 'es', language: 'España'),
  ];

  final _locale = BehaviorSubject<String>.seeded("en");

  @override
  ValueStream<String> get locale => _locale;

  @override
  ValueStream<String> get code => _locale.map((locale) {
        String code;
        if (locale == 'en') {
          code = "US";
        } else if (locale == 'da') {
          code = "DK";
        } else if (locale == 'es') {
          code = "ES";
        }
        return code;
      });

  // general:-------------------------------------------------------------------
  void _init() async {
    // getting current language from shared preference
    _repository?.currentLanguage?.then((locale) {
      if (locale != null) {
        _locale.add(locale);
      }
    });
  }

  @override
  void changeLanguage(String value) {
    _locale.add(value);
    _repository.changeLanguage(value).then((_) {
      // write additional logic here
    });
  }

  @override
  String getLanguage() {
    return supportedLanguages[supportedLanguages
            .indexWhere((language) => language.locale == _locale.value)]
        .language;
  }

  @override
  void dispose() {
    _locale.close();
  }
}
