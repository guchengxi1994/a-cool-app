/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-05-09 21:29:26
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-05-09 21:32:53
 */
import 'package:codind/entity/entity.dart' show WorkWorkWork;
import 'package:flutter/material.dart';
import 'package:codind/utils/no_web/sqlite_utils.dart'
    if (dart.library.html) 'package:codind/utils/web/sqlite_utils_web.dart';

class TodoProvider extends ChangeNotifier {
  WorkWorkWork _work = WorkWorkWork(all: 1, delayed: 0, done: 0, underGoing: 1);

  WorkWorkWork get work => _work;

  init() async {
    var sqliteUtils = SqliteUtils();
    _work = await sqliteUtils.getWorkDays();
    notifyListeners();
  }
}
