// ignore_for_file: prefer_final_fields

/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-04-14 21:49:08
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-04-20 21:07:55
 */
import 'package:codind/entity/knowledge_entity.dart';
import 'package:flutter/material.dart';
import 'package:codind/utils/no_web/sqlite_utils.dart'
    if (dart.library.html) 'package:codind/utils/web/sqlite_utils_web.dart';

import '../pages/module_pages/_create_single_knowledge_page.dart';

class KnowledgeWidgetController extends ChangeNotifier {
  List<KnowledgeSummaryWidget> _items = [];

  List<KnowledgeSummaryWidget> get items => _items;

  addItem(KnowledgeSummaryWidget w) {
    _items.add(w);
    notifyListeners();
  }
}

class KnowledgeController extends ChangeNotifier {
  List<KnowledgeEntity> _items = [];
  List<KnowledgeEntity> get items => _items;

  addItem(KnowledgeEntity w) async {
    _items.add(w);

    var sqliteUtils = SqliteUtils();
    await sqliteUtils.addNewKnowledge(w);

    notifyListeners();
  }

  KnowledgeEntity? getOne(String summary) {
    return _items.firstWhere((element) => element.summary == summary,
        orElse: () => KnowledgeEntity());
  }
}
