import 'package:codind/pages/base_pages/_base_stateless_page.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

// ignore: must_be_immutable
class QrPage extends BaseStatelessPage {
  QrPage({Key? key, required this.qrInfo, required String pageName})
      : super(key: key, pageName: pageName);

  String qrInfo;

  @override
  baseBuild(BuildContext context) {
    return Center(
      child: QrImage(
        version: QrVersions.auto,
        data: qrInfo,
        size: 200,
      ),
    );
  }
}
