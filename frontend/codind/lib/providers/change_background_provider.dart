import 'package:flutter/material.dart';

class ChangeBackgroundProvider extends ChangeNotifier {
  String _currentBackgroundImagePath = "";

  String get currentPath => _currentBackgroundImagePath;

  final Map<String, String> _map = {
    "head": "assets/images/background/head.png",
    "foot": "assets/images/background/foot.png",
    "heart": "assets/images/background/heart.png",
    "stomach": "assets/images/background/stomach.png",
  };

  void controlChangeBackground(String key) {
    _currentBackgroundImagePath = _map[key] ?? "";
    notifyListeners();
  }
}
