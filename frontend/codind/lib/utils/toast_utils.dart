import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

void showToastMessage(String message, BuildContext? context,
    {Color? color}) async {
  await SmartDialog.showToast(message, debounceTemp: true);
}
