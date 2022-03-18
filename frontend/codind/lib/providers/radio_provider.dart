import 'package:flutter/material.dart';

class RadioProvider extends ChangeNotifier {
  int _initialValue = 0;
  int get value => _initialValue;

  final Map<int, String> mds = {
    0: "assets/reserved_md_files/0.md",
    1: "assets/reserved_md_files/1.md"
  };

  final Map<int, String> mdNames = {
    0: "github template",
    1: "resume template",
    2: "bbb",
    3: "ccc",
    4: "ddd",
    5: "eee",
  };

  String? get mdTemplatePath => mds[_initialValue];

  void changeValue(int v) {
    _initialValue = v;
    notifyListeners();
  }
}
