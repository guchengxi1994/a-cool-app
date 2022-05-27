import 'package:flutter/material.dart';
import 'package:codind/utils/no_web/sqlite_utils.dart'
    if (dart.library.html) 'package:codind/utils/web/sqlite_utils_web.dart';

class UserStatusController extends ChangeNotifier {
  var sqliteUtils = SqliteUtils();

  int _friendCount = 0;
  int _markdownCount = 0;
  int _knowledgeCount = 0;

  int get friendCount => _friendCount;
  int get markdownCount => _markdownCount;
  int get knowledgeCount => _knowledgeCount;

  init() async {
    _friendCount = await sqliteUtils.getFriendsCount();
    _knowledgeCount = await sqliteUtils.getKnowledgeCount();
    _markdownCount = await sqliteUtils.getMarkdownCount();
    notifyListeners();
  }
}
