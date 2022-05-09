/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-05-09 21:03:01
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-05-09 21:22:17
 */

import 'package:codind/entity/entity.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart' as sql;

import '../../globals.dart';

Future<WorkWorkWork> getWorkDays() async {
  late WorkWorkWork work =
      WorkWorkWork(all: 0, delayed: 0, done: 0, underGoing: 0);
  var _appSupportDirectory = await getApplicationSupportDirectory();

  var db = sql.sqlite3.open("${_appSupportDirectory.path}/$todosBasePath");

  final sql.ResultSet resultSet = db.select("select * from todos");
  work.all = resultSet.length;
  if (work.all == 0) {
    work.all = 1;
  }

  int _done = 0;
  int _delayed = 0;
  int _underGoing = 0;

  try {
    for (sql.Row row in resultSet) {
      var endTime = DateTime.parse(row['endTime'].toString());
      var isDone = int.parse(row['isDone'].toString());

      if (isDone == 1) {
        _done += 1;
      } else {
        if (endTime.isAfter(DateTime.now())) {
          _underGoing += 1;
        } else {
          _delayed += 1;
        }
      }
    }
    work.done = _done;
    work.delayed = _delayed;
    work.underGoing = _underGoing;
  } catch (_) {
    debugPrint("[exception] convert time error ");
    work.done = _done;
    work.delayed = _delayed;
    work.underGoing = 1;
  }

  db.dispose();
  return work;
}
