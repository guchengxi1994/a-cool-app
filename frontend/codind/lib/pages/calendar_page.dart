import 'package:codind/pages/base_pages/_mobile_base_page.dart';
import 'package:codind/providers/language_provider.dart';
import 'package:codind/utils/extensions/datetime_extension.dart';
import 'package:codind/utils/platform_utils.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:taichi/taichi.dart';
// ignore: implementation_imports
import 'package:taichi/src/UI/calendar_view/src/components/common_components.dart';

import '../_styles.dart';
import '../widgets/calendar.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
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
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return CalendarWidget();
                }));
              },
              icon: const Icon(
                Icons.edit_calendar_sharp,
                size: AppTheme.leftBackIconSize,
                color: Colors.black,
              )),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: Center(
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
                  context.read<LanguageControllerV2>().currentLang == "zh_CN"
                      ? _monthStringBuilderZh
                      : _monthStringBuilder,
            );
          },
          onCellTap: (events, date) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return DayCalendarWidget(
                date: date,
                pageName:
                    context.read<LanguageControllerV2>().currentLang == "zh_CN"
                        ? "${date.toDateString(DatetimeSeparator.chinese)}的日程"
                        : date.toDateString(DatetimeSeparator.slash),
              );
            }));
            count += 1;
          },
          weekDayBuilder: (day) {
            return MyWeekDayTile(
                locale: context.read<LanguageControllerV2>().currentLang,
                dayIndex: day);
          },
          width:
              PlatformUtils.isMobile ? MediaQuery.of(context).size.height : 500,
        ),
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
  late DateTime _dateTime = widget.date;

  @override
  Widget baseBuild(BuildContext context) {
    return Scaffold(
      body: DayView(
        /// 这里要调整一下
        onPageChange: (date, page) {
          debugPrint("[date] : ${date.toString()}");
          setState(() {
            _dateTime = date;
          });
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
    return CalendarStatefulWidget(
      key: UniqueKey(),
    );
  }
}
