import 'package:flutter/material.dart';

class MainPageCardController extends ChangeNotifier {
  /// i18n key and selected
  // ignore: prefer_final_fields
  Map<String, bool> selectedCard = {
    "label.todos": false,
    "resume.abi": false,
    "resume.title": false,
  };

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
}
