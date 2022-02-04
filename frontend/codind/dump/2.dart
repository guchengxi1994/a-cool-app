/*
 * @Descripttion: for format code
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-02-04 10:27:53
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-02-04 10:42:57
 */

import 'package:flutter/material.dart';

class name extends StatefulWidget {
  name({Key? key}) : super(key: key);

  @override
  State<name> createState() => _nameState();
}

class _nameState extends State<name> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuItem(
      value: "**",
      child: Text("插入斜体"),
    );
  }
}
