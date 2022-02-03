/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-02-03 11:53:34
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-02-03 12:59:07
 */
import 'package:flutter/material.dart';

class EmojiController extends ChangeNotifier {
  List<String> _usedEmojis = [];

  List<String> get useEmojis => _usedEmojis;

  addEmoji(String s) {
    if (!_usedEmojis.contains(s)) {
      _usedEmojis.add(s);
    }
    notifyListeners();
  }

  setEmojis(List<String>? ls) {
    _usedEmojis = ls ?? [];
    notifyListeners();
  }
}
