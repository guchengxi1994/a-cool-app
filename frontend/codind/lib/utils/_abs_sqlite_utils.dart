/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-05-10 21:26:22
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-05-10 22:11:23
 */
import 'package:codind/entity/friend_entity.dart';
import 'package:codind/entity/knowledge_entity.dart';

import '../entity/work_entity.dart';

abstract class AbstractSqliteUtils {
  // 获取所有日程
  Future<WorkWorkWork> getWorkDays();
  // insert 日程
  Future<void> addNewKnowledge(KnowledgeEntity w);
  // 获取所有diary
  List<KnowledgeEntity> queryAllKnowledge();
  // 初始化日志数据量
  Future<void> initTodoBase();
  // 初始化文件数据库
  Future<void> initFileBase();
  // 初始化diary 数据库
  Future<void> initKnowledgeBase();
  // 初始化friends 数据库
  Future<void> initFriendsBase();
  // 获取用户信息
  Future<Friend?> getFriend();
}
