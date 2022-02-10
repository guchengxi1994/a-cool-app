/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-01-30 21:46:56
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-02-10 22:05:43
 */

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import '_base_page.dart';
import '_color_setting_page.dart';

class SettingPage extends BasePage {
  SettingPage({required String routeName}) : super(routeName: routeName);

  @override
  BasePageState<BasePage> getState() {
    return _SettingPageState();
  }
}

class _SettingPageState<T> extends BasePageState<SettingPage> {
  late ThemeData themeData;
  @override
  baseBuild(BuildContext context) {
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
