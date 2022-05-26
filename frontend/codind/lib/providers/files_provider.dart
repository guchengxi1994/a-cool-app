import 'package:codind/entity/file_entity.dart' show FileLoggedToDbEntity;
import 'package:flutter/material.dart';
import 'package:codind/utils/no_web/sqlite_utils.dart'
    if (dart.library.html) 'package:codind/utils/web/sqlite_utils_web.dart';

class MdFilesProvider extends ChangeNotifier {
  List<FileLoggedToDbEntity> _fileList = [];

  List<FileLoggedToDbEntity> get fileList => _fileList;
  SqliteUtils sqliteUtils = SqliteUtils();
  init() async {
    _fileList.clear();
    _fileList = await sqliteUtils.getAllMdFiles();
    notifyListeners();
  }
}
