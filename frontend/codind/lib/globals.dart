/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-03-22 21:47:48
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-03-22 21:47:48
 */
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/loaders/decoders/yaml_decode_strategy.dart';

final FlutterI18nDelegate flutterI18nDelegate = FlutterI18nDelegate(
  translationLoader: FileTranslationLoader(
      decodeStrategies: [YamlDecodeStrategy()],
      useCountryCode: false,
      fallbackFile: 'zh_CN',
      basePath: 'assets/i18n',
      forcedLocale: const Locale('zh_CN')),
);
