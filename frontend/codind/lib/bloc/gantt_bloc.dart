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
    return emit(state.copyWith(
        GanttStatus.changeSchedule, scheduleList, state.operatedSchdule));
  }

  Future<void> _setCurrentSchedule(
      SetOperatingSchedule event, Emitter<GanttState> emit) async {
    return emit(state.copyWith(
        GanttStatus.changeSchedule, state.scheduleList, event.schedule));
  }

  Future<void> _removeSchedule(
      RemoveScheduleEvent event, Emitter<GanttState> emit) async {
    List<Schedule> scheduleList = state.scheduleList;
    scheduleList.removeAt(event.index);
    return emit(state.copyWith(
        GanttStatus.changeSchedule, state.scheduleList, state.operatedSchdule));
  }

  Future<void> _addSchedule(
      AddScheduleEvent event, Emitter<GanttState> emit) async {
    List<Schedule> scheduleList = state.scheduleList;
    scheduleList.add(event.schedule);
    return emit(state.copyWith(
        GanttStatus.changeSchedule, state.scheduleList, state.operatedSchdule));
  }
}
