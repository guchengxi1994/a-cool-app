import 'package:codind/pages/_base_page.dart';
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
    return Container();
  }
}
