import 'package:bloc/bloc.dart';
import 'package:codind/entity/entity.dart';
import 'package:codind/utils/common.dart' as my;
import 'package:dart_date/dart_date.dart';
import 'package:equatable/equatable.dart';
// ignore: implementation_imports
import 'package:equatable/src/equatable_utils.dart' as qu_utils;

import '../utils/utils.dart' show toDate;

part 'gantt_event.dart';
part 'gantt_state.dart';

class GanttBloc extends Bloc<GanttEvent, GanttState> {
  GanttBloc() : super(const GanttState()) {
    on<InitialGanttEvent>(_fetchToState);
    on<ChangeScheduleEvent>(_changeSchedule);
    on<SetOperatingSchedule>(_setCurrentSchedule);
    on<RemoveScheduleEvent>(_removeSchedule);
    on<AddScheduleEvent>(_addSchedule);
    on<ChangeCurrentDateEvent>(_setDate);
  }

  Future<void> _fetchToState(
      InitialGanttEvent event, Emitter<GanttState> emit) async {
    var date = DateTime.now();
    var endDate = date.addDays(5);
    emit(state.copyWith(
      GanttStatus.initial,
      [],
      null,
      date.year,
      date.month,
      true,
    ));

    // just for test a overloading wrap,
    // will be replaced by an api request
    // await Future.delayed(Duration(seconds: 1)).then((value) {});

    Schedule schedule = Schedule(title: "开始你的学习之旅吧！", editable: false);
    schedule.subject = [
      Subject(
          editable: false,
          subTitle: "学习如何使用Markdown",
          from:
              "${date.year}-${toDate(date.month)}-${toDate(date.day)} 00:00:00",
          to:
              "${endDate.year}-${toDate(endDate.month)}-${toDate(endDate.day)} 00:00:00",
          subCompletion: 0,
          subjectJob: SubjectJob(
              fileLocation: "assets/reserved_md_files/markdown_guide.md",
              subjectMdFrom: DataFrom.asset)),
      Subject(
          editable: false,
          subTitle: "写一个Markdown试试",
          from:
              "${date.year}-${toDate(date.month)}-${toDate(date.day)} 00:00:00",
          to: "${endDate.year}-${toDate(endDate.month)}-${toDate(endDate.day)} 00:00:00",
          subCompletion: 0),
    ];
    List<Schedule> scheduleList = [
      schedule,
    ];

    emit(state.copyWith(
      GanttStatus.initial,
      scheduleList,
      null,
      date.year,
      date.month,
      false,
    ));
  }

  Future<void> _changeSchedule(
      ChangeScheduleEvent event, Emitter<GanttState> emit) async {
    emit(state.copyWith(
      GanttStatus.changeSchedule,
      state.scheduleList,
      state.operatedSchdule,
      state.currentYear,
      state.currentMonth,
      true,
    ));
    List<Schedule> scheduleList = state.scheduleList;
    scheduleList[event.index] = event.schedule;
    // print("应该执行这个");
    // print(scheduleList[0].title);
    emit(state.copyWith(
      GanttStatus.changeSchedule,
      scheduleList,
      state.operatedSchdule,
      state.currentYear,
      state.currentMonth,
      false,
    ));
  }

  Future<void> _setCurrentSchedule(
      SetOperatingSchedule event, Emitter<GanttState> emit) async {
    emit(state.copyWith(
      GanttStatus.changeSchedule,
      state.scheduleList,
      event.schedule,
      state.currentYear,
      state.currentMonth,
      false,
    ));
  }

  Future<void> _removeSchedule(
      RemoveScheduleEvent event, Emitter<GanttState> emit) async {
    List<Schedule> scheduleList = state.scheduleList;
    scheduleList.removeAt(event.index);
    emit(state.copyWith(
      GanttStatus.changeSchedule,
      state.scheduleList,
      state.operatedSchdule,
      state.currentYear,
      state.currentMonth,
      false,
    ));
  }

  Future<void> _addSchedule(
      AddScheduleEvent event, Emitter<GanttState> emit) async {
    List<Schedule> scheduleList = state.scheduleList;
    scheduleList.add(event.schedule);
    emit(state.copyWith(
      GanttStatus.changeSchedule,
      state.scheduleList,
      state.operatedSchdule,
      state.currentYear,
      state.currentMonth,
      false,
    ));
  }

  Future<void> _setDate(
      ChangeCurrentDateEvent event, Emitter<GanttState> emit) async {
    emit(state.copyWith(
      GanttStatus.changeDate,
      state.scheduleList,
      state.operatedSchdule,
      event.year,
      event.month,
      false,
    ));
  }
}
