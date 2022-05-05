import 'package:codind/router.dart';
import 'package:flutter/material.dart';

class SplashPageScreenController extends ChangeNotifier {
  int _currentIndex = 0;

  final List<String> steps = [
    "验证平台信息...",
    "验证是否第一次使用...",
    "正在创建知识数据库...",
    "正在创建文件数据库...",
    "正在验证身份...",
  ];

  String get value =>
      (_currentIndex / steps.length * 100).ceil().toString() + "%";

  List<String> get done => steps.getRange(0, _currentIndex).toList();

  changeValue(int step) {
    _currentIndex += step;
    notifyListeners();
  }

  _initPlatform() async {
    await Future.delayed(Duration(milliseconds: 400));
    changeValue(1);
  }

  init() async {
    await _initPlatform();
    await Future.delayed(Duration(milliseconds: 500));
    changeValue(1);
    await _initKnowledgeDatabase();
    await _initFileDatabase();
    await _initRole();
    push();
  }

  _initKnowledgeDatabase() async {
    await Future.delayed(Duration(milliseconds: 600));
    changeValue(1);
  }

  _initFileDatabase() async {
    await Future.delayed(Duration(milliseconds: 500));
    changeValue(1);
  }

  _initRole() async {
    await Future.delayed(Duration(milliseconds: 400));

    changeValue(1);
  }

  push() async {
    Global.navigatorKey.currentState!
        .pushNamedAndRemoveUntil(Routers.pageLogin, (route) => false);
  }
}
