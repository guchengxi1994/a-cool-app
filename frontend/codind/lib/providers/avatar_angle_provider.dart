import 'dart:math';

import 'package:flutter/material.dart';

class AngleController extends ChangeNotifier {
  double _angle = 0;
  double get angle => _angle / (pi * 60);

  bool get showbar => _angle > 150;

  void changeAngle(double i) {
    _angle = i;
    notifyListeners();
  }
}
