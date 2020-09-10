import 'package:bloc_provider/bloc_provider.dart';
import 'package:boilerplate/bloc/post_bloc.dart';
import 'package:boilerplate/main.dart';
import 'package:boilerplate/ui/login/login_bloc.dart';
import 'package:flutter/material.dart';

import 'ui/home/home.dart';
import 'ui/login/login.dart';
import 'ui/splash/splash.dart';

class Routes {
  Routes._();

  //static variables
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';

  static final routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => SplashScreen(),
    login: (BuildContext context) => BlocProvider<LoginBloc>(
          creator: (_, _bag) => LoginBlocImpl(),
          child: LoginScreen(),
        ),
    home: (BuildContext context) => BlocProvider<PostBloc>(
          creator: (_, _bag) => PostBlocImpl(appComponent.getRepository()),
          child: HomeScreen(),
        ),
  };
}
