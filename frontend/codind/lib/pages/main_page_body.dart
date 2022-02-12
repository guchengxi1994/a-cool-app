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
            title: const Text("Search ..."),
            onTap: () {},
          ),
        ),
        Card(
          child: ListTile(
            title: const Text("Saved links"),
            onTap: () {},
          ),
        ),
        Card(
          child: ListTile(
            title: const Text("Start writing"),
            onTap: () {
              Navigator.of(context).pushNamed(Routers.pageMdEditor);
            },
          ),
        ),
        Card(
          child: ListTile(
            title: const Text("Folder"),
            onTap: () {
              Navigator.of(context).pushNamed(Routers.pageFolder);
            },
          ),
        )
      ]),
    );
  }
}
