import 'package:codind/bloc/gantt_bloc.dart';
import 'package:codind/entity/schedule.dart';
import 'package:codind/utils/utils.dart' as my;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// ./calendar.dart is a calendar in a year
///  this is for a specific month

const double containerSize = 20;
const double paddingSize = 5;

class CalendarByMonth extends StatefulWidget {
  CalendarByMonth({Key? key}) : super(key: key);

  @override
  State<CalendarByMonth> createState() => _CalendarByMonthState();
}

class _CalendarByMonthState extends State<CalendarByMonth> {
  late int currentMonth;
  late int currentYear;
  my.DateUtils dateUtils = my.DateUtils();
  late GanttBloc _ganttBloc;
  ScrollController scrollController = ScrollController();
  ScrollController scrollCanvasController = ScrollController();

  @override
  void initState() {
    super.initState();
    currentMonth = dateUtils.month;
    currentYear = dateUtils.year;
    _ganttBloc = context.read<GanttBloc>();
  }

  @override
  Widget build(BuildContext context) {
    var _l = List.generate(
        my.DateUtils.getCurrentMonthDays(currentYear, currentMonth), (i) => i);
    return Scaffold(
      appBar: AppBar(
        elevation: my.PlatformUtils.isMobile ? 4 : 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: SizedBox(
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
                    });
                  },
                  icon: const Icon(Icons.navigate_before)),
              Text(currentYear.toString() + "." + currentMonth.toString()),
              IconButton(
                  onPressed: () {
                    setState(() {
                      currentMonth += 1;
                      if (currentMonth == 13) {
                        currentMonth = 1;
                        currentYear += 1;
                      }
                    });
                  },
                  icon: const Icon(Icons.navigate_next)),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              key: UniqueKey(),
              scrollDirection: Axis.horizontal,
              child: Row(
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
            ),
            CustomPaint(
              foregroundPainter: GanttPainter(
                currentMonth: currentMonth,
                currentYear: currentYear,
                scheduleList:
                    _ganttBloc.state.grepSchedules(currentYear, currentMonth),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: scrollCanvasController,
                key: UniqueKey(),
                child: Container(
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// use canvas to draw gantt
class GanttPainter extends CustomPainter {
  List<ScheduleGanttModel> scheduleList;
  int currentYear;
  int currentMonth;
  GanttPainter(
      {required this.currentMonth,
      required this.currentYear,
      required this.scheduleList});

  @override
  void paint(Canvas canvas, Size size) {
    /// Offset( 水平方向,垂直方向)
    ///
    for (var sl in scheduleList) {
      var line;
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
        for (var s in sl.subjects) {
          // var _duration = double.parse(s.duation) ;
          if (s.subTitle != "__will_not_be_paint__") {
            var _fromDay = s.fromDay;
            var _endDay = s.toDay;
            debugPrint(_fromDay.toString());
            debugPrint(_endDay.toString());
            var _left = paddingSize +
                (_fromDay - 1) * (paddingSize * 2 + containerSize);
            var _right = paddingSize +
                (_endDay) * (paddingSize * 2 + containerSize) +
                -2 * paddingSize;

            canvas.drawLine(Offset(_left, 20), Offset(_right, 20), line);
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
