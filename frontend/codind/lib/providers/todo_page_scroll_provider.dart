import 'package:flutter/material.dart';

class TodoPageScrollController extends ChangeNotifier {
  double _offset = 0;

  bool get showbar => _offset > 150;

  void changeOffset(double i) {
    _offset = i;
    notifyListeners();
  }
}
