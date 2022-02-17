/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-02-14 20:24:08
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-02-14 20:39:41
 */
import 'package:codind/bloc/gantt_bloc.dart';
import 'package:codind/entity/schedule.dart';
import 'package:codind/widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'package:codind/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '_schedule_detail_page.dart';

/// my gantt chart !!!

class GanttPage extends StatefulWidget {
  GanttPage({Key? key}) : super(key: key);

  @override
  State<GanttPage> createState() => _GanttPageState();
}

class _GanttPageState extends State<GanttPage> {
  late GanttBloc _ganttBloc;
  late CalendarType _calendarType;

  @override
  void initState() {
    super.initState();
    _calendarType = CalendarType.year;
    _ganttBloc = context.read<GanttBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GanttBloc, GanttState>(builder: (context, state) {
      return Scaffold(
        appBar: PlatformUtils.isMobile
            ? null
            : AppBar(elevation: 0, actions: [
                IconButton(
                    onPressed: () {
                      if (_calendarType == CalendarType.month) {
                        _calendarType = CalendarType.year;
                      } else {
                        _calendarType = CalendarType.month;
                      }
                      setState(() {});
                    },
                    icon: _calendarType == CalendarType.month
                        ? const Icon(Icons.switch_left)
                        : const Icon(Icons.switch_right))
              ]),
        body: ((!PlatformUtils.isAndroid) && (!PlatformUtils.isIOS))
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: ThingsWidget(calendarType: _calendarType),
                  ),
                  Expanded(
                    child: _calendarType == CalendarType.year
                        ? CalendarWidget()
                        : CalendarByMonth(),
                    flex: 1,
                  )
                ],
              )
            : ThingsWidget(
                calendarType: CalendarType.year,
              ),
        bottomSheet: Row(
          children: [
            IconButton(
                onPressed: () async {
                  var result = await Global.navigatorKey.currentState!
                      .push(MaterialPageRoute(builder: (_) {
                    return ScheduleDetailPage(
                      schedule: null,
                    );
                  }));

                  if (result.runtimeType == Schedule) {
                    context
                        .read<GanttBloc>()
                        .add(AddScheduleEvent(schedule: result));
                  }
                },
                icon: const Icon(Icons.add_circle))
          ],
        ),
      );
    });
  }
}

class GanttBlocPage extends StatelessWidget {
  const GanttBlocPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GanttBloc()..add(InitialGanttEvent()),
      child: GanttPage(),
    );
  }
}
