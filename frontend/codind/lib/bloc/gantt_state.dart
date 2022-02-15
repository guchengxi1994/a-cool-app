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

  const GanttState(
      {this.status = GanttStatus.initial, this.scheduleList = const []});

  List<TableRow> getTableRows(int index) {
    var schedule = scheduleList[index];
    List<TableRow> result = [];
    if (index == 0) {
      result.add(TableRow(
          //第一行样式 添加背景色
          decoration: const BoxDecoration(
            color: Colors.grey,
          ),
          children: [
            _TableColumnTitle(
              title: 'ID',
            ),
            _TableColumnTitle(
              title: '项目名称',
            ),
            _TableColumnTitle(
              title: '开始时间',
            ),
            _TableColumnTitle(
              title: '结束时间',
            ),
            _TableColumnTitle(
              title: '时长',
            ),
            _TableColumnTitle(
              title: '完成度',
            ),
          ]));
    }

    result.add(renderSchedule(schedule, index));

    for (int i = 0; i < schedule.subject!.length; i++) {
      result.add(renderSubTitles(schedule.subject![i], index, i));
    }

    return result;
  }

  @override
  List<Object> get props => [status, scheduleList];

  GanttState copyWith(GanttStatus? status, List<Schedule>? scheduleList) {
    return GanttState(
        status: status ?? this.status,
        scheduleList: scheduleList ?? this.scheduleList);
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

class _TableColumnTitle extends StatelessWidget {
  _TableColumnTitle({Key? key, required this.title}) : super(key: key);
  String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 30.0,
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _TableItemWidget extends StatelessWidget {
  _TableItemWidget({Key? key, required this.title}) : super(key: key);
  String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 30.0,
      child: Text(
        title,
      ),
    );
  }
}

TableRow renderSchedule(Schedule schedule, int index) {
  return TableRow(children: [
    _TableItemWidget(
      title: index.toString(),
    ),
    Container(
      margin: const EdgeInsets.only(left: 5, top: 5),
      alignment: Alignment.centerLeft,
      child: Text(
        schedule.title!,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    _TableItemWidget(
      title: schedule.getStartTime(),
    ),
    _TableItemWidget(
      title: schedule.getEndTime(),
    ),
    _TableItemWidget(
      title: schedule.duation,
    ),
    _TableItemWidget(
      title: schedule.comp,
    ),
  ]);
}

TableRow renderSubTitles(Subject subject, int index, int id) {
  return TableRow(children: [
    _TableItemWidget(
      title: index.toString() + "-" + (id + 1).toString(),
    ),
    Container(
      margin: const EdgeInsets.only(left: 5, top: 5),
      alignment: Alignment.centerLeft,
      child: Text(
        "   " + subject.subTitle!,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    _TableItemWidget(
      title: subject.from!.split(" ")[0],
    ),
    _TableItemWidget(
      title: subject.to!.split(" ")[0],
    ),
    _TableItemWidget(
      title: subject.duation,
    ),
    _TableItemWidget(
      title: (subject.subCompletion! * 100 ~/ 1).toString() + "%",
    ),
  ]);
}
