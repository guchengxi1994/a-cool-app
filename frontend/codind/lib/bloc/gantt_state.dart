/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-02-15 19:55:19
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-02-15 22:04:39
 */
part of 'gantt_bloc.dart';

enum GanttStatus {
  initial,
  addSchedule,
  addSubject,
  changeSchedule,
  changeSubject,
  removeSchedule,
  removeSubject
}

class GanttState extends Equatable {
  final GanttStatus status;
  final List<Schedule> scheduleList;
  final Schedule? operatedSchdule;

  const GanttState(
      {this.status = GanttStatus.initial,
      this.scheduleList = const [],
      this.operatedSchdule});

  @override
  List<Object> get props => [status, scheduleList];

  GanttState copyWith(GanttStatus? status, List<Schedule>? scheduleList,
      Schedule? operatedSchdule) {
    return GanttState(
        status: status ?? this.status,
        scheduleList: scheduleList ?? this.scheduleList,
        operatedSchdule: operatedSchdule);
  }

  List<ScheduleGanttModel> grepSchedules(int currentYear, int currentMonth) {
    List<ScheduleGanttModel> _sdList = [];
    var today = DateTime.now();
    for (int i = 0; i < scheduleList.length; i++) {
      var s = scheduleList[i];
      List<Subject> _result = [];
      if (s.subject != null) {
        for (var sb in s.subject!) {
          var fromDate = sb.from!.split(" ")[0];
          var endDate = sb.to!.split(" ")[0];
          var fromMonth = int.parse(fromDate.split("-")[1]);
          var toMonth = int.parse(endDate.split("-")[1]);
          if (fromMonth != currentMonth && toMonth != currentMonth) {
            _result.add(Subject(subTitle: "__will_not_be_paint__"));
          } else {
            if (fromMonth == currentMonth && toMonth == fromMonth) {
              _result.add(sb);
            } else {
              var _tmp = Subject.fromJson(sb.toJson());
              if (fromMonth < currentMonth) {
                _tmp.from = currentYear.toString() +
                    "-" +
                    currentMonth.toString() +
                    "-" +
                    "1";
              }

              if (toMonth > currentMonth) {
                _tmp.to = currentYear.toString() +
                    "-" +
                    currentMonth.toString() +
                    "-" +
                    my.DateUtils.getCurrentMonthDays(currentYear, currentMonth)
                        .toString();
              }

              _result.add(_tmp);
            }
          }

          BoxStatus status;
          if (s.comp != "100%") {
            var endTime = s.getEndTime();
            var year = endTime.split("-")[0];
            var month = endTime.split("-")[1];
            var day = endTime.split("-")[2];
            if (DateTime(int.parse(year), int.parse(month), int.parse(day)) <
                today) {
              status = BoxStatus.delayed;
            } else {
              status = BoxStatus.underGoing;
            }
          } else {
            status = BoxStatus.done;
          }
          _sdList.add(
              ScheduleGanttModel(index: i, status: status, subjects: _result));
        }
      }
    }

    return _sdList;
  }

  List<ScheduleDates> getDates() {
    List<ScheduleDates> _sdList = [];
    var today = DateTime.now();
    for (int i = 0; i < scheduleList.length; i++) {
      var s = scheduleList[i];

      List<DateTime> _result = [];
      if (s.subject != null) {
        for (var sb in s.subject!) {
          var fromDate = sb.from!.split(" ")[0];
          var endDate = sb.to!.split(" ")[0];

          var year = fromDate.split("-")[0];
          var fromMonth = fromDate.split("-")[1];
          var fromDay = fromDate.split("-")[2];
          var toMonth = endDate.split("-")[1];
          var toDay = endDate.split("-")[2];

          if (fromMonth == toMonth) {
            _result.addAll(List.generate(
                int.parse(sb.duation) + 1,
                (index) => DateTime(int.parse(year), int.parse(fromMonth),
                    index + int.parse(fromDay))));
          } else {
            DateTime start = DateTime(
                int.parse(year), int.parse(fromMonth), int.parse(fromDay));
            DateTime end =
                DateTime(int.parse(year), int.parse(toMonth), int.parse(toDay));

            do {
              _result.add(start);
              start = start.nextDay;
            } while (start <= end);
          }
        }

        BoxStatus status;
        if (s.comp != "100%") {
          var endTime = s.getEndTime();
          var year = endTime.split("-")[0];
          var month = endTime.split("-")[1];
          var day = endTime.split("-")[2];
          if (DateTime(int.parse(year), int.parse(month), int.parse(day)) <
              today) {
            status = BoxStatus.delayed;
          } else {
            status = BoxStatus.underGoing;
          }
        } else {
          status = BoxStatus.done;
        }

        _sdList.add(ScheduleDates(dates: _result, index: i, status: status));
      }
    }

    return _sdList;
  }

  @override
  bool operator ==(Object other) {
    if (status != GanttStatus.initial) {
      return false;
    }
    return identical(this, other) ||
        other is Equatable &&
            runtimeType == other.runtimeType &&
            qu_utils.equals(props, other.props);
  }

  @override
  // ignore: unnecessary_overrides
  int get hashCode => super.hashCode;
}

enum BoxStatus { done, delayed, nothing, cannotSelected, underGoing }

class ScheduleDates {
  List<DateTime> dates;
  int index;
  BoxStatus status;

  ScheduleDates(
      {required this.dates, required this.index, required this.status});
}

class ScheduleGanttModel {
  List<Subject> subjects;
  int index;
  BoxStatus status;

  ScheduleGanttModel(
      {required this.subjects, required this.index, required this.status});
}
