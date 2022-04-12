import 'package:codind/utils/shared_preference_utils.dart';
import 'package:flutter/material.dart';

class TopicController extends ChangeNotifier {
  String _topic = "今日话题";
  String get topic => _topic;
  DateTime? lastEditTime;

  void changeTopic(String s) {
    _topic = s;
    lastEditTime = DateTime.now();

    notifyListeners();
  }

  Future init() async {
    PersistenceStorage ps = PersistenceStorage();

    _topic = await ps.getTopic();
    notifyListeners();
  }
}
