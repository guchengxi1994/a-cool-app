import 'package:flutter/material.dart';

class RadioProvider extends ChangeNotifier {
  int _initialValue = 0;
  int get value => _initialValue;

  void changeValue(int v) {
    _initialValue = v;
    notifyListeners();
  }
}
