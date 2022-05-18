/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-05-04 19:56:02
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-05-09 20:30:07
 */
// ignore_for_file: prefer_const_constructors

import 'package:codind/router.dart';
import 'package:flutter/material.dart';

class SplashPageScreenController extends ChangeNotifier {
  int _currentIndex = 0;

  final List<String> steps = [
    "验证平台信息...",
    "验证是否第一次使用...",
    "正在创建知识数据库...",
    "正在创建文件数据库...",
    "正在创建日程数据库...",
    "正在创建好友数据库...",
    "正在验证身份...",
  ];

  String get value => "${(_currentIndex / steps.length * 100).ceil()}%";

  List<String> get done => steps.getRange(0, _currentIndex).toList();

  List<String> get splashPageRows =>
      done.length <= 5 ? done : done.sublist(done.length - 4);

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
    await _initTodoDatabase();
    await _initFriend();
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

  _initFriend() async {
    await Future.delayed(Duration(milliseconds: 500));
    changeValue(1);
  }

  _initTodoDatabase() async {
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
