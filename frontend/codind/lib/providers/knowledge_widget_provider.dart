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

import '../pages/module_pages/knowledge_pages/_create_single_knowledge_page.dart';

@Deprecated("use ```KnowledgeController``` instead")
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

  List<KnowledgeSummaryWidget> _widgets = [];
  List<KnowledgeSummaryWidget> get widgets => _widgets;
  var sqliteUtils = SqliteUtils();

  addItem(KnowledgeEntity w, {bool insertTable = true}) async {
    _items.add(w);
    if (insertTable) {
      await sqliteUtils.addNewKnowledge(w);
    }

    notifyListeners();
  }

  fetchAll() async {
    _widgets.clear();
    _items.clear();
    List<KnowledgeEntity> list = await sqliteUtils.queryAllKnowledge();
    await sqliteUtils.getKnowledgeCount();

    // debugPrint("[debug entity length]:${list.length}");
    for (var i in list) {
      // debugPrint("[debug entity]:${i.toJson().toString()}");
      addItem(i, insertTable: false);
      addWidget(KnowledgeSummaryWidget(
        summary: i.summary ?? "",
      ));
    }

    notifyListeners();
  }

  addWidget(KnowledgeSummaryWidget w) {
    _widgets.add(w);
    notifyListeners();
  }

  KnowledgeEntity? getOne(String summary) {
    return _items.firstWhere((element) => element.summary == summary,
        orElse: () => KnowledgeEntity());
  }
}
