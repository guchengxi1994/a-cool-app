/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-02-01 10:03:20
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-02-01 10:07:39
 */
import 'package:flutter/material.dart';

import '../../globals.dart';

@Deprecated("will be removed")
mixin BackScreenMixin<T extends StatefulWidget> on State<T> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: backScreenBuild(context),
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.chevron_left,
              size: leftBackIconSize,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ));
  }

  backScreenBuild(BuildContext context) {}
}
