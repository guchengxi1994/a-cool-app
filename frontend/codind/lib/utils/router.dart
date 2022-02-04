/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-01-30 21:46:56
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-02-04 09:21:43
 */

import 'package:codind/pages/pages.dart';
import 'package:flutter/material.dart';

class Global {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();
}

class Routers {
  static const pageSetting = 'pageSetting';
  static const pageMain = 'pageMain';
  static const pageMdEditor = 'pageMdEditor';

  static final Map<String, WidgetBuilder> routers = {
    pageSetting: (ctx) => const SettingPage(),
    pageMain: (ctx) => const MainPage(),
    pageMdEditor: (context) => WritingPage(),
  };
}
