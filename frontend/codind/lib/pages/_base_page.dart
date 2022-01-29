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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: baseBuild(context),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: !Responsive.isDesktop(context)
            ? IconButton(
                onPressed: () {
                  context.read<MenuController>().controlMenu();
                },
                icon: const Icon(Icons.menu))
            : null,
        actions: [
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
          PopupMenuButton<String>(
              tooltip: FlutterI18n.translate(context, "label.personalCenter"),
              icon: Container(
                color: Colors.white,
                height: 20,
                width: 20,
                child: Image.asset("assets/icons/self_male.png"),
              ),
              itemBuilder: (context) => <PopupMenuItem<String>>[]),
        ],
      ),
    );
  }

  PopupMenuItem<String> buildPopupMenuItem(String key) {
    return PopupMenuItem(
      child: Text(key),
      onTap: () async {
        String lang = reservedOptions[key]!;
        await context.read<LanguageController>().changeLanguage(lang);
        setState(() {});
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
