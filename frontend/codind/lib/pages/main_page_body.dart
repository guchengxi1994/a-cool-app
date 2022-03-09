/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-02-10 19:26:26
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-02-10 21:52:32
 */
import 'package:codind/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';

import '../providers/my_providers.dart';
import '../utils/utils.dart';
import '_base_page.dart';

// ignore: must_be_immutable
class MainPageBody extends BasePage {
  MainPageBody({Key? key, required String routeName})
      : super(key: key, routeName: routeName);

  @override
  BasePageState<BasePage> getState() {
    return _MainPageBodyState();
  }
}

class _MainPageBodyState<T> extends BasePageState<MainPageBody> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget baseBuild(BuildContext context) {
    return Scaffold(
      key: context.read<MenuController>().scaffoldKey,
      appBar: null,
      drawer: Responsive.isRoughMobile(context) ? Sidemenu() : null,
      body: Wrap(children: [
        Card(
          child: ListTile(
            title: Text(FlutterI18n.translate(context, "mainPage.search")),
            onTap: () {},
          ),
        ),
        Card(
          child: ListTile(
            title: Text(FlutterI18n.translate(context, "mainPage.savedLinks")),
            onTap: () {
              Navigator.of(context).pushNamed(Routers.pageSavedLinks);
            },
          ),
        ),
        Card(
          child: ListTile(
            title:
                Text(FlutterI18n.translate(context, "mainPage.startWriting")),
            onTap: () {
              Navigator.of(context).pushNamed(Routers.pageMdEditor);
            },
          ),
        ),
        Card(
          child: ListTile(
            title: Text(FlutterI18n.translate(context, "mainPage.folder")),
            onTap: () {
              Navigator.of(context).pushNamed(Routers.pageFolder);
            },
          ),
        ),
        Card(
          child: ListTile(
            title: Text(FlutterI18n.translate(context, "mainPage.schedule")),
            onTap: () {
              Navigator.of(context).pushNamed(Routers.pageSchedule);
            },
          ),
        ),
        Card(
          child: ListTile(
            title: Text(FlutterI18n.translate(context, "mainPage.mindMap")),
            onTap: () {
              Navigator.of(context).pushNamed(Routers.pageMindMap);
            },
          ),
        ),
      ]),
    );
  }
}
