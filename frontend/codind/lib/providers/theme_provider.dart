import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  ThemeData _themeData = ThemeData();
  ThemeData get themeData => _themeData;

  changeThemeData(ThemeData t) async {
    _themeData = t;
    notifyListeners();
  }
}
