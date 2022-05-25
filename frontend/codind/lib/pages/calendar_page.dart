import 'package:codind/pages/base_pages/_mobile_base_page.dart';
import 'package:codind/providers/language_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:taichi/taichi.dart';
// ignore: implementation_imports
import 'package:taichi/src/UI/calendar_view/src/components/common_components.dart';
import 'package:codind/utils/no_web/sqlite_utils.dart'
    if (dart.library.html) 'package:codind/utils/web/sqlite_utils_web.dart';

import '../_styles.dart';
import '../utils/utils.dart';
import 'module_pages/_create_new_todo_page_v2.dart';
import 'package:codind/utils/common.dart' as my;

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
  CalendarStatefulWidget({
    Key? key,
  }) : super(key: key, pageName: null);

  @override
  MobileBasePageState<MobileBasePage> getState() {
    return _CalendarStatefulWidgetState();
  }
}

class _CalendarStatefulWidgetState
    extends MobileBasePageState<CalendarStatefulWidget> {
  int count = 0;
  final GlobalKey<MonthViewState> globalKey = GlobalKey();
  final GlobalKey _bottomKey = GlobalKey();
  final GlobalKey _titleKey = GlobalKey();
  final GlobalKey _bodyKey = GlobalKey();

  static const double widgetWidth = 450;
  PersistenceStorage ps = PersistenceStorage();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (await ps.getCalendarPageFirstOpen()) {
        ShowCaseWidget.of(context)!
            .startShowCase([_titleKey, _bodyKey, _bottomKey]);
        await ps.setCalendarPageFirstOpen();
      }
    });
  }

  String _monthStringBuilderZh(DateTime date, {DateTime? secondaryDate}) {
    return "${date.year}年${date.month}月";
  }

  String _monthStringBuilder(DateTime date, {DateTime? secondaryDate}) {
    return "${date.month} - ${date.year}";
  }

  @override
  Widget baseBuild(BuildContext context) {
    return Scaffold(
      bottomSheet: buildBottomSheet(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.baseAppbarColor,
        elevation: 0,
        title: const Text(
          "日程",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.chevron_left,
              size: AppTheme.leftBackIconSize,
              color: Color.fromARGB(255, 78, 63, 63),
            )),
        actions: [
          Showcase(
              key: _titleKey,
              description: "点击查看全年日程",
              child: IconButton(
                  onPressed: () {
                    if (TaichiDevUtils.isMobile) {
                      showToastMessage("请使用桌面版打开本页面");
                      return;
                    }

                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return YearCalendarWrapper();
                    }));
                  },
                  icon: const Icon(
                    Icons.calendar_month,
                    size: AppTheme.leftBackIconSize,
                    color: Colors.black,
                  ))),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: Row(
        children: [
          Showcase(
              key: _bodyKey,
              description: "点击创建新日程，长按查看详情",
              child: const SizedBox(
                width: 10,
              )),
          Expanded(
              child: Container(
            padding: const EdgeInsets.only(bottom: 50, top: 10),
            child: Center(
              child: MonthView(
                key: globalKey,
                controller: context.read<EventController>(),
                headerBuilder: (date) {
                  return CalendarPageHeader(
                    leftIcon: Icons.arrow_left,
                    rightIcon: Icons.arrow_right,
                    onTitleTapped: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: date,
                        firstDate: date.subtract(const Duration(days: 1000)),
                        lastDate: date.add(const Duration(days: 1000)),
                      );

                      if (selectedDate == null) return;
                      globalKey.currentState!.jumpToMonth(selectedDate);
                    },
                    onPreviousDay: globalKey.currentState!.previousPage,
                    onNextDay: globalKey.currentState!.nextPage,
                    date: date,
                    dateStringBuilder:
                        context.read<LanguageControllerV2>().currentLang ==
                                "zh_CN"
                            ? _monthStringBuilderZh
                            : _monthStringBuilder,
                  );
                },
                onDateLongPress: (date) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return DayCalendarWidget(
                      date: date,
                      pageName: "当天日程",
                    );
                  }));
                },
                onCellTap: (events, date) async {
                  await Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return CreateNewTodoV2(
                      date: date,
                    );
                  }));
                },
                weekDayBuilder: (day) {
                  return MyWeekDayTile(
                      locale: context.read<LanguageControllerV2>().currentLang,
                      dayIndex: day);
                },
                width: TaichiDevUtils.isMobile
                    ? (MediaQuery.of(context).size.width - 20)
                    : widgetWidth,
              ),
            ),
          ))
        ],
      ),
    );
  }

  Widget buildBottomSheet() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: Row(
        children: [
          Showcase(
            key: _bottomKey,
            description: "点击创建多天日程",
            child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.add,
                  size: AppTheme.leftBackIconSize,
                  color: Color.fromARGB(255, 78, 63, 63),
                )),
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class DayCalendarWidget extends MobileBasePage {
  DayCalendarWidget({Key? key, required this.date, required String pageName})
      : super(key: key, pageName: pageName);
  final DateTime date;

  @override
  MobileBasePageState<MobileBasePage> getState() {
    return _DayCalendarWidgetState();
  }
}

class _DayCalendarWidgetState extends MobileBasePageState<DayCalendarWidget> {
  late final DateTime _dateTime = widget.date;
  final GlobalKey<DayViewState> globalKey = GlobalKey();
  SqliteUtils sqliteUtils = SqliteUtils();

  String _dayStringBuilderZh(DateTime date, {DateTime? secondaryDate}) {
    return "${date.year}年${date.month}月${date.day}日";
  }

  String _dayStringBuilder(DateTime date, {DateTime? secondaryDate}) {
    return "${date.month} - ${date.year}-${date.day}";
  }

  @override
  Widget baseBuild(BuildContext context) {
    return Scaffold(
      body: DayView(
        controller: context.read<EventController>(),
        minDay: DateTime(2022, 1, 1),
        maxDay: DateTime(2100, 1, 1),
        key: globalKey,
        onEventTap: (calendarDataList, date) async {
          debugPrint("[debug datetime]:$date");
          debugPrint("[debug calendar list]:${calendarDataList.length}");
          debugPrint("[event data]:${calendarDataList.first.toJson()}");
          await showCupertinoDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: const Text("修改状态"),
                  content: Container(
                    height: 200,
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        InkWell(
                          child: Container(
                              width: 200,
                              padding: const EdgeInsets.all(5),
                              color: Colors.lightBlue,
                              child: const Text(
                                "标记为已完成",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )),
                          onTap: () async {
                            await sqliteUtils.setEventStatus(
                                calendarDataList.first.event as int, 1);
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pop();
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        InkWell(
                          child: Container(
                              width: 200,
                              padding: const EdgeInsets.all(5),
                              color: Colors.redAccent,
                              child: const Text(
                                "标记为放弃",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )),
                          onTap: () async {
                            await sqliteUtils.setEventStatus(
                                calendarDataList.first.event as int, 2);
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    CupertinoActionSheetAction(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("取消"))
                  ],
                );
              });
        },
        dayTitleBuilder: (date) {
          return CalendarPageHeader(
            leftIcon: Icons.arrow_left,
            rightIcon: Icons.arrow_right,
            onTitleTapped: () async {
              final selectedDate = await showDatePicker(
                context: context,
                initialDate: date,
                firstDate: date.subtract(const Duration(days: 1000)),
                lastDate: date.add(const Duration(days: 1000)),
              );

              if (selectedDate == null) return;
              globalKey.currentState!.jumpToDate(selectedDate);
            },
            onPreviousDay: globalKey.currentState!.previousPage,
            onNextDay: globalKey.currentState!.nextPage,
            date: date,
            dateStringBuilder:
                context.read<LanguageControllerV2>().currentLang == "zh_CN"
                    ? _dayStringBuilderZh
                    : _dayStringBuilder,
          );
        },
        initialDay: _dateTime,
      ),
    );
  }
}

class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      autoPlayDelay: const Duration(seconds: 3),
      blurValue: 1,
      builder: Builder(
          builder: (context) => CalendarStatefulWidget(
                key: UniqueKey(),
              )),
    );
  }
}

// ignore: must_be_immutable
class YearCalendarWrapper extends MobileBasePage {
  YearCalendarWrapper({Key? key}) : super(key: key, pageName: null);

  @override
  MobileBasePageState<MobileBasePage> getState() {
    return _YearCalendarWrapperState();
  }
}

class _YearCalendarWrapperState
    extends MobileBasePageState<YearCalendarWrapper> {
  late int currentMonth;
  late int currentYear;
  final my.DateUtils _dateUtils = my.DateUtils();
  // ignore: unused_field

  @override
  void initState() {
    super.initState();
    currentMonth = _dateUtils.month;
    currentYear = _dateUtils.year;
  }

  @override
  Widget baseBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.baseAppbarColor,
        elevation: 0,
        title: Text(
          "$currentYear",
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.chevron_left,
              size: AppTheme.leftBackIconSize,
              color: Color.fromARGB(255, 78, 63, 63),
            )),
      ),
      body: SingleChildScrollView(
        child: YearView(
          controller: context.read<EventController>(),
          locale: context.read<LanguageControllerV2>().currentLang,
        ),
      ),
    );
  }
}
