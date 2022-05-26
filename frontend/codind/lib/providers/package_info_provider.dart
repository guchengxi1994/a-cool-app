import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PackageInfoController extends ChangeNotifier {
  late PackageInfo _packageInfo;

  // PackageInfo get packageInfo => _packageInfo;
  String version = "";
  String buildNumber = "";

  init() async {
    _packageInfo = await PackageInfo.fromPlatform();
    version = _packageInfo.version;
    buildNumber = _packageInfo.buildNumber;
    notifyListeners();
  }
}
