// ignore_for_file: non_constant_identifier_names

/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-01-30 21:46:56
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-05-17 21:14:37
 */
import 'dart:math';

import 'package:flutter/material.dart';
import "dart:ui" as ui;

import 'package:taichi/taichi.dart';

class Responsive {
// This size work fine on my design, maybe you need some customization depends on your design

  // This isMobile, isTablet, isDesktop helep us later
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 850;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1100 &&
      MediaQuery.of(context).size.width >= 850;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  static bool isRoughMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 850;

  static bool isRoughDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 850;
}

extension SizeExtension on num {
  double get w => CommonUtils.scaleWidth * (toDouble());

  double get h => CommonUtils.scaleHeight * (toDouble());

  double get sp => CommonUtils.scaleText * (toDouble());
}

class CommonUtils {
  CommonUtils._();
  static const double _designHeight = 932;
  static const double _designWidth = 500;

  static double get scaleWidth =>
      TaichiDevUtils.isMobile ? _width / _designWidth : 1;

  static double get scaleHeight =>
      TaichiDevUtils.isMobile ? _height / _designHeight : 1;

  static double get scaleText =>
      TaichiDevUtils.isMobile ? min(scaleWidth, scaleHeight) : 1;

  /// 获取屏幕大小
  static MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
  static final double _width = mediaQuery.size.width;
  static final double _height = mediaQuery.size.height;

  static screenW() {
    return _width;
  }

  static screenH() {
    return _height;
  }
}

class DateUtils {
  final DateTime _dateTime = DateTime.now();
  int get year => _dateTime.year;
  int get month => _dateTime.month;
  List<String> months_CN = [
    "月份",
    "1月",
    "2月",
    "3月",
    "4月",
    "5月",
    "6月",
    "7月",
    "8月",
    "9月",
    "10月",
    "11月",
    "12月"
  ];

  List<String> months_en = [
    "Month",
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sept",
    "Oct",
    "Nov",
    "Dec"
  ];

  static int getCurrentMonthDays(int year, int month) {
    Map<String, int> data = {
      "title": 31,
      "1": 31,
      "2": ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) ? 29 : 28,
      "3": 31,
      "4": 30,
      "5": 31,
      "6": 30,
      "7": 31,
      "8": 31,
      "9": 30,
      "10": 31,
      "11": 30,
      "12": 31,
    };

    return data[month.toString()]!;
  }

  Map<String, int> get data => {
        "title": 31,
        "1": 31,
        "2": ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) ? 29 : 28,
        "3": 31,
        "4": 30,
        "5": 31,
        "6": 30,
        "7": 31,
        "8": 31,
        "9": 30,
        "10": 31,
        "11": 30,
        "12": 31,
      };
}
