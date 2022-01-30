import 'package:codind/pages/_color_setting_page.dart';
import 'package:codind/pages/pages.dart';
import 'package:flutter/material.dart';

class Global {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();
}

class Routers {
  static const pageSetting = 'pageSetting';
  static const pageMain = 'pageMain';

  static final Map<String, WidgetBuilder> routers = {
    pageSetting: (ctx) => ColorSettingPage(),
    pageMain: (ctx) => const MainPage(),
  };
}
