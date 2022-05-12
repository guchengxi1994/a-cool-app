// ignore_for_file: depend_on_referenced_packages

/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-01-30 21:46:56
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-03-22 22:05:49
 */
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:codind/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '_app.dart';
import 'bloc/my_blocs.dart';
import 'globals.dart';

Future main() async {
  debugPrint(
      "use username= `test@xiaoshuyui.org.cn` &  password= `123456` to test");

  // 获取 theme
  WidgetsFlutterBinding.ensureInitialized();

  // somehow on mobiles cannot access the avatar-generate-server
  if (PlatformUtils.isMobile) {
    HttpOverrides.global = MyHttpOverrides();
    ByteData data =
        await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
    SecurityContext.defaultContext
        .setTrustedCertificatesBytes(data.buffer.asUint8List());
    AwesomeNotifications().initialize(
        'resource://drawable/icon',
        [
          NotificationChannel(
              channelKey: 'basic_channel',
              channelName: 'Basic notifications',
              channelDescription: 'Notification channel for basic tests',
              defaultColor: const Color(0xFF9D50DD),
              ledColor: Colors.white),
          NotificationChannel(
              channelKey: 'scheduled_channel',
              channelName: 'Scheduled notifications',
              defaultColor: Colors.teal,
              locked: true,
              importance: NotificationImportance.High,
              ledColor: Colors.white),
        ],
        debug: true);
  }

  BlocOverrides.runZoned(
      (() => runApp(MultiProvider(
            providers: getProviders(),
            child: const MyApp(
              lang: "zh_CN",
            ),
          ))),
      blocObserver: SimpleBlocObserver());
}
