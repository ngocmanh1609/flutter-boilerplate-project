import 'package:bloc_provider/bloc_provider.dart';
import 'package:boilerplate/bloc/language_bloc.dart';
import 'package:boilerplate/bloc/post_bloc.dart';
import 'package:boilerplate/bloc/theme_bloc.dart';
import 'package:boilerplate/data/sharedpref/constants/preferences.dart';
import 'package:boilerplate/models/post/post.dart';
import 'package:boilerplate/models/post/post_list.dart';
import 'package:boilerplate/routes.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:boilerplate/widgets/progress_indicator_widget.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:material_dialog/material_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //stores:---------------------------------------------------------------------
  ThemeBloc _themeBloc;
  PostBloc _postBloc;
  LanguageBloc _languageBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // initializing blocs
    _themeBloc = BlocProvider.of<ThemeBloc>(context);
    _postBloc = BlocProvider.of<PostBloc>(context);
    _languageBloc = BlocProvider.of<LanguageBloc>(context);

    _postBloc.getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  // app bar methods:-----------------------------------------------------------
  Widget _buildAppBar() {
    return AppBar(
      title: Text(AppLocalizations.of(context).translate('home_tv_posts')),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return <Widget>[
      _buildLanguageButton(),
      _buildThemeButton(),
      _buildLogoutButton(),
    ];
  }

  Widget _buildThemeButton() {
    return StreamBuilder<bool>(
      stream: _themeBloc.darkMode,
      builder: (context, snapshot) {
        return IconButton(
          onPressed: () {
            _themeBloc.changeBrightnessToDark(!snapshot.data);
          },
          icon: Icon(
            snapshot.data != null && snapshot.data
                ? Icons.brightness_5
                : Icons.brightness_3,
          ),
        );
      },
    );
  }

  Widget _buildLogoutButton() {
    return IconButton(
      onPressed: () {
        SharedPreferences.getInstance().then((preference) {
          preference.setBool(Preferences.is_logged_in, false);
          Navigator.of(context).pushReplacementNamed(Routes.login);
        });
      },
      icon: Icon(
        Icons.power_settings_new,
      ),
    );
  }

  Widget _buildLanguageButton() {
    return IconButton(
      onPressed: () {
        _buildLanguageDialog();
      },
      icon: Icon(
        Icons.language,
      ),
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        _handleErrorMessage(),
        _buildMainContent(),
      ],
    );
  }

  Widget _buildMainContent() {
    return StreamBuilder<bool>(
        stream: _postBloc.isLoading,
        builder: (context, snapshot) => snapshot.data != null && snapshot.data
            ? CustomProgressIndicatorWidget()
            : Material(child: _buildListView()));
  }

  Widget _buildListView() {
    return StreamBuilder<PostList>(
      stream: _postBloc.postList,
      builder: (context, snapshot) => snapshot.data != null
          ? ListView.separated(
              itemCount: snapshot.data.posts.length,
              separatorBuilder: (context, position) {
                return Divider();
              },
              itemBuilder: (context, position) {
                return _buildListItem(snapshot.data.posts[position]);
              },
            )
          : Center(
              child: Text(
                AppLocalizations.of(context).translate('home_tv_no_post_found'),
              ),
            ),
    );
  }

  Widget _buildListItem(Post post) {
    return ListTile(
      dense: true,
      leading: Icon(Icons.cloud_circle),
      title: Text(
        '${post.title}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        style: Theme.of(context).textTheme.title,
      ),
      subtitle: Text(
        '${post.body}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
      ),
    );
  }

  Widget _handleErrorMessage() {
    return StreamBuilder<String>(
      stream: _postBloc.error,
      builder: (context, snapshot) =>
          snapshot.data != null && snapshot.data.isNotEmpty
              ? _showErrorMessage(snapshot.data)
              : SizedBox.shrink(),
    );
  }

  // General Methods:-----------------------------------------------------------
  _showErrorMessage(String message) {
    Future.delayed(Duration(milliseconds: 0), () {
      if (message != null && message.isNotEmpty) {
        FlushbarHelper.createError(
          message: message,
          title: AppLocalizations.of(context).translate('home_tv_error'),
          duration: Duration(seconds: 3),
        )..show(context);
      }
    });

    return SizedBox.shrink();
  }

  _buildLanguageDialog() {
    _showDialog<String>(
      context: context,
      child: StreamBuilder(
        stream: _themeBloc.darkMode,
        builder: (ctx, snapshot) => MaterialDialog(
          borderRadius: 5.0,
          enableFullWidth: true,
          title: Text(
            AppLocalizations.of(context).translate('home_tv_choose_language'),
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
          headerColor: Theme.of(context).primaryColor,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          closeButtonColor: Colors.white,
          enableCloseButton: true,
          enableBackButton: false,
          onCloseButtonClicked: () {
            Navigator.of(context).pop();
          },
          children: _languageBloc.supportedLanguages
              .map(
                (object) => StreamBuilder<String>(
                  stream: _languageBloc.locale,
                  builder: (context, languageSnapshot) => ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.all(0.0),
                    title: Text(
                      object.language,
                      style: TextStyle(
                        color: languageSnapshot.data != null &&
                                languageSnapshot.data == object.locale
                            ? Theme.of(context).primaryColor
                            : snapshot.data != null && snapshot.data
                                ? Colors.white
                                : Colors.black,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      // change user language based on selected locale
                      _languageBloc.changeLanguage(object.locale);
                    },
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  _showDialog<T>({BuildContext context, Widget child}) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T value) {
      // The value passed to Navigator.pop() or null.
    });
  }
}
