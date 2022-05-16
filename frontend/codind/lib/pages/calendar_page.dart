import 'dart:math';

import 'package:codind/pages/base_pages/_mobile_base_page.dart';
import 'package:codind/providers/language_provider.dart';
import 'package:codind/utils/platform_utils.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:taichi/taichi.dart';

class MyWeekDayTile extends StatelessWidget {
  const MyWeekDayTile(
      {Key? key,
      required this.locale,
      required this.dayIndex,
      this.backgroundColor = const Color(0xffffffff),
      this.displayBorder = true,
      this.textStyle})
      : super(key: key);

  final String locale;
  final int dayIndex;

  /// Background color of single week day tile.
  final Color backgroundColor;

  /// Should display border or not.
  final bool displayBorder;

  /// Style for week day string.
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    List<String> weekTitles;

    if (locale == "zh_CN") {
      weekTitles = ["一", "二", "三", "四", "五", "六", "日"];
    } else {
      weekTitles = ["M", "T", "W", "T", "F", "S", "S"];
    }

    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(
          color: const Color(0xffdddddd),
          width: displayBorder ? 0.5 : 0,
        ),
      ),
      child: Text(
        weekTitles[dayIndex],
        style: textStyle ??
            const TextStyle(
              fontSize: 17,
              color: Color(0xff000000),
            ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CalendarStatefulWidget extends MobileBasePage {
  CalendarStatefulWidget({Key? key, required String pageName})
      : super(key: key, pageName: pageName);

  @override
  MobileBasePageState<MobileBasePage> getState() {
    return _CalendarStatefulWidgetState();
  }
}

class _CalendarStatefulWidgetState
    extends MobileBasePageState<CalendarStatefulWidget> {
  // double width = 600;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  @override
  Widget baseBuild(BuildContext context) {
    return MonthView(
      controller: context.read<EventController>(),
      onCellTap: (events, date) {
        debugPrint("[tap]: tap once ${date.toString()}");
        context.read<EventController>().add(
              CalendarEventData(
                  date: date,
                  endDate: date.add(Duration(days: 2)),
                  event: "test",
                  title: 'test title'),
            );
        // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        //   return _DayPage(
        //     date: date,
        //   );
        // }));
        debugPrint(
            "[EventController length]: ${context.read<EventController>().events.length}");
      },
      weekDayBuilder: (day) {
        return MyWeekDayTile(
            locale: context.read<LanguageControllerV2>().currentLang,
            dayIndex: day);
      },
      width: PlatformUtils.isMobile
          ? MediaQuery.of(context).size.height
          : min(MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height),
    );
  }
}

// ignore: must_be_immutable
class DayCalendarWidget extends MobileBasePage {
  DayCalendarWidget({Key? key, required this.date})
      : super(key: key, pageName: null);
  final DateTime date;

  @override
  MobileBasePageState<MobileBasePage> getState() {
    return _DayCalendarWidgetState();
  }
}

class _DayCalendarWidgetState extends MobileBasePageState<DayCalendarWidget> {
  @override
  Widget baseBuild(BuildContext context) {
    return Scaffold(
      body: DayView(
        initialDay: widget.date,
      ),
    );
  }
}

class _DayPage extends StatelessWidget {
  const _DayPage({Key? key, required this.date}) : super(key: key);
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return DayCalendarWidget(
      date: date,
    );
  }
}

class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CalendarStatefulWidget(
      key: UniqueKey(),
      pageName: '日程',
    );
  }
}

@immutable
class Event {
  final String title;

  const Event({this.title = "Title"});

  @override
  bool operator ==(Object other) => other is Event && title == other.title;

  @override
  int get hashCode => title.hashCode;

  @override
  String toString() => title;
}
