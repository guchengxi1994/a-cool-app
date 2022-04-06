/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-01-30 21:46:56
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-01-31 21:45:14
 */
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

  Map<String, Color> savedColor = {
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

  setSavedMap(Map<String, Color> m) async {
    savedColor = m;
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

    debugPrint("[current theme-data] : $themeData ");

    _initialColorTheme = m;
    _themeData = themeData;
    notifyListeners();
  }
}
