import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class LanguageController extends ChangeNotifier {
  BuildContext _context;
  LanguageController(this._context);
  getContext() => _context;
  setContext(BuildContext context) => _context = context;
  changeLanguage(String lang) async {
    await FlutterI18n.refresh(_context, Locale(lang));
    notifyListeners();
  }
}
