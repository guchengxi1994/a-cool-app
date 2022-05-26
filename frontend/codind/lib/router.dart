/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-01-30 21:46:56
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-05-11 19:55:31
 */

import 'package:codind/pages/module_pages/card_friends_page.dart';
import 'package:codind/pages/login_page.dart';
import 'package:codind/pages/main_page_v2.dart';
import 'package:codind/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class Global {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();
}

class Routers {
  static const pageMain = '/pageMain';
  static const pageMdEditor = '/pageMdEditor';
  static const pageResumePage = "/resume";
  static const pageLogin = "/pageLogin";
  static const pageMobileSettingsPage = "/pageMobileSettingsPage";
  static const pageFriend = "/pageFriend";
  static const pageMine = "/pageMine";
  static const pageIntro = "/pageIntro";
  static const pageCalendar = "/pageCalendar";

  static final Map<String, WidgetBuilder> routers = {
    pageMain: (ctx) => MainPageV2(),
    // pageMdEditor: (context) => WritingPage(
    //       routeName: FlutterI18n.translate(context, "label.md"),
    //       needLoading: true,
    //     ),
    pageMdEditor: (context) => MarkdownMainPage(),
    pageResumePage: (context) => const ResumePage(),
    pageMobileSettingsPage: (context) => MobileMainSettingPage(
          pageName: FlutterI18n.translate(context, "label.settings"),
        ),
    pageFriend: (context) => const CardPageWithProvider(),
    pageLogin: (context) => const LoginScreen(),
    pageMine: (context) => MinePage(pageName: "我的"),
    pageIntro: (context) => const IntroductionAnimationScreen(),
    pageCalendar: (context) => const CalendarPage(),
  };
}
