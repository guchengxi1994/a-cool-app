import 'package:codind/providers/my_providers.dart';
import 'package:codind/widgets/widgets.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: ElevatedButton(
          child: Text("点击选择颜色"),
          onPressed: () async {
            Color? selectedColor = await showDialog(
                context: context,
                builder: (context) {
                  return ColorPickerWidget();
                });
            if (null != selectedColor) {
              ThemeData themeData = ThemeData(
                  primaryColor: selectedColor,
                  appBarTheme: AppBarTheme(color: selectedColor));
              context.read<ThemeController>().changeThemeData(themeData);
            }
          },
        ),
      ),
    );
  }
}
