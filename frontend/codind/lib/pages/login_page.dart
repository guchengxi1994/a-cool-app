/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-03-22 19:54:23
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-04-09 20:59:59
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_login/flutter_login.dart';
import '../utils/shared_preference_utils.dart';
import './main_page_v2.dart';
import 'package:codind/providers/my_providers.dart';
import 'package:provider/provider.dart';

// for test
const users = {
  'test@xiaoshuyui.org.cn': '123456',
};

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Duration get loginTime => const Duration(milliseconds: 2250);
  PersistenceStorage ps = PersistenceStorage();
  bool isOffline = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      var logdata = LoginData(
          name: await ps.getUserEmail(), password: await ps.getUserPassword());

      if (logdata.name != "" && logdata.password != "") {
        var res = await _authUser(logdata);
        if (res == null) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => MainPageV2(),
          ));
        }
      }

      debugPrint("[size]: ${MediaQuery.of(context).size}");
    });
  }

  Future<String?> _authUser(LoginData data) async {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) async {
      if (!users.containsKey(data.name)) {
        return 'User not exists';
      }
      if (users[data.name] != data.password) {
        return 'Password does not match';
      }

      await ps.setUserEmail(data.name);
      await ps.setUserPassword(data.password);

      return null;
    });
  }

  Future<String?> _signupUser(SignupData data) {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String?> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
        "[debug-i18n-state ]: ${context.read<LanguageControllerV2>().currentLang}");

    LoginMessages messages = LoginMessages(
      passwordHint: FlutterI18n.translate(context, "login-labels.PasswordHint"),
      confirmPasswordHint:
          FlutterI18n.translate(context, "login-labels.ConfirmPasswordHint"),
      forgotPasswordButton:
          FlutterI18n.translate(context, "login-labels.ForgotPasswordButton"),
      loginButton: FlutterI18n.translate(context, "login-labels.LoginButton"),
      signupButton: FlutterI18n.translate(context, "login-labels.SignupButton"),
      recoverPasswordButton:
          FlutterI18n.translate(context, "login-labels.RecoverPasswordButton"),
      recoverPasswordIntro:
          FlutterI18n.translate(context, "login-labels.RecoverPasswordIntro"),
      recoverPasswordDescription: FlutterI18n.translate(
          context, "login-labels.RecoverPasswordDescription"),
      recoverCodePasswordDescription: FlutterI18n.translate(
          context, "login-labels.RecoverCodePasswordDescription"),
      goBackButton: FlutterI18n.translate(context, "login-labels.GoBackButton"),
      confirmPasswordError:
          FlutterI18n.translate(context, "login-labels.ConfirmPasswordError"),
      recoverPasswordSuccess:
          FlutterI18n.translate(context, "login-labels.RecoverPasswordSuccess"),
      flushbarTitleSuccess:
          FlutterI18n.translate(context, "login-labels.flushbarTitleSuccess"),
      flushbarTitleError:
          FlutterI18n.translate(context, "login-labels.flushbarTitleError"),
      signUpSuccess:
          FlutterI18n.translate(context, "login-labels.SignUpSuccess"),
      providersTitleFirst:
          FlutterI18n.translate(context, "login-labels.ProvidersTitleFirst"),
      providersTitleSecond:
          FlutterI18n.translate(context, "login-labels.ProvidersTitleSecond"),
      additionalSignUpSubmitButton: FlutterI18n.translate(
          context, "login-labels.AdditionalSignUpSubmitButton"),
      additionalSignUpFormDescription: FlutterI18n.translate(
          context, "login-labels.AdditionalSignUpFormDescription"),
      confirmRecoverIntro:
          FlutterI18n.translate(context, "login-labels.ConfirmRecoverIntro"),
      recoveryCodeHint:
          FlutterI18n.translate(context, "login-labels.RecoveryCodeHint"),
      recoveryCodeValidationError: FlutterI18n.translate(
          context, "login-labels.RecoveryCodeValidationError"),
      setPasswordButton:
          FlutterI18n.translate(context, "login-labels.SetPasswordButton"),
      confirmRecoverSuccess:
          FlutterI18n.translate(context, "login-labels.ConfirmRecoverSuccess"),
      confirmSignupIntro:
          FlutterI18n.translate(context, "login-labels.ConfirmSignupIntro"),
      confirmationCodeHint:
          FlutterI18n.translate(context, "login-labels.ConfirmationCodeHint"),
      confirmationCodeValidationError: FlutterI18n.translate(
          context, "login-labels.ConfirmationCodeValidationError"),
      resendCodeButton:
          FlutterI18n.translate(context, "login-labels.ResendCodeButton"),
      resendCodeSuccess:
          FlutterI18n.translate(context, "login-labels.ResendCodeSuccess"),
      confirmSignupButton:
          FlutterI18n.translate(context, "login-labels.ConfirmSignupButton"),
      confirmSignupSuccess:
          FlutterI18n.translate(context, "login-labels.ConfirmSignupSuccess"),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          const Center(
            child: Text(
              "离线模式",
              style: TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          CupertinoSwitch(
              value: isOffline,
              onChanged: (v) {
                setState(() {
                  isOffline = v;
                });
              })
        ],
      ),
      body: FlutterLogin(
        messages: messages,
        // titleTag: "aaa",
        title: '随身助手',
        theme: LoginTheme(
            primaryColor: const Color.fromARGB(255, 223, 211, 195),
            buttonStyle: const TextStyle(color: Colors.black),
            switchAuthTextColor: const Color.fromARGB(255, 223, 211, 195)),
        logo: const AssetImage('assets/icon_no_background.png'),
        onLogin: _authUser,
        onSignup: _signupUser,
        onSubmitAnimationCompleted: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => MainPageV2(),
          ));
        },
        onRecoverPassword: _recoverPassword,
      ),
    );
  }
}
