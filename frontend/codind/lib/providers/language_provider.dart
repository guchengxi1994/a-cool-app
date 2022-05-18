/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-01-30 21:46:56
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-03-22 22:09:39
 */
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

@Deprecated("should not be used")
class LanguageController extends ChangeNotifier {
  BuildContext _context;
  LanguageController(this._context);

  String _currentlang = "zh_CN";
  String get currentLang => _currentlang;

  List<String> langList = ["zh_CN", "en"];

  getContext() => _context;
  setContext(BuildContext context) => _context = context;
  changeLanguage(String lang) async {
    _currentlang = lang;
    await FlutterI18n.refresh(_context, Locale(lang));
    notifyListeners();
  }
}

class LanguageControllerV2 extends ChangeNotifier {
  String _currentlang = "zh_CN";
  String get currentLang => _currentlang;
  List<String> langList = ["zh_CN", "en"];

  changeLanguage(String lang) {
    debugPrint("[current lang] : $lang ");
    if (_currentlang != lang) {
      _currentlang = lang;
      notifyListeners();
    }
  }
}
