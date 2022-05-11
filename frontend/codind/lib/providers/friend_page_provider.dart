/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-05-11 19:43:33
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-05-11 20:11:15
 */
import 'package:codind/entity/friend_entity.dart';
import 'package:codind/utils/platform_utils.dart';
import 'package:flutter/material.dart';
import 'package:codind/utils/no_web/sqlite_utils.dart'
    if (dart.library.html) 'package:codind/utils/web/sqlite_utils_web.dart';

class FriendPageController extends ChangeNotifier {
  List<Friend> _list = [];
  late SqliteUtils sqlUtils;

  List<Friend> get friends => _list;

  init() async {
    if (!PlatformUtils.isWeb) {
      List<Friend>? _res = await sqlUtils.getAllFriends();
      if (_res != null) {
        _list = _res;
        notifyListeners();
      }
    } else {
      _list = [
        Friend(
          userName: "测试用户",
          userEmail: "test@xiaoshuyui.org.cn",
        )
      ];
    }
  }
}
