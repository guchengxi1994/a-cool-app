import 'package:codind/providers/my_providers.dart';
import 'package:codind/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

abstract class BasePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  BasePage({Key? key}) : super(key: key);

  @override
  BasePageState createState() {
    // ignore: no_logic_in_create_state
    return getState();
  }

  BasePageState getState();
}

class BasePageState<T extends BasePage> extends State<T> {
  List<Widget> actions = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      List<Widget> _actions = [
        PopupMenuButton<String>(
            tooltip: FlutterI18n.translate(context, "label.localization"),
            icon: Container(
              color: Colors.white,
              height: 20,
              width: 20,
              child: Image.asset("assets/icons/lan.png"),
            ),
            itemBuilder: (context) => <PopupMenuItem<String>>[
                  buildPopupMenuItem("中文"),
                  buildPopupMenuItem("English"),
                ]),
        IconButton(
            tooltip: FlutterI18n.translate(context, "label.settings"),
            onPressed: () {
              Navigator.pushNamed(context, Routers.pageSetting);
            },
            icon: Container(
              color: Colors.white,
              height: 20,
              width: 20,
              child: Image.asset("assets/icons/self_male.png"),
            ))
      ];

      addActions(_actions);
    });
  }

  addAction(Widget w) {
    setState(() {
      actions.add(w);
    });
  }

  addActions(List<Widget> ws) {
    setState(() {
      actions.addAll(ws);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: context.read<MenuController>().scaffoldKey,
      body: SafeArea(
        child: baseBuild(context),
      ),
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        // leading: Responsive.isRoughMobile(context)
        //     ? IconButton(
        //         onPressed: () {
        //           context.read<MenuController>().controlMenu();
        //         },
        //         icon: const Icon(Icons.menu))
        //     : null,
        actions: actions,
      ),
    );
  }

  PopupMenuItem<String> buildPopupMenuItem(String key) {
    return PopupMenuItem(
      child: Text(key),
      onTap: () async {
        String lang = reservedOptions[key]!;
        if (lang != context.read<LanguageController>().currentLang) {
          await context.read<LanguageController>().changeLanguage(lang);
          setState(() {});
        }
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void reassemble() {
    super.reassemble();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  void onCreate() {}
  void onDes() {}
  baseBuild(BuildContext context) {}
}
