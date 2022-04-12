import 'package:flutter/material.dart';

import '../utils/shared_preference_utils.dart';

class MainPageCardController extends ChangeNotifier {
  /// i18n key and selected
  // ignore: prefer_final_fields
  Map<String, bool> selectedCard = {
    "label.todos": false,
    "resume.abi": false,
    "resume.title": false,
    "label.friend": false,
  };

  Map<String, String> _titleNameMap = {
    "label.todos": "assets/images/my_todos.png",
    "resume.abi": "assets/images/my_study.png",
    "resume.title": "assets/images/my_resume.png",
    "label.friend": "assets/images/friend.png"
  };

  Map<String, String> _titleContentMap = {
    "label.todos": "早睡早起\n规律作息",
    "resume.abi": "好好学习\n实力提升",
    "resume.title": "只有自己才了解自己",
    "label.friend": "桃花潭水深千尺"
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
      notifyListeners();
    }
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
