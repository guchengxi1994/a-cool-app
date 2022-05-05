import 'dart:io';

import 'package:codind/router.dart';
import 'package:codind/utils/platform_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

import '../utils/shared_preference_utils.dart';

/// not on webs
class SplashPageScreenController extends ChangeNotifier {
  PersistenceStorage ps = PersistenceStorage();
  Directory? _appSupportDirectory;
  bool _isFirst = true;
  int _currentIndex = 0;

  late LoginData logdata;

  final List<String> steps = [
    "验证平台信息...",
    "验证是否第一次使用...",
    "正在创建知识数据库...",
    "正在创建文件数据库...",
    "正在验证身份...",
  ];

  List<String> get done => steps.getRange(0, _currentIndex).toList();

  String get value =>
      (_currentIndex / steps.length * 100).ceil().toString() + "%";

  changeValue(int step) {
    _currentIndex += step;
    notifyListeners();
  }

  _initPlatform() async {
    await Future.delayed(Duration(milliseconds: 200));
    changeValue(1);
  }

  init() async {
    await _initPlatform();
    _isFirst = await ps.isFirstTime();
    if (_isFirst) {
      _appSupportDirectory = await getApplicationSupportDirectory();
    }
    changeValue(1);
    await _initKnowledgeDatabase();
    await _initFileDatabase();
    await _initRole();
    _push();
  }

  _initKnowledgeDatabase() async {
    if (_isFirst && _appSupportDirectory != null) {
      var dbPath = "knowledge.db";
      var db = sqlite3.open("${_appSupportDirectory!.path}/$dbPath");
    }
    changeValue(1);
  }

  _initFileDatabase() async {
    if (_isFirst && _appSupportDirectory != null && PlatformUtils.isMobile) {
      var dbPath = "file.db";
      var db = sqlite3.open("${_appSupportDirectory!.path}/$dbPath");
    }
    changeValue(1);
  }

  _initRole() async {
    logdata = LoginData(
        name: await ps.getUserEmail(), password: await ps.getUserPassword());
    await Future.delayed(Duration(milliseconds: 200));
    changeValue(1);
  }

  _push() async {
    if (await logdata.isTestAccount()) {
      Global.navigatorKey.currentState!
          .pushNamedAndRemoveUntil(Routers.pageMain, (route) => false);
    } else {
      Global.navigatorKey.currentState!
          .pushNamedAndRemoveUntil(Routers.pageLogin, (route) => false);
    }
  }
}

extension AccountTest on LoginData {
  Future<bool> isTestAccount() async {
    return name == "test@xiaoshuyui.org.cn" && password == "123456";
  }
}
