import 'package:bloc_provider/bloc_provider.dart';
import 'package:boilerplate/bloc/language_bloc.dart';
import 'package:boilerplate/bloc/theme_bloc.dart';
import 'package:boilerplate/constants/app_theme.dart';
import 'package:boilerplate/constants/strings.dart';
import 'package:boilerplate/di/components/app_component.dart';
import 'package:boilerplate/di/modules/local_module.dart';
import 'package:boilerplate/di/modules/netwok_module.dart';
import 'package:boilerplate/di/modules/preference_module.dart';
import 'package:boilerplate/routes.dart';
import 'package:boilerplate/ui/splash/splash.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:inject/inject.dart';

// global instance for app component
AppComponent appComponent;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]).then((_) async {
    appComponent = await AppComponent.create(
      NetworkModule(),
      LocalModule(),
      PreferenceModule(),
    );
    runApp(appComponent.app);
  });
}

@provide
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  // Create your store as a final variable in a base Widget. This works better
  // with Hot Reload than creating it directly in the `build` function.
  final _themeBloc = ThemeBlocImpl(appComponent.getRepository());
  final _languageBloc = LanguageBlocImpl(appComponent.getRepository());

  @override
  Widget build(BuildContext context) {
    return BlocProviderTree(
      blocProviders: [
        BlocProvider<ThemeBloc>(
          creator: (context, bag) => _themeBloc,
        ),
        BlocProvider<LanguageBloc>(
          creator: (context, bag) => _languageBloc,
        ),
      ],
      child: StreamBuilder(
        stream: _themeBloc.darkMode,
        initialData: false,
        builder: (_, themeSnapshot) => StreamBuilder(
            stream: _languageBloc.locale,
            initialData: "en",
            builder: (_, languageSnapshot) => MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: Strings.appName,
                  theme: themeSnapshot.data ? themeDataDark : themeData,
                  routes: Routes.routes,
                  locale: Locale(languageSnapshot.data),
                  supportedLocales: _languageBloc.supportedLanguages
                      .map((language) => Locale(language.locale, language.code))
                      .toList(),
                  localizationsDelegates: [
                    // A class which loads the translations from JSON files
                    AppLocalizations.delegate,
                    // Built-in localization of basic text for Material widgets
                    GlobalMaterialLocalizations.delegate,
                    // Built-in localization for text direction LTR/RTL
                    GlobalWidgetsLocalizations.delegate,
                    // Built-in localization of basic text for Cupertino widgets
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  home: SplashScreen(),
                )),
      ),
    );
  }
}
