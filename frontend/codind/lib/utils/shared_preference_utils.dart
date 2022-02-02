/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-01-30 21:46:56
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-02-02 22:02:20
 */
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<String>?> getColorData() async {
  try {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    return _preferences.getStringList("colorData");
  } catch (e, s) {
    debugPrint(e.toString());
    debugPrint(s.toString());
    return null;
  }
}

Future<void> saveColorData(List<String> ls) async {
  SharedPreferences _preferences = await SharedPreferences.getInstance();
  await _preferences.setStringList("colorData", ls);
}
