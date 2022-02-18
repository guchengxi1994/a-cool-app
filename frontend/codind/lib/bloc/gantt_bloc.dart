import 'package:bloc/bloc.dart';
import 'package:codind/entity/schedule.dart';
import 'package:codind/utils/common.dart' as my;
import 'package:dart_date/dart_date.dart';
import 'package:equatable/equatable.dart';
// ignore: implementation_imports
import 'package:equatable/src/equatable_utils.dart' as qu_utils;

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
    emit(state.copyWith(
        GanttStatus.initial, [], null, date.year, date.month, true));

    // just for test a overloading wrap,
    // will be replaced by an api request
    await Future.delayed(Duration(seconds: 1)).then((value) {});

    Schedule schedule = Schedule(title: "测试");
    schedule.subject = [
      Subject(
          subTitle: "a1",
          from: "2022-01-01 00:00:00",
          to: "2022-01-03 00:00:00",
          subCompletion: 0.25),
      Subject(
          subTitle: "a2",
          from: "2022-01-05 00:00:00",
          to: "2022-03-03 00:00:00",
          subCompletion: 0.25)
    ];
    List<Schedule> scheduleList = [
      schedule,
      schedule,
    ];

    emit(state.copyWith(
        GanttStatus.initial, scheduleList, null, date.year, date.month, false));
  }

  Future<void> _changeSchedule(
      ChangeScheduleEvent event, Emitter<GanttState> emit) async {
    emit(state.copyWith(GanttStatus.changeSchedule, state.scheduleList,
        state.operatedSchdule, state.currentYear, state.currentMonth, true));
    List<Schedule> scheduleList = state.scheduleList;
    scheduleList[event.index] = event.schedule;
    // print("应该执行这个");
    // print(scheduleList[0].title);
    emit(state.copyWith(GanttStatus.changeSchedule, scheduleList,
        state.operatedSchdule, state.currentYear, state.currentMonth, false));
  }

  Future<void> _setCurrentSchedule(
      SetOperatingSchedule event, Emitter<GanttState> emit) async {
    emit(state.copyWith(GanttStatus.changeSchedule, state.scheduleList,
        event.schedule, state.currentYear, state.currentMonth, false));
  }

  Future<void> _removeSchedule(
      RemoveScheduleEvent event, Emitter<GanttState> emit) async {
    List<Schedule> scheduleList = state.scheduleList;
    scheduleList.removeAt(event.index);
    emit(state.copyWith(GanttStatus.changeSchedule, state.scheduleList,
        state.operatedSchdule, state.currentYear, state.currentMonth, false));
  }

  Future<void> _addSchedule(
      AddScheduleEvent event, Emitter<GanttState> emit) async {
    List<Schedule> scheduleList = state.scheduleList;
    scheduleList.add(event.schedule);
    emit(state.copyWith(GanttStatus.changeSchedule, state.scheduleList,
        state.operatedSchdule, state.currentYear, state.currentMonth, false));
  }

  Future<void> _setDate(
      ChangeCurrentDateEvent event, Emitter<GanttState> emit) async {
    emit(state.copyWith(GanttStatus.changeDate, state.scheduleList,
        state.operatedSchdule, event.year, event.month, false));
  }
}
