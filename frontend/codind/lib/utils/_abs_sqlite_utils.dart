import 'package:codind/entity/knowledge_entity.dart';

import '../entity/work_entity.dart';

abstract class AbstractSqliteUtils {
  Future<WorkWorkWork> getWorkDays();

  Future<void> addNewKnowledge(KnowledgeEntity w);

  List<KnowledgeEntity> queryAllKnowledge();

  Future<void> initTodoBase();

  Future<void> initFileBase();

  Future<void> initKnowledgeBase();
}
