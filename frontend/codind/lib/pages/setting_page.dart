/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-01-30 21:46:56
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-01-31 21:22:30
 */
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
  late ThemeData themeData;

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
              themeData = ThemeData(
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
