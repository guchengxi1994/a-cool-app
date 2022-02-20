/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-01-30 21:46:56
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-02-19 22:16:06
 */
import 'package:codind/pages/_base_page.dart';
import 'package:codind/pages/_base_preview_page.dart';
import 'package:flutter/material.dart';

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
    return BaseMarkdownPreviewPage(
      from: DataFrom.asset,
      mdData: "assets/reserved_md_files/markdown_guide.md",
    );
  }
}
