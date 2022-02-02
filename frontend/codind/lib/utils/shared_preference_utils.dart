import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageUtil {
  static StorageUtil storageInstance = StorageUtil._instance();
  SharedPreferences? _preferences;

  StorageUtil._instance() {
    if (null == _preferences) {
      getPreferences();
    }
  }
  void getPreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<void> saveColorData(List<String> ls) async {
    await _preferences!.setStringList("colorData", ls);
  }

  Future<List<String>?> getColorData() async {
    try {
      return _preferences!.getStringList("colorData");
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
      return null;
    }
  }
}
