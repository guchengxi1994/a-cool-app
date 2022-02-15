import 'package:bloc/bloc.dart';
import 'package:codind/entity/schedule.dart';
import 'package:codind/pages/_schedule_detail_page.dart';
import 'package:codind/utils/router.dart';
import 'package:equatable/equatable.dart';
// ignore: implementation_imports
import 'package:equatable/src/equatable_utils.dart' as qu_utils;
import 'package:flutter/material.dart';

part 'gantt_event.dart';
part 'gantt_state.dart';

class GanttBloc extends Bloc<GanttEvent, GanttState> {
  GanttBloc() : super(const GanttState()) {
    on<InitialGanttEvent>(_fetchToState);
    on<ChangeScheduleEvent>(_changeSchedule);
    on<SetOperatingSchedule>(_setCurrentSchedule);
  }

  Future<void> _fetchToState(
      InitialGanttEvent event, Emitter<GanttState> emit) async {
    Schedule schedule = Schedule(title: "测试");
    schedule.subject = [
      Subject(
          subTitle: "a1",
          from: "2022-01-01 00:00:00",
          to: "2022-01-03 00:00:00",
          subCompletion: 0.25)
    ];
    List<Schedule> scheduleList = [
      schedule,
    ];
    return emit(state.copyWith(GanttStatus.initial, scheduleList, null));
  }

  Future<void> _changeSchedule(
      ChangeScheduleEvent event, Emitter<GanttState> emit) async {
    List<Schedule> scheduleList = state.scheduleList;
    scheduleList[event.index] = event.schedule;
    // print("应该执行这个");
    // print(scheduleList[0].title);
    return emit(state.copyWith(GanttStatus.changeSchedule, scheduleList, null));
  }

  Future<void> _setCurrentSchedule(
      SetOperatingSchedule event, Emitter<GanttState> emit) async {
    return emit(state.copyWith(
        GanttStatus.changeSchedule, state.scheduleList, event.schedule));
  }
}
