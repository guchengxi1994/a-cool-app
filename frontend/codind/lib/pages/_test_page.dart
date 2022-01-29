import 'package:codind/pages/_base_page.dart';
import 'package:codind/pages/_base_preview_page.dart';
import 'package:flutter/material.dart';

class TestPage extends BasePage {
  TestPage({Key? key}) : super(key: key);

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
