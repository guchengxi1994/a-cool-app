import 'dart:async';
import 'dart:convert';

import 'package:codind/_apis.dart';
import 'package:codind/pages/base_pages/_mobile_base_page.dart';
import 'package:codind/router.dart';
import 'package:codind/utils/dio_utils.dart';
import 'package:codind/utils/toast_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

// ignore: must_be_immutable
class QrPage extends MobileBasePage {
  QrPage({Key? key, required this.qrInfo, required String pageName})
      : super(key: key, pageName: pageName);
  String qrInfo;

  @override
  MobileBasePageState<MobileBasePage> getState() {
    return _QrPageState();
  }
}

class _QrPageState extends MobileBasePageState<QrPage> {
  // init timer
  late Timer? _timer;
  final DioUtils _dioUtils = DioUtils();

  @override
  void initState() {
    super.initState();
    debugPrint("[qr info ] ${widget.qrInfo}");
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      getLoginStatus(widget.qrInfo);
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  getLoginStatus(String key) async {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) async {
      String url = apiRoute + Apis['getVal']! + key;

      Response? response = await _dioUtils.get(url);
      if (response != null && response.data != null) {
        var _map = jsonDecode(response.data);

        if (_map['data'] != 'undefined') {
          stopTimer();
          debugPrint("[login info] ${_map['data']}");

          /// 这里要执行loginScreen 的登录逻辑

          if (Global.navigatorKey.currentState != null) {
            Global.navigatorKey.currentState!
                .pushNamedAndRemoveUntil(Routers.pageMain, (route) => false);
          } else {
            showToastMessage("登陆失败", context);
          }
        } else {
          debugPrint("[still connect to server]");
        }
      }
    });
  }

  @override
  baseBuild(BuildContext context) {
    return Center(
      child: QrImage(
        version: QrVersions.auto,
        data: widget.qrInfo,
        size: 200,
      ),
    );
  }
}
