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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:taichi/taichi.dart' show TaichiDevUtils;

import '_app.dart';
import 'globals.dart';

Future main() async {
  debugPrint(
      "use username= `test@xiaoshuyui.org.cn` &  password= `123456` to test");

  WidgetsFlutterBinding.ensureInitialized();

  // somehow on mobiles cannot access the avatar-generate-server
  if (TaichiDevUtils.isMobile) {
    HttpOverrides.global = MyHttpOverrides();
    ByteData data =
        await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
    SecurityContext.defaultContext
        .setTrustedCertificatesBytes(data.buffer.asUint8List());
    // AwesomeNotifications().initialize(
    //     'resource://drawable/icon',
    //     [
    //       NotificationChannel(
    //           channelKey: 'basic_channel',
    //           channelName: 'Basic notifications',
    //           channelDescription: 'Notification channel for basic tests',
    //           defaultColor: const Color(0xFF9D50DD),
    //           ledColor: Colors.white),
    //       NotificationChannel(
    //           channelKey: 'scheduled_channel',
    //           channelName: 'Scheduled notifications',
    //           defaultColor: Colors.teal,
    //           locked: true,
    //           importance: NotificationImportance.High,
    //           ledColor: Colors.white),
    //     ],
    //     debug: true);
  }

  runApp(MultiProvider(
    providers: getProviders(),
    child: const MyApp(
      lang: "zh_CN",
    ),
  ));
}
