part of 'gantt_bloc.dart';

abstract class GanttEvent extends Equatable {
  const GanttEvent();

  @override
  List<Object> get props => [];
}

class InitialGanttEvent extends GanttEvent {}

class AddScheduleEvent extends GanttEvent {
  final Schedule schedule;
  const AddScheduleEvent({required this.schedule});
}

class ChangeScheduleEvent extends GanttEvent {
  final Schedule schedule;
  final int index;
  const ChangeScheduleEvent({required this.schedule, required this.index});
}

class AddSubjectEvent extends GanttEvent {
  final Subject subject;
  final int index;
  const AddSubjectEvent({required this.subject, required this.index});
}

class RemoveScheduleEvent extends GanttEvent {
  final int index;
  const RemoveScheduleEvent({required this.index});
}

class RemoveSubjectEvent extends GanttEvent {
  final int index;
  final int subjectIndex;
  const RemoveSubjectEvent({required this.index, required this.subjectIndex});
}

class SetOperatingSchedule extends GanttEvent {
  final Schedule schedule;
  const SetOperatingSchedule({required this.schedule});
}

class ChangeCurrentDateEvent extends GanttEvent {
  final int year;
  final int month;
  const ChangeCurrentDateEvent({required this.year, required this.month});
}

class NothingEvent extends GanttEvent {}
