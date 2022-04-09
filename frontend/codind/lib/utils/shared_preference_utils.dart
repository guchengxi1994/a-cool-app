/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-01-30 21:46:56
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-02-09 19:40:34
 */

import 'package:codind/entity/avatar_img_entity.dart';
import 'package:codind/entity/enums.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersistenceStorage {
  static final _instance = PersistenceStorage._init();

  factory PersistenceStorage() => _instance;

  static SharedPreferences? _storage;

  PersistenceStorage._init() {
    _initStorage();
  }

  _initStorage() async {
    _storage ??= await SharedPreferences.getInstance();
  }

  Future<List<String>?> getColorData() async {
    await _initStorage();
    return _storage!.getStringList("colorData");
  }

  Future<void> saveColorData(List<String> ls) async {
    await _initStorage();
    await _storage!.setStringList("colorData", ls);
  }

  Future<List<String>?> getEmojiData() async {
    await _initStorage();
    return _storage!.getStringList("emoji");
  }

  Future<void> appendColorData(String emoji) async {
    await _initStorage();
    var res = await getEmojiData();
    if (null == res) {
      await _storage!.setStringList("emoji", []);
      res = [];
    }

    if (!res.contains(emoji)) {
      if (res.length == 30) {
        res.removeAt(0);
      }
      res.add(emoji);
    }

    _storage!.setStringList("emoji", res);
  }

  Future<String> getFolderStructure() async {
    await _initStorage();
    var res = _storage!.getString("fileStructure");
    if (res == null) {
      return "";
    } else {
      return res;
    }
  }

  Future<List<String>> getFolderFlattenStructure() async {
    await _initStorage();
    var res = _storage!.getStringList("flatten");
    if (res == null) {
      return [];
    } else {
      return res;
    }
  }

  Future<void> setFolderStructure(String s) async {
    await _initStorage();
    await _storage!.setString("fileStructure", s);
  }

  Future<void> setFolderFlattenStructure(List<String> s) async {
    await _initStorage();
    await _storage!.setStringList("flatten", s);
  }

  Future<AvatarImg> getAvatarData() async {
    await _initStorage();
    var imgData = _storage!.getString("avatarData");
    var color = _storage!.getString("avatarBColor");
    var imgPath = _storage!.getString("avatarImgPath");
    var imgType = _storage!.getString("avatarImgType");
    AvatarType avatarType = imgType == null || imgType == ""
        ? AvatarType.undefined
        : imgType == "png"
            ? AvatarType.png
            : AvatarType.svg;

    AvatarImg _ava = AvatarImg(
        type: avatarType,
        imgData: imgData,
        imgPath: imgPath,
        background: color == null || color == ""
            ? Colors.white
            : Color(int.parse("0x" + color)));
    return _ava;
  }

  Future<void> setAvatarData(AvatarImg avatarImg) async {
    await _initStorage();
    _storage!.setString("avatarData", avatarImg.imgData ?? "");
    String imgType;
    if (avatarImg.type == AvatarType.png) {
      imgType = "png";
    } else if (avatarImg.type == AvatarType.svg) {
      imgType = "svg";
    } else {
      imgType = "";
    }
    await _storage!.setString("avatarImgType", imgType);

    await _storage!.setString("avatarImgPath", avatarImg.imgPath ?? "");

    await _storage!.setString(
        "avatarBColor",
        avatarImg.background != null
            ? avatarImg.background!.value.toRadixString(16)
            : Colors.white.value.toRadixString(16));
  }

  Future<void> setUserEmail(String email) async {
    await _initStorage();
    await _storage!.setString("userAccount", email);
  }

  Future<void> setUserPassword(String ps) async {
    await _initStorage();
    await _storage!.setString("userPassword", ps);
  }

  Future<String> getUserEmail() async {
    await _initStorage();
    return _storage!.getString("userAccount") ?? "";
  }

  Future<String> getUserPassword() async {
    await _initStorage();
    return _storage!.getString("userPassword") ?? "";
  }
}
