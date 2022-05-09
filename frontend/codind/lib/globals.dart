/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-03-22 21:47:48
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-05-09 21:41:52
 */
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/loaders/decoders/yaml_decode_strategy.dart';
import 'package:url_launcher/url_launcher.dart';

import 'utils/toast_utils.dart';

// ignore: constant_identifier_names
const AppVersion = "1.0.0-frontend-alpha+8";

// ignore: constant_identifier_names
const AppName = "助手";

FlutterI18nDelegate getI18n(String lang) {
  FlutterI18nDelegate flutterI18nDelegate = FlutterI18nDelegate(
    translationLoader: FileTranslationLoader(
        decodeStrategies: [YamlDecodeStrategy()],
        useCountryCode: false,
        fallbackFile: lang,
        basePath: 'assets/i18n',
        forcedLocale: Locale(lang)),
  );
  return flutterI18nDelegate;
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

/// https://stackoverflow.com/questions/69154468/horizontal-listview-not-scrolling-on-web-but-scrolling-on-mobile
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

void launchURL(String _url) async {
  if (!await launch(_url)) {
    showToastMessage("cannot launch url", null);
  }
}

const knowLedgebasePath = "knowledge.db";
const todosBasePath = "todo.db";
const fileBasePath = "file.db";
