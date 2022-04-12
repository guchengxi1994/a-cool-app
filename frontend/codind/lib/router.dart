/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-01-30 21:46:56
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-02-10 22:05:59
 */

import 'package:codind/pages/card_page.dart';
import 'package:codind/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class Global {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();
}

class Routers {
  static const pageSetting = '/pageSetting';
  static const pageMain = '/pageMain';
  static const pageMdEditor = '/pageMdEditor';
  static const pageFolder = '/pageFolder';
  static const pageSchedule = '/pageSchedule';
  static const pageMdPreview = "/pageMdPreview";
  static const pageSavedLinks = "/pageSavedLinks";
  static const pageMindMap = "/pageMindMap";
  static const pageYourAbilities = "/pageAbilities";
  static const pageResumePage = "/resume";
  // static const pageAvatarSettingPage = "/pageAvatarSettingPage";
  static const pageMobileSettingsPage = "/pageMobileSettingsPage";
  // static const pageAccountSafty = "/pageAccountSafety";
  static const pageFriend = "/pageFriend";

  static final Map<String, WidgetBuilder> routers = {
    pageSetting: (ctx) => SettingPage(
          routeName: "setting",
        ),
    pageMain: (ctx) => const MainPage(),
    pageMdEditor: (context) => const WritingProviderPage(),
    pageFolder: (context) => FileExplorePage(),
    pageSchedule: (context) => GanttPage(),
    pageMdPreview: (context) => const BaseMarkdownPreviewPage(),
    pageSavedLinks: (context) => SavedLinksPage(),
    pageMindMap: (context) => MindMapPageV2(),
    pageYourAbilities: (context) => YourAbilitiesPage(),
    pageResumePage: (context) => ResumePage(),
    // pageAvatarSettingPage: (context) => GenerateAvatarPage(),
    pageMobileSettingsPage: (context) => MobileMainSettingPage(
          pageName: FlutterI18n.translate(context, "label.settings"),
        ),
    // pageAccountSafty: (context) => AccountSafetyPage(),
    pageFriend: (context) => CardPage(),
  };
}
