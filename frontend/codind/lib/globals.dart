/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-03-22 21:47:48
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-04-09 20:43:27
 */
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/loaders/decoders/yaml_decode_strategy.dart';

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

// ignore: constant_identifier_names
const AppVersion = "1.0.0-frontend-alpha+2";

const leftBackIconSize = 35.0;

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
