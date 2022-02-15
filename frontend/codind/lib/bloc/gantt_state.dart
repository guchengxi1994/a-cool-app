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
