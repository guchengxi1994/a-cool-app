// ignore_for_file: unused_local_variable

import 'package:codind/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

import 'package:codind/utils/no_web/sqlite_utils.dart'
    if (dart.library.html) 'package:codind/utils/web/sqlite_utils_web.dart';

import '../utils/shared_preference_utils.dart';

/// not on webs
class SplashPageScreenController extends ChangeNotifier {
  PersistenceStorage ps = PersistenceStorage();
  // Directory? _appSupportDirectory;
  bool _isFirst = true;
  int _currentIndex = 0;

  late SqliteUtils sqlUtils;

  int thresHold = 5;

  late LoginData logdata;

  final List<String> steps = [
    "验证平台信息...",
    "验证是否第一次使用...",
    "正在创建知识数据库...",
    "正在创建文件数据库...",
    "正在创建日程数据库...",
    "正在创建好友数据库...",
    "正在验证身份...",
  ];

  List<String> get done => steps.getRange(0, _currentIndex).toList();

  List<String> get splashPageRows =>
      done.length <= 5 ? done : done.sublist(done.length - 4);

  String get value =>
      (_currentIndex / steps.length * 100).ceil().toString() + "%";

  changeValue(int step) {
    _currentIndex += step;
    notifyListeners();
  }

  _initPlatform() async {
    await Future.delayed(const Duration(milliseconds: 200));
    changeValue(1);
  }

  init() async {
    await _initPlatform();
    _isFirst = await ps.isFirstTime();
    sqlUtils = SqliteUtils();
    changeValue(1);
    await _initKnowledgeDatabase();
    await _initFileDatabase();
    await _initTodoDatabase();
    await _initRole();
    await _initFriend();
    _push();
  }

  _initKnowledgeDatabase() async {
    if (_isFirst) {
      sqlUtils.initKnowledgeBase();
    }
    changeValue(1);
  }

  _initFileDatabase() async {
    if (_isFirst) {
      sqlUtils.initFileBase();
    }
    changeValue(1);
  }

  _initTodoDatabase() async {
    if (_isFirst) {
      sqlUtils.initTodoBase();
    }
    changeValue(1);
  }

  _initRole() async {
    logdata = LoginData(
        name: await ps.getUserEmail(), password: await ps.getUserPassword());
    await Future.delayed(const Duration(milliseconds: 200));
    changeValue(1);
  }

  _initFriend() async {
    if (_isFirst) {
      sqlUtils.initFriendsBase();
    }
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
