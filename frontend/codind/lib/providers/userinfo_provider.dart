import 'package:codind/entity/avatar_img_entity.dart';
import 'package:codind/entity/entity.dart';
import 'package:flutter/material.dart';
import 'package:codind/utils/no_web/sqlite_utils.dart'
    if (dart.library.html) 'package:codind/utils/web/sqlite_utils_web.dart';

class UserinfoController extends ChangeNotifier {
  AvatarType _avatarType = AvatarType.undefined;
  String _imgPath = "";
  String _imgData = "";
  Color _backgroundColor = Colors.white;
  late SqliteUtils sqliteUtils = SqliteUtils();

  Friend _friend = Friend();

  Friend get userData => _friend;

  login(Friend f) {
    _friend = f;
    notifyListeners();
  }

  changeUserName(String s) async {
    _friend.userName = s;
    await sqliteUtils.setUserName(s);
    notifyListeners();
  }

  AvatarType get avatarType => _avatarType;
  String get imgPath => _imgPath;
  String get imgData => _imgData;
  Color get backgroundColor => _backgroundColor;

  // ignore: prefer_final_fields
  AvatarImg _img = AvatarImg(
    type: AvatarType.undefined,
  );

  AvatarImg get img => _img;

  void changeImg(
      AvatarType type, String? imgpath, String? imgdata, Color? color) {
    if (type == AvatarType.undefined) {
      _avatarType = type;
      _imgPath = "";
      _imgData = "";
    } else if (type == AvatarType.png) {
      _backgroundColor = color ?? Colors.white;
      _avatarType = type;
      _imgPath = imgpath!;
    } else {
      _avatarType = type;
      _imgData = imgdata!;
    }

    _img.background = _backgroundColor;
    _img.imgData = imgdata;
    _img.imgPath = imgpath;
    _img.type = type;

    notifyListeners();
  }
}
