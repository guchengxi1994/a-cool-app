import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:codind/pages/login_page.dart';
import 'package:codind/router.dart';
import 'package:codind/utils/platform_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'bloc/my_blocs.dart';
import 'globals.dart';
import 'pages/_test_page.dart';
import 'pages/splash_page.dart';
import 'providers/my_providers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

    if (PlatformUtils.isMobile) {
      AwesomeNotifications().actionStream.listen((receivedNotification) {
        Global.navigatorKey.currentState!.pushNamedAndRemoveUntil(
            Routers.pageMain,
            (route) =>
                (route.settings.name != Routers.pageMain || route.isFirst));
      });
    }

    WidgetsBinding.instance!.addPostFrameCallback(
      (timeStamp) {
        if (widget.colorList != null) {
          Map<String, Color> savedColor = {
            "primaryColor": Color(int.parse(widget.colorList![0])),
            "primaryColorLight": Color(int.parse(widget.colorList![1])),
            "primaryColorDark": Color(int.parse(widget.colorList![2])),
            "bottomAppBarColor": Color(int.parse(widget.colorList![3])),
            "appBarColor": Color(int.parse(widget.colorList![4])),
          };
          context.read<ThemeController>().setThemeByMap(savedColor);
        }

        // somehow on web there is a null-value excepthon when using flutter_i18n,
        // so i add one second duration
        Future.delayed(const Duration(seconds: 1)).then((value) =>
            context.read<LanguageControllerV2>().changeLanguage(widget.lang!));
        // .then((value) {
        // AwesomeNotifications().createdStream.listen((event) {
        //   ScaffoldMessenger.of(Global.navigatorKey.currentContext!)
        //       .showSnackBar(
        //           SnackBar(content: Text("A notification created")));
        // });
        // });
      },
    );
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
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            return FlutterSmartDialog(
                child: FlutterI18n.rootAppBuilder().call(context, child));
          },
          // home: TestPage(
          //   routeName: "test page",
          // ),
          // home: LoginScreen(),
          home: SplashScreen(),
          navigatorObservers: [FlutterSmartDialog.observer],
          localizationsDelegates: [
            getI18n(context.watch<LanguageControllerV2>().currentLang),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
          navigatorKey: Global.navigatorKey,
        ));
  }
}

List<SingleChildWidget> getProviders() {
  return [
    ChangeNotifierProvider(
      create: (_) => EmojiController(),
    ),
    // ChangeNotifierProvider(
    //   create: (_) => ChangeBackgroundProvider(),
    // ),

    ChangeNotifierProvider(create: (_) => SplashPageScreenController()..init()),
    ChangeNotifierProvider(
      create: (_) => RadioProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => AngleController(),
    ),
    ChangeNotifierProvider(
      create: (_) => ExperienceController(),
    ),
    ChangeNotifierProvider(
      create: (_) => AvatarController(),
    ),
    ChangeNotifierProvider(
      create: (_) => LanguageControllerV2(),
    ),
    ChangeNotifierProvider(
      create: (_) => TodoPageScrollController(),
    ),
    ChangeNotifierProvider(
      create: (_) => MainPageCardController()..init(),
    ),
    ChangeNotifierProvider(
      create: (_) => TopicController()..init(),
    ),
    ChangeNotifierProvider(
      create: (_) => MultiImageUploadController()..init(),
    ),
    ChangeNotifierProvider(
      create: (_) => KnowledgeWidgetController(),
    ),
    ChangeNotifierProvider(
      create: (_) => KnowledgeController(),
    ),
  ];
}
