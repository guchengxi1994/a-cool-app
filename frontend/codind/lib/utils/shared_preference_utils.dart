/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-01-30 21:46:56
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-02-09 19:40:34
 */

import 'package:shared_preferences/shared_preferences.dart';

/// this part will be removed later

// Future<List<String>?> spGetColorData() async {
//   try {
//     SharedPreferences _preferences = await SharedPreferences.getInstance();
//     return _preferences.getStringList("colorData");
//   } catch (e, s) {
//     debugPrint(e.toString());
//     debugPrint(s.toString());
//     return null;
//   }
// }

// Future<void> spSaveColorData(List<String> ls) async {
//   SharedPreferences _preferences = await SharedPreferences.getInstance();
//   await _preferences.setStringList("colorData", ls);
// }

// Future<List<String>?> spGetEmojiData() async {
//   try {
//     SharedPreferences _preferences = await SharedPreferences.getInstance();
//     return _preferences.getStringList("emoji");
//   } catch (e, s) {
//     debugPrint(e.toString());
//     debugPrint(s.toString());
//     return null;
//   }
// }

// Future<void> spAppendColorData(String emoji) async {
//   SharedPreferences _preferences = await SharedPreferences.getInstance();
//   var res = await spGetEmojiData();
//   if (null == res) {
//     await _preferences.setStringList("emoji", []);
//     res = [];
//   }
//   if (!res.contains(emoji)) {
//     if (res.length == 30) {
//       res.removeAt(0);
//     }
//     res.add(emoji);
//   }

//   _preferences.setStringList("emoji", res);
// }

// Future<String> spGetFolderStructure() async {
//   SharedPreferences _preferences = await SharedPreferences.getInstance();
//   var res = _preferences.getString("fileStructure");
//   if (res == null) {
//     return "";
//   } else {
//     return res;
//   }
// }

// Future<List<String>> spGetFolderFlattenStructure() async {
//   SharedPreferences _preferences = await SharedPreferences.getInstance();
//   var res = _preferences.getStringList("flatten");
//   if (res == null) {
//     return [];
//   } else {
//     return res;
//   }
// }

// Future<void> spSetFolderStructure(String s) async {
//   SharedPreferences _preferences = await SharedPreferences.getInstance();
//   await _preferences.setString("fileStructure", s);
// }

// Future<void> spSetFolderFlattenStructure(List<String> s) async {
//   SharedPreferences _preferences = await SharedPreferences.getInstance();
//   await _preferences.setStringList("flatten", s);
// }

class PersistenceStorage {
  static final _instance = PersistenceStorage._init();

  factory PersistenceStorage() => _instance;

  static SharedPreferences? _storage;

  PersistenceStorage._init() {
    _initStorage();
  }

  _initStorage() async {
    _storage ??= await SharedPreferences.getInstance();
  }

  Future<List<String>?> getColorData() async {
    await _initStorage();
    return _storage!.getStringList("colorData");
  }

  Future<void> saveColorData(List<String> ls) async {
    await _initStorage();
    await _storage!.setStringList("colorData", ls);
  }

  Future<List<String>?> getEmojiData() async {
    await _initStorage();
    return _storage!.getStringList("emoji");
  }

  Future<void> appendColorData(String emoji) async {
    await _initStorage();
    var res = await getEmojiData();
    if (null == res) {
      await _storage!.setStringList("emoji", []);
      res = [];
    }

    if (!res.contains(emoji)) {
      if (res.length == 30) {
        res.removeAt(0);
      }
      res.add(emoji);
    }

    _storage!.setStringList("emoji", res);
  }

  Future<String> getFolderStructure() async {
    await _initStorage();
    var res = _storage!.getString("fileStructure");
    if (res == null) {
      return "";
    } else {
      return res;
    }
  }

  Future<List<String>> getFolderFlattenStructure() async {
    await _initStorage();
    var res = _storage!.getStringList("flatten");
    if (res == null) {
      return [];
    } else {
      return res;
    }
  }

  Future<void> setFolderStructure(String s) async {
    await _initStorage();
    await _storage!.setString("fileStructure", s);
  }

  Future<void> setFolderFlattenStructure(List<String> s) async {
    await _initStorage();
    await _storage!.setStringList("flatten", s);
  }
}
