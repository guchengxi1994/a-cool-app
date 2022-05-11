/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-05-09 21:13:57
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-05-10 22:12:08
 */
import 'package:codind/entity/entity.dart';
import 'package:codind/entity/knowledge_entity.dart';
import 'package:codind/utils/_abs_sqlite_utils.dart';

class SqliteUtils extends AbstractSqliteUtils {
  @override
  Future<void> addNewKnowledge(KnowledgeEntity w) async {}

  @override
  Future<WorkWorkWork> getWorkDays() async {
    WorkWorkWork work =
        WorkWorkWork(all: 11, delayed: 5, done: 5, underGoing: 1);
    return work;
  }

  @override
  List<KnowledgeEntity> queryAllKnowledge() {
    throw UnimplementedError();
  }

  @override
  Future<void> initFileBase() async {}

  @override
  Future<void> initKnowledgeBase() async {}

  @override
  Future<void> initTodoBase() async {}

  @override
  Future<void> initFriendsBase() async {}

  @override
  Future<Friend?> getFriend() async {
    return null;
  }

  @override
  Future<void> insertFriend(Friend f) async {}

  @override
  Future<List<Friend>?> getAllFriends() async {
    return null;
  }
}
