import 'package:codind/bloc/gantt_bloc.dart';
import 'package:codind/entity/entity.dart';
import 'package:codind/pages/_schedule_detail_page.dart';
import 'package:codind/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CalendarType { month, year }

class ThingsWidget extends StatefulWidget {
  ThingsWidget({Key? key, required this.calendarType}) : super(key: key);

  CalendarType calendarType;

  @override
  State<ThingsWidget> createState() => _ThingsWidgetState();
}

class _ThingsWidgetState extends State<ThingsWidget> {
  // Schedule schedule = Schedule(title: "测试");
  late GanttBloc _ganttBloc;
  @override
  void initState() {
    super.initState();
    _ganttBloc = context.read<GanttBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _ganttBloc.state.scheduleList.asMap().keys.map((index) {
        if (index == 0) {
          return ThingItem(
            index: index,
            isFirst: true,
            calendarType: widget.calendarType,
          );
        } else {
          return ThingItem(
            index: index,
            isFirst: false,
            calendarType: widget.calendarType,
          );
        }
      }).toList(),
    );
  }
}

class ThingItem extends StatefulWidget {
  ThingItem({
    Key? key,
    required this.isFirst,
    required this.index,
    required this.calendarType,
  }) : super(key: key);

  CalendarType calendarType;
  bool isFirst;
  int index;

  @override
  State<ThingItem> createState() => _ThingItemState();
}

class _ThingItemState extends State<ThingItem> {
  // late Schedule _schedule;
  bool showDetails = false;
  late GanttBloc _ganttBloc;

  @override
  void initState() {
    super.initState();
    _ganttBloc = context.read<GanttBloc>();
  }

  @override
  Widget build(BuildContext context) {
    // tableRows.add(renderSchedule());
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        //所有列宽
        columnWidths: const {
          //列宽
          0: FixedColumnWidth(50.0),
          1: FixedColumnWidth(300.0),
          2: FixedColumnWidth(100.0),
          3: FixedColumnWidth(100.0),
          4: FixedColumnWidth(100.0),
          5: FixedColumnWidth(100.0),
          6: FixedColumnWidth(50.0),
        },
        //表格边框样式
        border: TableBorder.all(
          color: const Color.fromARGB(255, 78, 92, 78),
          width: 2.0,
          style: BorderStyle.solid,
        ),
        children: getTableRows(widget.index, widget.calendarType),
      ),
    );
  }

  List<TableRow> getTableRows(int index, CalendarType calendarType) {
    var schedule = _ganttBloc.state.scheduleList[index];
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
              title: '用时（天）',
            ),
            _TableColumnTitle(
              title: '完成度',
            ),
            _TableColumnTitle(title: "操作"),
          ]));
    }

    int currentYear = context.read<GanttBloc>().state.currentYear;
    int currentMonth = context.read<GanttBloc>().state.currentMonth;

    if (currentYear <= schedule.toYear &&
        currentYear >= schedule.fromYear &&
        currentMonth <= schedule.toMonth &&
        currentMonth >= schedule.fromMonth) {
      result.add(renderSchedule(schedule, index));

      for (int i = 0; i < schedule.subject!.length; i++) {
        int j = 0;
        if (calendarType == CalendarType.year) {
          result.add(renderSubTitles(schedule.subject![i], index, i));
        } else {
          Subject subject = schedule.subject![i];

          if (currentYear <= subject.toYear &&
              currentYear >= subject.fromYear &&
              currentMonth <= subject.toMonth &&
              currentMonth >= subject.fromMonth) {
            result.add(renderSubTitles(schedule.subject![i], index, j));
            j = j + 1;
          }
        }
      }
    }

    return result;
  }

  TableRow renderSchedule(Schedule schedule, int index) {
    return TableRow(children: [
      _TableItemWidget(
        title: index.toString(),
      ),
      Container(
        height: 30,
        // margin: const EdgeInsets.only(left: 5, top: 5),
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
      SizedBox(
        height: 30,
        child: IconButton(
            onPressed: () async {
              var result = await Global.navigatorKey.currentState!
                  .push(MaterialPageRoute(builder: (_) {
                return ScheduleDetailPage(
                  schedule: schedule,
                );
              }));
              if (result.runtimeType == Schedule) {
                context
                    .read<GanttBloc>()
                    .add(ChangeScheduleEvent(index: index, schedule: result));
              } else if (result.runtimeType == String && result == "deleted") {
                context
                    .read<GanttBloc>()
                    .add(RemoveScheduleEvent(index: index));
              }
            },
            icon: const Icon(Icons.navigate_next)),
      )
    ]);
  }

  TableRow renderSubTitles(Subject subject, int index, int id) {
    return TableRow(children: [
      _TableItemWidget(
        title: index.toString() + "-" + (id + 1).toString(),
      ),
      InkWell(
        onTap: subject.subjectJob != null
            ? () async {
                var _data = "";
                if (subject.subjectJob!.subjectMdFrom == DataFrom.asset) {
                  _data = await rootBundle
                      .loadString(subject.subjectJob!.fileLocation!);
                }

                Map<String, dynamic> params = {
                  "scheduleIndex": index,
                  "subjectId": id,
                  "data": _data,
                };
                Navigator.pushNamed(context, Routers.pageMdPreview,
                    arguments: params);
              }
            : null,
        child: Card(
          color: Colors.grey[300],
          margin: const EdgeInsets.only(left: 5, top: 5, right: 10),
          child: Text(
            "   " + subject.subTitle!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
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
      Container(),
    ]);
  }
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
