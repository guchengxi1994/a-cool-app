/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-01-30 21:46:56
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-02-01 10:10:41
 */

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import '_back_screen_minin.dart';
import '_color_setting_page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> with BackScreenMixin {
  late ThemeData themeData;
  @override
  backScreenBuild(BuildContext context) {
    return buildView();
  }

  Widget buildView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(FlutterI18n.translate(context, "label.changeColor")),
              ElevatedButton(
                child: Text(FlutterI18n.translate(context, "label.click")),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => ColorSettingPage()));
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
