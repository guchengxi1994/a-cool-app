import 'package:codind/bloc/gantt_bloc.dart';
import 'package:codind/utils/utils.dart' as my;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// ./calendar.dart is a calendar in a year
///  this is for a specific month

const double containerSize = 20;
const double paddingSize = 5;

class CalendarByMonth extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  CalendarByMonth({Key? key}) : super(key: key);

  @override
  State<CalendarByMonth> createState() => _CalendarByMonthState();
}

class _CalendarByMonthState extends State<CalendarByMonth> {
  my.DateUtils dateUtils = my.DateUtils();
  late GanttBloc _ganttBloc;
  ScrollController scrollController = ScrollController();
  ScrollController scrollCanvasController = ScrollController();

  // bool _handleScrollNotification(ScrollNotification notification) {
  //   final ScrollMetrics metrics = notification.metrics;
  //   scrollCanvasController.jumpTo(metrics.pixels);
  //   return true;
  // }

  @override
  void initState() {
    super.initState();
    _ganttBloc = context.read<GanttBloc>();
  }

  @override
  Widget build(BuildContext context) {
    var _l = List.generate(
        my.DateUtils.getCurrentMonthDays(
            _ganttBloc.state.currentYear, _ganttBloc.state.currentMonth),
        (i) => i);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: _l.map((e) {
              return Container(
                margin: const EdgeInsets.all(paddingSize),
                height: containerSize,
                width: containerSize,
                alignment: Alignment.center,
                child: Text((e + 1).toString()),
                color: const Color.fromARGB(255, 175, 147, 145),
              );
            }).toList(),
          ),
          CustomPaint(
            foregroundPainter: GanttPainter(
              currentMonth: _ganttBloc.state.currentMonth,
              currentYear: _ganttBloc.state.currentYear,
              monthDay: _l.length,
              scheduleList: _ganttBloc.state.grepSchedules(
                  _ganttBloc.state.currentYear, _ganttBloc.state.currentMonth),
            ),
            child: Container(
              height: 200,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );

    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     NotificationListener<ScrollNotification>(
    //         onNotification: _handleScrollNotification,
    //         child: SingleChildScrollView(
    //           key: UniqueKey(),
    //           scrollDirection: Axis.horizontal,
    //           child: Row(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             children: _l.map((e) {
    //               return Container(
    //                 margin: const EdgeInsets.all(paddingSize),
    //                 height: containerSize,
    //                 width: containerSize,
    //                 alignment: Alignment.center,
    //                 child: Text((e + 1).toString()),
    //                 color: const Color.fromARGB(255, 175, 147, 145),
    //               );
    //             }).toList(),
    //           ),
    //         )),
    //     CustomPaint(
    //       foregroundPainter: GanttPainter(
    //         currentMonth: _ganttBloc.state.currentMonth,
    //         currentYear: _ganttBloc.state.currentYear,
    //         monthDay: _l.length,
    //         scheduleList: _ganttBloc.state.grepSchedules(
    //             _ganttBloc.state.currentYear, _ganttBloc.state.currentMonth),
    //       ),
    //       child: SingleChildScrollView(
    //         scrollDirection: Axis.horizontal,
    //         controller: scrollCanvasController,
    //         key: UniqueKey(),
    //         child: Container(
    //           color: Colors.white,
    //         ),
    //       ),
    //     )
    //   ],
    // );
  }
}

/// use canvas to draw gantt
class GanttPainter extends CustomPainter {
  List<ScheduleGanttModel> scheduleList;
  int currentYear;
  int currentMonth;
  int monthDay;
  GanttPainter(
      {required this.currentMonth,
      required this.currentYear,
      required this.scheduleList,
      required this.monthDay});

  double width = containerSize + paddingSize * 2;
  double height = containerSize + paddingSize * 2;

  @override
  void paint(Canvas canvas, Size size) {
    /// Offset( 水平方向,垂直方向)

    int _count = getChildrenNumber(scheduleList);
    if (_count > 0) {
      _count = _count + scheduleList.length - 1;
      var paint = Paint()
        ..style = PaintingStyle.stroke //线
        ..color = const Color.fromARGB(255, 133, 135, 139)
        ..strokeWidth = 0.5;
      for (int i = 0; i <= monthDay; i++) {
        double dx = width * i;
        canvas.drawLine(
            Offset(dx, 0), Offset(dx, (_count + 1) * height), paint);
      }

      for (int i = 0; i <= _count + 1; i++) {
        double dy = height * i;
        canvas.drawLine(Offset(0, dy), Offset(width * monthDay, dy), paint);
      }

      var count = 0;

      for (var sl in scheduleList) {
        Paint line;
        if (sl.status == BoxStatus.delayed) {
          line = Paint()
            ..style = PaintingStyle.stroke
            ..color = Colors.red
            ..strokeWidth = 20.0;
        } else if (sl.status == BoxStatus.underGoing) {
          line = Paint()
            ..style = PaintingStyle.stroke
            ..color = Colors.blue
            ..strokeWidth = 20.0;
        } else {
          line = Paint()
            ..style = PaintingStyle.stroke
            ..color = Colors.green
            ..strokeWidth = 20.0;
        }

        if (sl.subjects.isNotEmpty) {
          count = count + 1;
          for (var s in sl.subjects) {
            if (s.subTitle != notPaintingWarning) {
              count = count + 1;
              var _fromDay = s.fromDay;
              var _endDay = s.toDay;
              // debugPrint(_fromDay.toString());
              // debugPrint(_endDay.toString());
              var _left = paddingSize +
                  (_fromDay - 1) * (paddingSize * 2 + containerSize);
              var _right = paddingSize +
                  (_endDay) * (paddingSize * 2 + containerSize) +
                  -2 * paddingSize;
              // print(count);
              canvas.drawLine(Offset(_left, count * width - 15),
                  Offset(_right, count * width - 15), line);
            }
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

int getChildrenNumber(List<ScheduleGanttModel> scheduleList) {
  int count = 0;
  // print(scheduleList.length);
  for (var i in scheduleList) {
    for (var j in i.subjects) {
      if (j.subTitle != notPaintingWarning) {
        // print(j.subTitle);
        count += 1;
      } else {
        debugPrint("debugPrint:not paint");
      }
    }
  }
  // print(count);
  return count;
}
