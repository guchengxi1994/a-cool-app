/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-04-07 22:02:10
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-04-07 22:25:36
 */

import 'package:codind/router.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomListTile extends StatelessWidget {
  CustomListTile(
      {Key? key,
      this.nextPage,
      this.route,
      required this.style,
      required this.title,
      required this.trailing,
      this.onTap})
      : super(key: key);
  Widget? nextPage;
  String? route;
  TextStyle style;
  String title;
  Widget trailing;
  final onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListTile(
        onTap: () async {
          if (route != null) {
            Global.navigatorKey.currentState!.pushNamed(route!);
          }

          if (nextPage != null) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return nextPage!;
            }));
          }

          if (onTap != null) {
            return onTap();
          }

          return;
        },
        title: Text(
          title,
          style: style,
        ),
        trailing: trailing,
      ),
    );
  }
}
