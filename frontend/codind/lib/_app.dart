// ignore_for_file: depend_on_referenced_packages

import 'package:codind/router.dart';
import 'package:codind/utils/extensions/event_controller_extension.dart';
import 'package:codind/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:taichi/taichi.dart';
import 'globals.dart';
import 'pages/splash_page.dart';
import 'providers/my_providers.dart';
import 'package:provider/provider.dart';
import 'package:nested/nested.dart';
import 'providers/splash_page_provider.dart'
    if (dart.library.html) 'providers/splash_page_web_provider.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key, this.colorList, this.lang}) : super(key: key);
  // final getI18n flutterI18nDelegate;
  final List<String>? colorList;
  final String? lang;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // if (TaichiDevUtils.isMobile) {
    //   AwesomeNotifications().actionStream.listen((receivedNotification) {
    //     Global.navigatorKey.currentState!.pushNamedAndRemoveUntil(
    //         Routers.pageMain,
    //         (route) =>
    //             (route.settings.name != Routers.pageMain || route.isFirst));
    //   });
    // }

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        Future.delayed(const Duration(seconds: 1)).then((value) =>
            context.read<LanguageControllerV2>().changeLanguage(widget.lang!));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: !TaichiDevUtils.isMobile
          ? MyCustomScrollBehavior()
          : const MaterialScrollBehavior(),
      routes: Routers.routers,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        // child = TaichiFitnessUtil.rootBuilder(
        //         designHeight: 932, designWidth: 500)!
        //     .call(context, child);
        child = FlutterI18n.rootAppBuilder().call(context, child);
        return FlutterSmartDialog(child: child);
      },
      home: const SplashScreen(),
      navigatorObservers: [FlutterSmartDialog.observer],
      localizationsDelegates: [
        getI18n(context.watch<LanguageControllerV2>().currentLang),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      navigatorKey: Global.navigatorKey,
    );
  }
}

List<SingleChildWidget> getProviders() {
  return [
    ChangeNotifierProvider(
      create: (_) => EmojiController(),
    ),
    ChangeNotifierProvider(create: (_) => SplashPageScreenController()..init()),
    ChangeNotifierProvider(
      create: (_) => RadioProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => AngleController()..initThreshold(300.h),
    ),
    ChangeNotifierProvider(
      create: (_) => ExperienceController(),
    ),
    ChangeNotifierProvider(
      create: (_) => UserinfoController(),
    ),
    ChangeNotifierProvider(
      create: (_) => LanguageControllerV2(),
    ),
    ChangeNotifierProvider(
      create: (_) => MainPageCardController()..init(),
    ),
    ChangeNotifierProvider(
      create: (_) => KnowledgeController(),
    ),
    ChangeNotifierProvider(
      create: (_) => EventController()..init(),
    ),
  ];
}
