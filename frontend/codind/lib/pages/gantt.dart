/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-02-14 20:24:08
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-02-14 20:39:41
 */
import 'package:codind/widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'package:codind/utils/utils.dart';

/// my gantt chart !!!

class GanttPage extends StatefulWidget {
  GanttPage({Key? key}) : super(key: key);

  @override
  State<GanttPage> createState() => _GanttPageState();
}

class _GanttPageState extends State<GanttPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ((!PlatformUtils.isAndroid) && (!PlatformUtils.isIOS))
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: ThingsWidget(),
                ),
                Expanded(
                  child: CalendarWidget(),
                  flex: 1,
                )
              ],
            )
          : ThingsWidget(),
    );
  }
}
