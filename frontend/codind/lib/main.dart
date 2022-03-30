/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-01-30 21:46:56
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-03-22 22:05:49
 */
import 'package:codind/pages/login_page.dart';
import 'package:codind/pages/resume_page.dart';
import 'package:codind/utils/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'bloc/my_blocs.dart';
import 'globals.dart';
import 'pages/main_page_v2.dart';
import 'pages/pages.dart' show MainPage;
import 'providers/my_providers.dart';
import 'package:provider/provider.dart';

import 'widgets/mobile_widgets/qr_scanner_widget.dart';

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
              ChangeNotifierProvider(
                create: (_) => AngleController(),
              ),
            ],
            child: MyApp(
              colorList: ls,
            ),
          ))),
      blocObserver: SimpleBlocObserver());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, this.colorList}) : super(key: key);
  // final FlutterI18nDelegate flutterI18nDelegate;
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
    // final FlutterI18nBuilder = FlutterI18n.rootAppBuilder();
    // final FlutterSmartDialog = FlutterSmartDialog.init();

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
          builder: (context, child) {
            return FlutterSmartDialog(
                child: FlutterI18n.rootAppBuilder().call(context, child));
          },
          // home: const MainPage(),
          navigatorObservers: [FlutterSmartDialog.observer],
          home: ResumePage(),
          localizationsDelegates: [
            flutterI18nDelegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
          navigatorKey: Global.navigatorKey,
        ));
  }
}
