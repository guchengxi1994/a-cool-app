import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  ///
  ThemeData _themeData = ThemeData();
  ThemeData get themeData => _themeData;

  Map<String, Color> _initialColorTheme = {
    "primaryColor": const Color(0xFF1976D2),
    "primaryColorLight": const Color(0xFF2196F3),
    "primaryColorDark": Colors.blueGrey[800]!,
    "bottomAppBarColor": Colors.white,
    "appBarColor": Colors.blueAccent,
  };

  Map<String, Color> get initialColor => _initialColorTheme;

  changeThemeData(ThemeData t) async {
    _themeData = t;
    notifyListeners();
  }

  setThemeByMap(Map<String, Color> m) async {
    ThemeData themeData = ThemeData(
      primaryColor: m['primaryColor']!,
      primaryColorLight: m['primaryColorLight']!,
      primaryColorDark: m['primaryColorDark']!,
      bottomAppBarColor: m['bottomAppBarColor']!,
      appBarTheme: AppBarTheme(color: m['appBarColor']),
    );

    _initialColorTheme = m;
    _themeData = themeData;
    notifyListeners();
  }
}
