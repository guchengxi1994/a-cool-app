/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-05-09 21:03:01
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-05-09 21:22:17
 */

import 'dart:io';

import 'package:codind/entity/entity.dart';
import 'package:codind/entity/knowledge_entity.dart';
import 'package:codind/utils/_abs_sqlite_utils.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart' as sql;

import '../../globals.dart';

class SqliteUtils extends AbstractSqliteUtils {
  @override
  addNewKnowledge(KnowledgeEntity w) async {
    var _appSupportDirectory = await getApplicationSupportDirectory();

    var db =
        sql.sqlite3.open("${_appSupportDirectory.path}/$knowledgeBasePath");

    final stmt = db.prepare(
        "INSERT INTO knowledge (time,title,detail,summary,fromUrlOrOthers,codes,tag,imgs,codeStyle) values (?,?,?,?,?,?,?,?,?);");

    var _imgs = "";

    if (w.imgs != null) {
      _imgs = w.imgs!.join(";");
    }

    stmt.execute([
      w.time ?? "",
      w.title ?? "",
      w.detail ?? "",
      w.summary ?? "",
      w.fromUrlOrOthers ?? "",
      w.codes ?? "",
      w.tag ?? "",
      _imgs,
      w.codeStyle ?? ""
    ]);

    stmt.dispose();
    db.dispose();
  }

  @override
  Future<WorkWorkWork> getWorkDays() async {
    late WorkWorkWork work =
        WorkWorkWork(all: 1, delayed: 0, done: 0, underGoing: 1);
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

  @override
  List<KnowledgeEntity> queryAllKnowledge() {
    throw UnimplementedError();
  }

  @override
  Future<void> initKnowledgeBase() async {
    var _appSupportDirectory = await getApplicationSupportDirectory();
    File _dbFile = File("${_appSupportDirectory.path}/$knowledgeBasePath");

    if (!_dbFile.existsSync()) {
      var db =
          sql.sqlite3.open("${_appSupportDirectory.path}/$knowledgeBasePath");
      debugPrint(
          "[knowledge base path] ${_appSupportDirectory.path}/$knowledgeBasePath}");
      db.execute('''
            CREATE TABLE `knowledge` (
              `kid` INTEGER primary key AUTOINCREMENT,
              `time` varchar(25),
              `title` varchar(25),
              `detail` text,
              `summary` text,
              `fromUrlOrOthers` varchar(50),
              `codes` text,
              `tag` text,
              `imgs` text,
              `codeStyle` text     
            );
        ''');

      db.dispose();
    }
  }

  @override
  Future<void> initFileBase() async {
    var _appSupportDirectory = await getApplicationSupportDirectory();
    var db = sql.sqlite3.open("${_appSupportDirectory.path}/$fileBasePath");
    db.dispose();
  }

  @override
  Future<void> initTodoBase() async {
    var _appSupportDirectory = await getApplicationSupportDirectory();
    File _dbFile = File("${_appSupportDirectory.path}/$todosBasePath");

    if (!_dbFile.existsSync()) {
      var db = sql.sqlite3.open("${_appSupportDirectory.path}/$todosBasePath");
      debugPrint(
          "[todo base path] ${_appSupportDirectory.path}/$todosBasePath}");

      db.execute('''
            CREATE TABLE `todos` (
              `tid` INTEGER primary key AUTOINCREMENT,
              `startTime` varchar(25),
              `todoName` varchar(25),     
              `endTime` varchar(25),
              `isDone` int
            );
          ''');

      final stmt = db.prepare(
          "INSERT INTO todos (startTime,todoName,endTime,isDone) values (?,?,?,?)");

      stmt.execute([
        DateTime.now().toString(),
        '第一次运行',
        DateTime.now().add(const Duration(days: 365)).toString(),
        0
      ]);

      stmt.dispose();

      db.dispose();
    }
  }
}
