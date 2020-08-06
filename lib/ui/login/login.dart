import 'package:boilerplate/ui/login/bloc/login_bloc.dart';
import 'package:boilerplate/constants/assets.dart';
import 'package:boilerplate/data/sharedpref/constants/preferences.dart';
import 'package:boilerplate/routes.dart';
import 'package:boilerplate/stores/theme/theme_store.dart';
import 'package:boilerplate/utils/device/device_utils.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:boilerplate/widgets/app_icon_widget.dart';
import 'package:boilerplate/widgets/empty_app_bar_widget.dart';
import 'package:boilerplate/widgets/progress_indicator_widget.dart';
import 'package:boilerplate/widgets/rounded_button_widget.dart';
import 'package:boilerplate/widgets/textfield_widget.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //text controllers:-----------------------------------------------------------
  TextEditingController _userEmailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  //stores:---------------------------------------------------------------------
  ThemeStore _themeStore;

  //focus node:-----------------------------------------------------------------
  FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeStore = Provider.of<ThemeStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      appBar: EmptyAppBar(),
      body: BlocProvider(
        create: (ctx) => LoginBloc(),
        child: _buildBody(),
      ),
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return BlocListener<LoginBloc, LoginState>(
      listener: (ctx, state) {
        if (state is LoginSucceedState) {
          _navigate(ctx);
        }
        if (state is ErrorLoginState) {
          _showErrorMessage(state.error);
        }
      },
      child: Material(
        child: Stack(
          children: <Widget>[
            MediaQuery.of(context).orientation == Orientation.landscape
                ? Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: _buildLeftSide(),
                      ),
                      Expanded(
                        flex: 1,
                        child: _buildRightSide(),
                      ),
                    ],
                  )
                : Center(child: _buildRightSide()),
            BlocBuilder<LoginBloc, LoginState>(
              builder: (ctx, state) {
                if (state is LoadingLoginState) {
                  return CustomProgressIndicatorWidget();
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftSide() {
    return SizedBox.expand(
      child: Image.asset(
        Assets.carBackground,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildRightSide() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AppIconWidget(image: 'assets/icons/ic_appicon.png'),
            SizedBox(height: 24.0),
            _buildUserIdField(),
            _buildPasswordField(),
            _buildForgotPasswordButton(),
            _buildSignInButton()
          ],
        ),
      ),
    );
  }

  Widget _buildUserIdField() {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => current is ValidatedEmailLoginState,
      builder: (ctx, state) => TextFieldWidget(
        hint: AppLocalizations.of(context).translate('login_et_user_email'),
        inputType: TextInputType.emailAddress,
        icon: Icons.person,
        iconColor: _themeStore.darkMode ? Colors.white70 : Colors.black54,
        textController: _userEmailController,
        inputAction: TextInputAction.next,
        onChanged: (value) {
          ctx
              .bloc<LoginBloc>()
              .add(EmailChanged(email: _userEmailController.text));
        },
        onFieldSubmitted: (value) {
          FocusScope.of(context).requestFocus(_passwordFocusNode);
        },
        errorText:
            state is ValidatedEmailLoginState ? state.errorMessage : null,
      ),
    );
  }

  Widget _buildPasswordField() {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => current is ValidatedPasswordLoginState,
      builder: (ctx, state) => TextFieldWidget(
        hint: AppLocalizations.of(context).translate('login_et_user_password'),
        isObscure: true,
        padding: EdgeInsets.only(top: 16.0),
        icon: Icons.lock,
        iconColor: _themeStore.darkMode ? Colors.white70 : Colors.black54,
        textController: _passwordController,
        focusNode: _passwordFocusNode,
        onChanged: (value) {
          ctx
              .bloc<LoginBloc>()
              .add(PasswordChanged(password: _passwordController.text));
        },
        errorText:
            state is ValidatedPasswordLoginState ? state.errorMessage : null,
      ),
    );
  }

  Widget _buildForgotPasswordButton() {
    return Align(
      alignment: FractionalOffset.centerRight,
      child: FlatButton(
        padding: EdgeInsets.all(0.0),
        child: Text(
          AppLocalizations.of(context).translate('login_btn_forgot_password'),
          style: Theme.of(context)
              .textTheme
              .caption
              .copyWith(color: Colors.orangeAccent),
        ),
        onPressed: () {},
      ),
    );
  }

  Widget _buildSignInButton() {
    return BlocBuilder<LoginBloc, LoginState>(
        builder: (ctx, state) => RoundedButtonWidget(
              buttonText:
                  AppLocalizations.of(context).translate('login_btn_sign_in'),
              buttonColor: Colors.orangeAccent,
              textColor: Colors.white,
              onPressed: () async {
                DeviceUtils.hideKeyboard(context);
                ctx.bloc<LoginBloc>().add(DoLoginEvent(
                    email: _userEmailController.text,
                    password: _passwordController.text));
              },
            ));
  }

  _navigate(BuildContext context) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool(Preferences.is_logged_in, true);
    });

    Future.delayed(Duration(milliseconds: 0), () {
      Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.home, (Route<dynamic> route) => false);
    });
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

  // dispose:-------------------------------------------------------------------
  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    _userEmailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
}
