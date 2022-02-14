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
    if ((!PlatformUtils.isAndroid) && (!PlatformUtils.isIOS)) {
      return Row(
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
      );
    } else {
      return ThingsWidget();
    }
  }
}
