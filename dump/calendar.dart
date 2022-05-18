// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously, prefer_const_constructors

/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-02-13 22:10:24
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-05-17 22:52:20
 */

/// diy a scroll bar  https://www.jianshu.com/p/c14c5bd649c2

import 'package:codind/bloc/gantt_bloc.dart';
import 'package:codind/pages/module_pages/_schedule_detail_page.dart'
    show ScheduleDetailPage;
import 'package:codind/providers/language_provider.dart';
import 'package:codind/router.dart';
import 'package:codind/utils/common.dart' as my;
import 'package:flutter/material.dart';
import 'package:dart_date/dart_date.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../entity/entity.dart';
import '../utils/utils.dart';

const double boxHeight = 30.5;

@Deprecated("use ```CalendarWidgetV2``` instead")
class CalendarWidget extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  CalendarWidget({Key? key}) : super(key: key);

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

@Deprecated("use ```CalendarWidgetV2``` instead")
class _CalendarWidgetState extends State<CalendarWidget> {
  ScrollController scrollController = ScrollController();
  ScrollController scrollControllerJan = ScrollController();
  ScrollController scrollControllerFeb = ScrollController();
  ScrollController scrollControllerMar = ScrollController();
  ScrollController scrollControllerApr = ScrollController();
  ScrollController scrollControllerMay = ScrollController();
  ScrollController scrollControllerJun = ScrollController();
  ScrollController scrollControllerJul = ScrollController();
  ScrollController scrollControllerAug = ScrollController();
  ScrollController scrollControllerSep = ScrollController();
  ScrollController scrollControllerOct = ScrollController();
  ScrollController scrollControllerNov = ScrollController();
  ScrollController scrollControllerDec = ScrollController();
  GlobalKey globalKey = GlobalKey();

  List<ScrollController> _scrollList = [];

  late double dx = 0;
  final my.DateUtils _dateUtils = my.DateUtils();

  // int year = 2022;
  Map<String, int> data = {};
  late GanttBloc _ganttBloc;

  @override
  void initState() {
    super.initState();
    _ganttBloc = context.read<GanttBloc>();
    _scrollList = [
      scrollControllerJan,
      scrollControllerFeb,
      scrollControllerMar,
      scrollControllerApr,
      scrollControllerMay,
      scrollControllerJun,
      scrollControllerJul,
      scrollControllerAug,
      scrollControllerSep,
      scrollControllerOct,
      scrollControllerNov,
      scrollControllerDec
    ];
    data = _dateUtils.data;
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    final ScrollMetrics metrics = notification.metrics;
    for (var i in _scrollList) {
      i.jumpTo(metrics.pixels);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    List<ScheduleDates> scheduleDates = _ganttBloc.state.getDates();
    List _days = data.values.toList();
    var _all = List.generate(31, (i) => i);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _days
          .asMap()
          .map((key, value) {
            var _l = List.generate(value, (i) => i);
            if (key == 0) {
              return MapEntry(
                  key,
                  NotificationListener<ScrollNotification>(
                    onNotification: _handleScrollNotification,
                    child: SingleChildScrollView(
                      physics: PlatformUtils.isWeb
                          ? const NeverScrollableScrollPhysics()
                          : const ScrollPhysics(),
                      key: UniqueKey(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: _l.map((e) {
                          return Container(
                            margin: const EdgeInsets.all(5),
                            height: 20,
                            width: 20,
                            alignment: Alignment.center,
                            color: const Color.fromARGB(255, 175, 147, 145),
                            child: Text((e + 1).toString()),
                          );
                        }).toList(),
                      ),
                    ),
                  ));
            }
            return MapEntry(
                key,
                SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  key: UniqueKey(),
                  scrollDirection: Axis.horizontal,
                  controller: _scrollList[key - 1],
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: _all.map((e) {
                      if (e < _days[key]) {
                        var utc =
                            DateTime(_dateUtils.year, key, e + 1).isSaturday ||
                                DateTime(_dateUtils.year, key, e + 1).isSunday;
                        var thisDay = DateTime(_dateUtils.year, key, e + 1);
                        // var hasThings = _ganttBloc.state
                        //     .getDates()
                        //     .contains(
                        //         DateTime(_dateUtils.year, key, e + 1));
                        BoxStatus status = BoxStatus.nothing;
                        for (var sd in scheduleDates) {
                          if (sd.dates.contains(thisDay)) {
                            status = sd.status;
                          }
                        }

                        return DayBox(
                          isWeekend: utc,
                          rowId: key,
                          columnId: e,
                          boxStatus: status,
                          year: _dateUtils.year,
                        );
                      } else {
                        return DayBox(
                          isWeekend: false,
                          rowId: key,
                          columnId: e,
                          boxStatus: BoxStatus.cannotSelected,
                          year: _dateUtils.year,
                        );
                      }
                    }).toList(),
                  ),
                ));
          })
          .values
          .toList(),
    );
  }
}

// ignore: must_be_immutable
class DayBox extends StatefulWidget {
  DayBox(
      {Key? key,
      required this.year,
      required this.rowId,
      required this.columnId,
      this.boxStatus,
      required this.isWeekend})
      : super(key: key);
  int rowId;
  int columnId;
  BoxStatus? boxStatus;
  bool isWeekend;
  int year;

  @override
  State<DayBox> createState() => _DayBoxState();
}

class _DayBoxState extends State<DayBox> {
  late Color backgroundColor;
  String tootipMessage = "";
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    if (widget.boxStatus == BoxStatus.nothing) {
      backgroundColor = Colors.white;
    } else if (widget.boxStatus == BoxStatus.delayed) {
      backgroundColor = Colors.red;
    } else if (widget.boxStatus == BoxStatus.done) {
      backgroundColor = Colors.green;
    } else if (widget.boxStatus == BoxStatus.underGoing) {
      backgroundColor = const Color.fromARGB(255, 28, 103, 189);
    } else {
      backgroundColor = Colors.yellow;
    }

    tootipMessage = widget.isWeekend
        ? "${widget.rowId}月${widget.columnId}日 周末"
        : "${widget.rowId}月${widget.columnId}日";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
      height: 20,
      width: 20,
      decoration: BoxDecoration(
          color: backgroundColor,
          border: widget.isWeekend
              ? Border.all(
                  color: const Color.fromARGB(255, 47, 98, 133),
                  width: isSelected ? 2 : 1)
              : Border.all(color: Colors.grey[500]!, width: isSelected ? 2 : 1),
          borderRadius: BorderRadius.circular(5)),
      child: !PlatformUtils.isWeb
          ? Tooltip(
              message: widget.boxStatus != BoxStatus.cannotSelected
                  ? tootipMessage
                  : "",
              child: InkWell(
                onTap: widget.boxStatus == BoxStatus.cannotSelected
                    ? null
                    : () {
                        // debugPrint(tootipMessage);
                        setState(() {
                          isSelected = !isSelected;
                        });
                      },
                onDoubleTap: () async {
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
              ),
            )
          : InkWell(
              onTap: widget.boxStatus == BoxStatus.cannotSelected
                  ? null
                  : () {
                      // debugPrint(tootipMessage);
                      setState(() {
                        isSelected = !isSelected;
                      });
                    },
              onDoubleTap: () async {
                var result = await Global.navigatorKey.currentState!
                    .push(MaterialPageRoute(builder: (_) {
                  return ScheduleDetailPage(
                    schedule: null,
                    currentYear: widget.year,
                    month: widget.rowId,
                    day: widget.columnId + 1,
                  );
                }));

                if (result.runtimeType == Schedule) {
                  debugPrint(
                      "[debug calender-add-schedule]: ${result.toJson()}");

                  context
                      .read<GanttBloc>()
                      .add(AddScheduleEvent(schedule: result));
                }
              },
            ),
    );
  }
}

class CalendarWidgetV2 extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  CalendarWidgetV2({Key? key}) : super(key: key);

  @override
  State<CalendarWidgetV2> createState() => _CalendarWidgetV2State();
}

class _CalendarWidgetV2State extends State<CalendarWidgetV2> {
  final my.DateUtils _dateUtils = my.DateUtils();
  late GanttBloc _ganttBloc;
  late final List<int> _days = _dateUtils.data.values.toList();
  @override
  void initState() {
    super.initState();
    _ganttBloc = context.read<GanttBloc>();
  }

  @override
  Widget build(BuildContext context) {
    List<ScheduleDates> scheduleDates = _ganttBloc.state.getDates();
    debugPrint("[dates list length]:${scheduleDates.length}");
    var currentWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: 35 * 32,
      height: 35 * 13,
      child: GridView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: 32 * 13,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 32,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (context, index) {
            var rowId = index ~/ 32;
            if (rowId == 0) {
              if ((index % 32) == 0) {
                if (currentWidth < 35 * 32) {
                  return Center(child: Text(""));
                } else {
                  return Center(child: Text("月/天"));
                }
              }
              return Container(
                margin: EdgeInsets.all(1),
                color: Color.fromARGB(255, 185, 141, 105),
                child: Center(child: Text((index % 32).toString())),
              );
            }

            var lang = context.read<LanguageControllerV2>().currentLang;

            var months =
                lang == "zh_CN" ? _dateUtils.months_CN : _dateUtils.months_en;
            var columnId = (index % 32);
            if (columnId == 0) {
              if (currentWidth < 35 * 32) {
                return Center(child: Text(rowId.toString()));
              }
              return Center(child: Text(months[rowId]));
            }

            if (columnId < _days[rowId] + 1) {
              var utc = DateTime(_dateUtils.year, rowId, columnId).isSaturday ||
                  DateTime(_dateUtils.year, rowId, columnId).isSunday;
              var thisDay = DateTime(_dateUtils.year, rowId, columnId);

              BoxStatus status = BoxStatus.nothing;
              for (var sd in scheduleDates) {
                if (sd.dates.contains(thisDay)) {
                  status = sd.status;
                }
              }

              return DayBox(
                isWeekend: utc,
                rowId: rowId,
                columnId: columnId,
                boxStatus: status,
                year: _dateUtils.year,
              );
            } else {
              return DayBox(
                isWeekend: false,
                rowId: rowId,
                columnId: columnId,
                boxStatus: BoxStatus.cannotSelected,
                year: _dateUtils.year,
              );
            }
          }),
    );
  }
}
