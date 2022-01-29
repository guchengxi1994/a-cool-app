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
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ThemeController()),
      ChangeNotifierProvider(
        create: (context) => MenuController(),
      )
    ],
    child: MyApp(
      flutterI18nDelegate: flutterI18nDelegate,
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.flutterI18nDelegate}) : super(key: key);
  final FlutterI18nDelegate flutterI18nDelegate;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: Routers.routers,
      theme: context.watch<ThemeController>().themeData,
      debugShowCheckedModeBanner: false,
      builder: FlutterI18n.rootAppBuilder(),
      home: const MainPage(),
      localizationsDelegates: [
        flutterI18nDelegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
    );
  }
}
