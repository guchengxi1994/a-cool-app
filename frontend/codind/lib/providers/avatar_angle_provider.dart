/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-04-06 18:54:13
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-04-09 21:07:10
 */
import 'dart:math';

import 'package:flutter/material.dart';
// import 'package:taichi/taichi.dart';

class AngleController extends ChangeNotifier {
  double _angle = 0;
  double get angle => _angle / (pi * 60);

  double _threshold = 300;

  void initThreshold(double v) {
    _threshold = v;
    notifyListeners();
  }

  bool get showbar => _angle > _threshold;

  void changeAngle(double i) {
    _angle = i;
    notifyListeners();
  }
}
