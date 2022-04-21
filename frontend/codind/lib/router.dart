/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-01-30 21:46:56
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-04-13 21:36:36
 */

import 'package:codind/pages/card_page.dart';
import 'package:codind/pages/login_page.dart';
import 'package:codind/pages/main_page_v2.dart';
import 'package:codind/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class Global {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();
}

class Routers {
  // static const pageSetting = '/pageSetting';
  static const pageMain = '/pageMain';
  static const pageMdEditor = '/pageMdEditor';
  // static const pageFolder = '/pageFolder';
  static const pageSchedule = '/pageSchedule';
  // static const pageMdPreview = "/pageMdPreview";
  // static const pageSavedLinks = "/pageSavedLinks";
  // static const pageMindMap = "/pageMindMap";
  // static const pageYourAbilities = "/pageAbilities";
  static const pageResumePage = "/resume";
  static const pageLogin = "/pageLogin";
  // static const pageAvatarSettingPage = "/pageAvatarSettingPage";
  static const pageMobileSettingsPage = "/pageMobileSettingsPage";
  // static const pageAccountSafty = "/pageAccountSafety";
  static const pageFriend = "/pageFriend";
  static const pageMine = "/pageMine";

  static final Map<String, WidgetBuilder> routers = {
    // pageSetting: (ctx) => SettingPage(
    //       routeName: "setting",
    //     ),
    pageMain: (ctx) => MainPageV2(),
    pageMdEditor: (context) => WritingPage(
          routeName: FlutterI18n.translate(context, "label.md"),
          needLoading: true,
        ),
    // pageFolder: (context) => FileExplorePage(),
    pageSchedule: (context) => GanttPage(),
    // pageMdPreview: (context) => const BaseMarkdownPreviewPage(),
    // pageSavedLinks: (context) => SavedLinksPage(),
    // pageMindMap: (context) => MindMapPageV2(),
    // pageYourAbilities: (context) => YourAbilitiesPage(),
    pageResumePage: (context) => ResumePage(),
    // pageAvatarSettingPage: (context) => GenerateAvatarPage(),
    pageMobileSettingsPage: (context) => MobileMainSettingPage(
          pageName: FlutterI18n.translate(context, "label.settings"),
        ),
    // pageAccountSafty: (context) => AccountSafetyPage(),
    pageFriend: (context) => CardPage(),
    pageLogin: (context) => LoginScreen(),
    pageMine: (context) => MinePage(pageName: "我的"),
  };
}
