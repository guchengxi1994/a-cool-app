// ignore_for_file: prefer_final_fields

/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-04-09 19:03:08
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-04-21 21:51:15
 */
import 'package:flutter/material.dart';

import '../utils/shared_preference_utils.dart';

/// 需要同时在 main_page_v2 添加listtile
/// 在 selectable_icon 添加button样式以及
/// 定义label 和 tip
class MainPageCardController extends ChangeNotifier {
  PersistenceStorage ps = PersistenceStorage();

  /// i18n key and selected
  Map<String, bool> selectedCard = {
    "label.todos": false,
    "resume.abi": false,
    "resume.title": false,
    "label.friend": false,
    "label.md": false,
    "label.kb": false,
  };

  List<String> _recorded = [];

  int get all => selectedCard.keys.length;

  final Map<String, String> _titleNameMap = {
    "label.todos": "assets/images/my_todos.png",
    "resume.abi": "assets/images/my_study.png",
    "resume.title": "assets/images/my_resume.png",
    "label.friend": "assets/images/friend.png",
    "label.md": "assets/images/writing.png",
    "label.kb": "assets/images/kb.png",
  };

  final Map<String, String> _titleContentMap = {
    "label.todos": "早睡早起\n规律作息",
    "resume.abi": "好好学习\n实力提升",
    "resume.title": "只有自己才了解自己",
    "label.friend": "桃花潭水深千尺",
    "label.md": "Writing",
    "label.kb": "博观而约取，厚积而薄发",
  };

  String? getImgPath(String key) {
    return _titleNameMap[key];
  }

  String getContent(String key) {
    return _titleContentMap[key] ?? "";
  }

  List<String> get selectedCards => getSelectedTitles();

  List<String> getSelectedTitles() {
    List<String> res = [];
    for (var i in selectedCard.keys) {
      if (selectedCard[i]!) {
        res.add(i);
      }
    }
    return res;
  }

  void changeSelected(String key) {
    if (selectedCard.containsKey(key)) {
      selectedCard[key] = !selectedCard[key]!;
      if (selectedCard[key]! && !_recorded.contains(key)) {
        _recorded.add(key);
      } else {
        _recorded.remove(key);
      }
      notifyListeners();
    }
  }

  Future<void> record() async {
    ps.setTitles(_recorded);
  }

  Future init() async {
    PersistenceStorage ps = PersistenceStorage();

    List<String> l = await ps.getMainpageCardTitles();

    for (var i in l) {
      if (selectedCard.containsKey(i)) {
        selectedCard[i] = true;
      }
    }

    notifyListeners();
  }
}
