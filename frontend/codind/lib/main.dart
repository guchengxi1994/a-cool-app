/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-01-30 21:46:56
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-02-02 17:31:16
 */
import 'package:codind/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'pages/pages.dart';
import 'providers/my_providers.dart';
import 'package:provider/provider.dart';

Future main() async {
  final FlutterI18nDelegate flutterI18nDelegate = FlutterI18nDelegate(
    translationLoader: FileTranslationLoader(
        useCountryCode: false,
        fallbackFile: 'zh_CN',
        basePath: 'assets/i18n',
        forcedLocale: const Locale('zh_CN')),
  );
  // 获取 theme

  WidgetsFlutterBinding.ensureInitialized();
  StorageUtil _storageUtil = StorageUtil.storageInstance;
  List<String>? ls = await _storageUtil.getColorData();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeController()),
      ChangeNotifierProvider(
        create: (_) => MenuController(),
      ),
    ],
    child: MyApp(
      flutterI18nDelegate: flutterI18nDelegate,
      colorList: ls,
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, required this.flutterI18nDelegate, this.colorList})
      : super(key: key);
  final FlutterI18nDelegate flutterI18nDelegate;
  final List<String>? colorList;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    if (widget.colorList != null) {
      Map<String, Color> savedColor = {
        "primaryColor": Color(int.parse(widget.colorList![0])),
        "primaryColorLight": Color(int.parse(widget.colorList![1])),
        "primaryColorDark": Color(int.parse(widget.colorList![2])),
        "bottomAppBarColor": Color(int.parse(widget.colorList![3])),
        "appBarColor": Color(int.parse(widget.colorList![4])),
      };

      WidgetsBinding.instance!.addPostFrameCallback(
        (timeStamp) {
          context.read<ThemeController>().setThemeByMap(savedColor);
        },
      );

      // Future.delayed(Duration.zero).then((value) {
      //       context.read<ThemeController>().setThemeByMap(savedColor);
      //     });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: Routers.routers,
      theme: context.watch<ThemeController>().themeData,
      debugShowCheckedModeBanner: false,
      builder: FlutterI18n.rootAppBuilder(),
      home: const MainPage(),
      localizationsDelegates: [
        widget.flutterI18nDelegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
    );
  }
}
