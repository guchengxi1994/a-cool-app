/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-01-30 21:46:56
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-04-10 11:53:31
 */

import 'package:codind/pages/_base_page.dart';
import 'package:codind/widgets/main_page_widgets/main_page_expanded_widget.dart';
import 'package:codind/widgets/selectable_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import '../widgets/main_page_widgets/main_page_collaps_widget.dart';

// ignore: must_be_immutable
class TestPage extends BasePage {
  TestPage({Key? key, required String routeName})
      : super(key: key, routeName: routeName);

  @override
  BasePageState<BasePage> getState() {
    return _TestPageState();
  }
}

class _TestPageState<T> extends BasePageState<TestPage> {
  @override
  baseBuild(BuildContext context) {
    // return BaseMarkdownPreviewPage(
    //   from: DataFrom.asset,
    //   mdData: "assets/reserved_md_files/markdown_guide.md",
    // );

    String c1 = Color.fromARGB(255, 185, 194, 66).value.toRadixString(16);
    String c2 = Color.fromARGB(255, 85, 185, 65).value.toRadixString(16);

    print(c1);
    print(c2);

    // return Container(
    //   child: CoolSelectableIcon(
    //     mainPageCardData: MainPageCardData(
    //         endColor: c2, startColor: c1, titleTxt: "label.todos"),
    //     iconStr: "label.todos",
    //   ),
    // );

    // return Container(
    //   child: MediterranesnDietView(),
    // );
    return CoolCollapsWidget(
      cardName: "label.todos",
    );
  }
}
