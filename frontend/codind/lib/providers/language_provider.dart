import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class LanguageController extends ChangeNotifier {
  BuildContext _context;
  LanguageController(this._context);

  String _currentlang = "zh_CN";
  String get currentLang => _currentlang;

  getContext() => _context;
  setContext(BuildContext context) => _context = context;
  changeLanguage(String lang) async {
    _currentlang = lang;
    await FlutterI18n.refresh(_context, Locale(lang));
    notifyListeners();
  }
}

class LanguageCubit extends Cubit {
  BuildContext _context;
  LanguageCubit(this._context) : super(null);

  String _currentlang = "zh_CN";
  String get currentLang => _currentlang;
  getContext() => _context;
  setContext(BuildContext context) => _context = context;

  changeLanguage(String lang) async {
    _currentlang = lang;
    await FlutterI18n.refresh(_context, Locale(lang));
    emit(state);
  }
}
