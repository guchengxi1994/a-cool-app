/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-04-14 21:49:08
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-04-14 22:16:14
 */
import 'package:flutter/material.dart';

import '../pages/_create_single_knowledge_page.dart';

class KnowledgeWidgetController extends ChangeNotifier {
  List<KnowledgeSummaryWidget> _items = [];

  List<KnowledgeSummaryWidget> get items => _items;

  addItem(KnowledgeSummaryWidget w) {
    _items.add(w);
    notifyListeners();
  }
}
