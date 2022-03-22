/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-01-30 21:46:56
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-02-19 10:55:25
 */
import 'package:codind/utils/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/loaders/decoders/yaml_decode_strategy.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'bloc/my_blocs.dart';
import 'pages/main_page_v2.dart';
import 'pages/pages.dart' show MainPage;
import 'providers/my_providers.dart';
import 'package:provider/provider.dart';

/// https://stackoverflow.com/questions/69154468/horizontal-listview-not-scrolling-on-web-but-scrolling-on-mobile
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

Future main() async {
  final FlutterI18nDelegate flutterI18nDelegate = FlutterI18nDelegate(
    translationLoader: FileTranslationLoader(
        decodeStrategies: [YamlDecodeStrategy()],
        useCountryCode: false,
        fallbackFile: 'zh_CN',
        basePath: 'assets/i18n',
        forcedLocale: const Locale('zh_CN')),
  );
  // 获取 theme

  WidgetsFlutterBinding.ensureInitialized();
  // List<String>? ls = await spGetColorData();
  PersistenceStorage ps = PersistenceStorage();
  List<String>? ls = await ps.getColorData();

  BlocOverrides.runZoned(
      (() => runApp(MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => ThemeController()),
              ChangeNotifierProvider(create: (_) => MenuController()),
              ChangeNotifierProvider(
                create: (_) => EmojiController(),
              ),
              ChangeNotifierProvider(
                create: (_) => ChangeBackgroundProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => RadioProvider(),
              ),
            ],
            child: MyApp(
              flutterI18nDelegate: flutterI18nDelegate,
              colorList: ls,
            ),
          ))),
      blocObserver: SimpleBlocObserver());
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => GanttBloc()..add(InitialGanttEvent()),
          ),
          BlocProvider(
            create: (_) => SavedLinksBloc()..add(InitialSavedLinksEvent()),
          ),
          BlocProvider(
            create: (_) => MindMapBloc()..add(InitialMindMapEvent()),
          )
        ],
        child: MaterialApp(
          scrollBehavior: !PlatformUtils.isMobile
              ? MyCustomScrollBehavior()
              : const MaterialScrollBehavior(),
          routes: Routers.routers,
          theme: context.watch<ThemeController>().themeData,
          debugShowCheckedModeBanner: false,
          builder: FlutterI18n.rootAppBuilder(),
          // home: const MainPage(),
          home: MainPageV2(),
          localizationsDelegates: [
            widget.flutterI18nDelegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
          navigatorKey: Global.navigatorKey,
        ));
  }
}
