/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-01-30 21:46:56
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-02-10 21:52:09
 */
import 'package:codind/pages/_base_page.dart';
import 'package:codind/pages/_base_preview_page.dart';
import 'package:flutter/material.dart';

class TestPage extends BasePage {
  TestPage({required String routeName}) : super(routeName: routeName);

  @override
  BasePageState<BasePage> getState() {
    return _TestPageState();
  }
}

class _TestPageState<T> extends BasePageState<TestPage> {
  @override
  baseBuild(BuildContext context) {
    return BaseMarkdownPreviewPage(
      from: DataFrom.net,
      mdData: "https://github.com/guchengxi1994/mask2json/blob/test/README.md",
    );
  }
}
