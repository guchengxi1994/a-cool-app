// ignore_for_file: no_leading_underscores_for_local_identifiers

/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-05-09 21:03:01
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-05-11 21:25:10
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
        var eventStatus = int.parse(row['eventStatus'].toString());

        if (eventStatus == 1) {
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
  Future<List<KnowledgeEntity>> queryAllKnowledge() async {
    List<KnowledgeEntity> entities = [];
    var _appSupportDirectory = await getApplicationSupportDirectory();

    var db =
        sql.sqlite3.open("${_appSupportDirectory.path}/$knowledgeBasePath");

    final sql.ResultSet resultSet = db.select("select * from knowledge");

    for (var r in resultSet) {
      try {
        KnowledgeEntity k = KnowledgeEntity(
            time: r["time"] ?? "",
            title: r["title"] ?? "",
            detail: r["detail"] ?? "",
            summary: r["summary"] ?? "",
            fromUrlOrOthers: r["fromUrlOrOthers"] ?? "",
            codes: r["codes"] ?? "",
            tag: r["tag"] ?? "",
            imgs: r["imgs"] == null ? [] : (r["imgs"] as String).split(";"),
            codeStyle: r["codeStyle"] ?? "");
        entities.add(k);
      } catch (e) {
        // ignore: avoid_print
        print("[flutter error]:${e.toString()}");
      }
    }
    db.dispose();
    return entities;
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
    File _dbFile = File("${_appSupportDirectory.path}/$fileBasePath");
    // var db = sql.sqlite3.open("${_appSupportDirectory.path}/$fileBasePath");

    if (!_dbFile.existsSync()) {
      var db = sql.sqlite3.open("${_appSupportDirectory.path}/$fileBasePath");
      debugPrint(
          "[todo base path] ${_appSupportDirectory.path}/$fileBasePath}");

      db.execute('''
          create table `files` (
            `fileId` INTEGER primary key AUTOINCREMENT,
            `savedTime` varchar(25),
            `filename` varchar(50),
            `savedLocation` varchar(100),
            `isDeleted` int
            );
        ''');

      db.dispose();
    }
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
              `description` varchar(200),     
              `endTime` varchar(25),
              `eventStatus` int,
              `eventColor` varchar(20)
            );
          ''');

      final stmt = db.prepare(
          "INSERT INTO todos (startTime,todoName,endTime,eventStatus) values (?,?,?,?)");

      stmt.execute([
        DateTime.now().toString(),
        '第一次运行',
        DateTime.now().add(const Duration(days: 1)).toString(),
        0
      ]);

      stmt.dispose();

      db.dispose();
    }
  }

  @override
  Future<void> initFriendsBase() async {
    var _appSupportDirectory = await getApplicationSupportDirectory();
    File _dbFile = File("${_appSupportDirectory.path}/$friendsBasePath");
    if (!_dbFile.existsSync()) {
      var db =
          sql.sqlite3.open("${_appSupportDirectory.path}/$friendsBasePath");
      debugPrint(
          "[todo base path] ${_appSupportDirectory.path}/$friendsBasePath}");

      db.execute('''
            CREATE TABLE `friend` (
              `fid` INTEGER primary key AUTOINCREMENT,
              `userName` varchar(25),
              `userEmail` varchar(50),     
              `avatarPath` varchar(100),
              `userPassword` varchar(50),
              `isSelf` int,
              `friendship` int
            );
          ''');

      final stmt = db.prepare(
          "INSERT INTO friend (userEmail,userPassword,isSelf,userName) values(?,?,?,?)");

      stmt.execute(["test@xiaoshuyui.org.cn", "123456", 0, "测试用户"]);

      stmt.dispose();
      db.dispose();
    }
  }

  @override
  Future<Friend?> getFriend() async {
    var _appSupportDirectory = await getApplicationSupportDirectory();

    var db = sql.sqlite3.open("${_appSupportDirectory.path}/$friendsBasePath");

    final sql.ResultSet resultSet =
        db.select("select * from friend where isSelf = 1");

    Friend _friend = Friend();
    try {
      var _data = resultSet.first;
      _friend.avatarPath = _data['avatarPath'] ?? "";
      _friend.fid = _data['fid'] ?? 0;
      _friend.friendship = _data['friendship'] ?? 0;
      _friend.userEmail = _data['userEmail'] ?? "";
      _friend.userName = _data['userName'] ?? "测试用户";
      _friend.password = _data['userPassword'] ?? "";
      _friend.isSelf = true;
      db.dispose();
      return _friend;
    } catch (_) {
      db.dispose();
      return null;
    }
  }

  @override
  Future<void> insertFriend(Friend f) async {
    var _appSupportDirectory = await getApplicationSupportDirectory();

    var db = sql.sqlite3.open("${_appSupportDirectory.path}/$friendsBasePath");

    final stmt = db.prepare(
        "INSERT INTO friend (userEmail,userPassword,isSelf,userName) values(?,?,?,?)");

    stmt.execute([f.userEmail, f.password, 1, "未修改用户名"]);

    stmt.dispose();
    db.dispose();
  }

  @override
  Future<List<Friend>?> getAllFriends() async {
    var _appSupportDirectory = await getApplicationSupportDirectory();
    List<Friend> friendList = [];

    var db = sql.sqlite3.open("${_appSupportDirectory.path}/$friendsBasePath");

    final sql.ResultSet resultSet =
        db.select("select * from friend where isSelf != 1");

    if (resultSet.isEmpty) {
      return null;
    }

    for (var row in resultSet) {
      friendList.add(Friend(
          userEmail: row["userEmail"] ?? "未知email",
          userName: row["userName"] ?? "未知用户名",
          avatarPath: row["avatarPath"]));
    }

    return friendList;
  }

  @override
  Future<void> setUserName(String s) async {
    var _appSupportDirectory = await getApplicationSupportDirectory();

    var db = sql.sqlite3.open("${_appSupportDirectory.path}/$friendsBasePath");
    db.execute('''
    UPDATE  friend set userName='$s' where isSelf=1;
''');
    db.dispose();
  }

  @override
  Future<void> insertAnEvent(EventEntity e) async {
    var _appSupportDirectory = await getApplicationSupportDirectory();
    var db = sql.sqlite3.open("${_appSupportDirectory.path}/$todosBasePath");

    final stmt = db.prepare(
        " insert into todos(startTime,todoName,description,endTime,eventStatus,eventColor) values (?,?,?,?,?,?) ");

    stmt.execute([
      e.startTime,
      e.todoName,
      e.description,
      e.endTime,
      e.eventStatus,
      e.color
    ]);

    stmt.dispose();
    db.dispose();
  }

  @override
  Future<List<EventEntity>> getAllEvents() async {
    List<EventEntity> events = [];
    var _appSupportDirectory = await getApplicationSupportDirectory();
    var db = sql.sqlite3.open("${_appSupportDirectory.path}/$todosBasePath");
    final sql.ResultSet resultSet = db.select("select * from todos");
    for (var r in resultSet) {
      try {
        EventEntity e = EventEntity(
            description: r["description"] ?? "",
            endTime: r["endTime"] ?? "",
            eventStatus: r["eventStatus"] ?? 0,
            startTime: r["startTime"] ?? "",
            todoName: r["todoName"] ?? "",
            tid: r["tid"] ?? 0,
            color: r["eventColor"] ?? "745db3be");
        events.add(e);
      } catch (_) {
        continue;
      }
    }

    db.dispose();
    return events;
  }

  @override
  Future<void> setEventStatus(int eventId, int statusId) async {
    var _appSupportDirectory = await getApplicationSupportDirectory();
    var db = sql.sqlite3.open("${_appSupportDirectory.path}/$todosBasePath");
    db.execute('''
      UPDATE  todos set eventStatus=$statusId where tid=$eventId;
    ''');
    db.dispose();
  }

  @override
  Future<void> addMdFile(FileLoggedToDbEntity entity) async {
    var _appSupportDirectory = await getApplicationSupportDirectory();
    var db = sql.sqlite3.open("${_appSupportDirectory.path}/$fileBasePath");
    final stmt = db.prepare(
        "insert into files(savedTime,filename,savedLocation,isDeleted) values(?,?,?,?)");

    stmt.execute([
      entity.savedTime,
      entity.filename,
      entity.savedLocation,
      entity.isDeleted
    ]);

    stmt.dispose();
    db.dispose();
  }

  @override
  Future<List<FileLoggedToDbEntity>> getAllMdFiles() async {
    var _appSupportDirectory = await getApplicationSupportDirectory();
    var db = sql.sqlite3.open("${_appSupportDirectory.path}/$fileBasePath");
    List<FileLoggedToDbEntity> result = [];

    final sql.ResultSet resultSet =
        db.select("select * from files where isDeleted=0");

    for (var r in resultSet) {
      try {
        FileLoggedToDbEntity e = FileLoggedToDbEntity(
            filename: r["filename"] ?? "",
            savedLocation: r["savedLocation"] ?? "",
            savedTime: r["savedTime"] ?? "",
            fileId: r["fileId"] ?? 0);

        result.add(e);
      } catch (_) {}
    }
    db.dispose();
    return result;
  }

  @override
  Future<int> getKnowledgeCount() async {
    var _appSupportDirectory = await getApplicationSupportDirectory();

    var db =
        sql.sqlite3.open("${_appSupportDirectory.path}/$knowledgeBasePath");

    var result = db.select("SELECT COUNT(1) from knowledge;");
    // debugPrint("[debug length]:${result.first.values.first}");
    db.dispose();
    return result.first.values.first;
  }

  @override
  Future<int> getMarkdownCount() async {
    var _appSupportDirectory = await getApplicationSupportDirectory();

    var db = sql.sqlite3.open("${_appSupportDirectory.path}/$fileBasePath");

    var result = db.select("SELECT COUNT(1) from files where isDeleted = 0;");
    // debugPrint("[debug length]:${result.first.values.first}");
    db.dispose();
    return result.first.values.first;
  }

  @override
  Future<int> getFriendsCount() async {
    var _appSupportDirectory = await getApplicationSupportDirectory();

    var db = sql.sqlite3.open("${_appSupportDirectory.path}/$friendsBasePath");

    var result = db.select("SELECT COUNT(1) from friend where isSelf=0;");
    // debugPrint("[debug length]:${result.first.values.first}");
    db.dispose();
    return result.first.values.first;
  }
}
