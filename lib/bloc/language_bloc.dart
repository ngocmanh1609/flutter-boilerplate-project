import 'package:bloc_provider/bloc_provider.dart';
import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/models/language/Language.dart';
import 'package:rxdart/rxdart.dart';

class LanguageBloc implements Bloc {
  // repository instance
  final Repository _repository;

  // supported languages
  List<Language> supportedLanguages = [
    Language(code: 'US', locale: 'en', language: 'English'),
    Language(code: 'DK', locale: 'da', language: 'Danish'),
    Language(code: 'ES', locale: 'es', language: 'España'),
  ];

  final _locale = BehaviorSubject<String>.seeded("en");

  ValueStream<String> get locale => _locale;
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

  LanguageBloc(this._repository) {
    init();
  }

  // general:-------------------------------------------------------------------
  void init() async {
    // getting current language from shared preference
    _repository?.currentLanguage?.then((locale) {
      if (locale != null) {
        _locale.add(locale);
      }
    });
  }

  void changeLanguage(String value) {
    _locale.add(value);
    _repository.changeLanguage(value).then((_) {
      // write additional logic here
    });
  }

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
