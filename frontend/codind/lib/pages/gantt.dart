/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-02-14 20:24:08
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-02-24 19:10:48
 */
import 'package:codind/bloc/gantt_bloc.dart';
import 'package:codind/entity/schedule.dart';
import 'package:codind/widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'package:codind/utils/utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:codind/utils/common.dart' as my;
import 'package:loading_overlay/loading_overlay.dart';

import '_schedule_detail_page.dart';

/// my gantt chart !!!
/// https://blog.csdn.net/szydwy/article/details/95047449 在手机端进行横竖屏切换
/// https://zhuanlan.zhihu.com/p/302687896

class GanttPage extends StatefulWidget {
  GanttPage({Key? key}) : super(key: key);

  @override
  State<GanttPage> createState() => _GanttPageState();
}

class _GanttPageState extends State<GanttPage> {
  late GanttBloc _ganttBloc;
  late CalendarType _calendarType;
  late int currentMonth;
  late int currentYear;
  final my.DateUtils _dateUtils = my.DateUtils();
  ScrollController scrollController = ScrollController();
  int _flexLeft = 5;
  late int _flexRight;

  @override
  void initState() {
    super.initState();
    _calendarType = CalendarType.year;
    currentMonth = _dateUtils.month;
    currentYear = _dateUtils.year;
    _ganttBloc = context.read<GanttBloc>();
    _flexRight = 10 - _flexLeft;
  }

  @override
  void dispose() {
    scrollController.dispose();
    if (PlatformUtils.isMobile) {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GanttBloc, GanttState>(builder: (context, state) {
      return LoadingOverlay(
          isLoading: _ganttBloc.state.isLoading,
          child: Scaffold(
            appBar: PlatformUtils.isMobile
                ? AppBar(
                    title: const Text("你的日程"),
                    centerTitle: true,
                  )
                : AppBar(
                    automaticallyImplyLeading: !PlatformUtils.isWeb,
                    elevation: 0,
                    title: SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("你的日程"),
                          _calendarType == CalendarType.month
                              ? SizedBox(
                                  width: 300,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              currentMonth -= 1;
                                              if (currentMonth == 0) {
                                                currentMonth = 12;
                                                currentYear -= 1;
                                              }
                                              context.read<GanttBloc>().add(
                                                  ChangeCurrentDateEvent(
                                                      month: currentMonth,
                                                      year: currentYear));
                                            });
                                          },
                                          icon: const Icon(
                                              Icons.navigate_before)),
                                      Text(currentYear.toString() +
                                          "." +
                                          currentMonth.toString()),
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              currentMonth += 1;
                                              if (currentMonth == 13) {
                                                currentMonth = 1;
                                                currentYear += 1;
                                              }

                                              context.read<GanttBloc>().add(
                                                  ChangeCurrentDateEvent(
                                                      month: currentMonth,
                                                      year: currentYear));
                                            });
                                          },
                                          icon:
                                              const Icon(Icons.navigate_next)),
                                    ],
                                  ),
                                )
                              : Container(
                                  margin: const EdgeInsets.only(right: 100),
                                  child: Text(_dateUtils.year.toString()),
                                )
                        ],
                      ),
                    ),
                    actions: [
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
            body: SingleChildScrollView(
                controller: scrollController, child: _build()),
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
                    icon: const Icon(Icons.add_box)),
                if (!PlatformUtils.isMobile)
                  IconButton(
                      onPressed: () {
                        if (_flexLeft <= 7) {
                          setState(() {
                            _flexLeft += 1;
                            _flexRight = 10 - _flexLeft;
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.add_circle,
                        color: Colors.blue,
                      )),
                if (!PlatformUtils.isMobile)
                  IconButton(
                      onPressed: () {
                        if (_flexRight <= 7) {
                          setState(() {
                            _flexRight += 1;
                            _flexLeft = 10 - _flexRight;
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.remove_circle,
                        color: Colors.blue,
                      )),
                if (PlatformUtils.isMobile)
                  IconButton(
                      onPressed: () {
                        debugPrint("[debug gantt]: clicked Orientation Button");
                        if (MediaQuery.of(context).orientation ==
                            Orientation.landscape) {
                          SystemChrome.setPreferredOrientations([
                            DeviceOrientation.portraitUp,
                            DeviceOrientation.portraitDown
                          ]);
                        } else {
                          SystemChrome.setPreferredOrientations([
                            DeviceOrientation.landscapeLeft,
                            DeviceOrientation.landscapeRight
                          ]);
                        }
                      },
                      icon: const Icon(
                        Icons.change_circle,
                        color: Colors.blue,
                      )),
              ],
            ),
          ));
    });
  }

  Widget _build() {
    if (!PlatformUtils.isMobile) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: _flexLeft,
            child: ThingsWidget(calendarType: _calendarType),
          ),
          Expanded(
            child: _calendarType == CalendarType.year
                ? CalendarWidget()
                : CalendarByMonth(),
            flex: _flexRight,
          )
        ],
      );
    } else {
      if (MediaQuery.of(context).orientation == Orientation.portrait) {
        return ThingsWidget(
          calendarType: CalendarType.year,
        );
      } else {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: _flexLeft,
              child: ThingsWidget(calendarType: _calendarType),
            ),
            Expanded(
              child: _calendarType == CalendarType.year
                  ? CalendarWidget()
                  : CalendarByMonth(),
              flex: _flexRight,
            )
          ],
        );
      }
    }
  }
}
