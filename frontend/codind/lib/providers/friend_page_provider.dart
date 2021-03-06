// ignore_for_file: no_leading_underscores_for_local_identifiers

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
import 'package:flutter/material.dart';
import 'package:codind/utils/no_web/sqlite_utils.dart'
    if (dart.library.html) 'package:codind/utils/web/sqlite_utils_web.dart';
import 'package:taichi/taichi.dart' show TaichiDevUtils;

class FriendPageController extends ChangeNotifier {
  List<Friend> _list = [];
  late SqliteUtils sqlUtils = SqliteUtils();

  List<Friend> get friends => _list;

  init() async {
    if (!TaichiDevUtils.isWeb) {
      List<Friend>? _res = await sqlUtils.getAllFriends();
      if (_res != null) {
        _list = _res;
        if (_list.isEmpty) {
          _list = [
            Friend(
              userName: "测试用户",
              userEmail: "test@xiaoshuyui.org.cn",
            )
          ];
        }
      } else {
        _list = [
          Friend(
            userName: "测试用户",
            userEmail: "test@xiaoshuyui.org.cn",
          )
        ];
      }
      notifyListeners();
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
