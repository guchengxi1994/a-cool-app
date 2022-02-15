import 'package:codind/bloc/gantt_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// i need a https://pub.dev/packages/flutter_datetime_picker

class ThingsWidget extends StatefulWidget {
  ThingsWidget({Key? key}) : super(key: key);

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
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
          itemCount: _ganttBloc.state.scheduleList.length,
          itemBuilder: ((context, index) {
            if (index == 0) {
              return ThingItem(
                index: index,
                isFirst: true,
              );
            } else {
              return ThingItem(
                index: index,
                isFirst: false,
              );
            }
          })),
    );
  }
}

class ThingItem extends StatefulWidget {
  ThingItem({
    Key? key,
    required this.isFirst,
    required this.index,
  }) : super(key: key);
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
    return Card(
        child: SingleChildScrollView(
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
        },
        //表格边框样式
        border: TableBorder.all(
          color: const Color.fromARGB(255, 78, 92, 78),
          width: 2.0,
          style: BorderStyle.solid,
        ),
        children: _ganttBloc.state.getTableRows(widget.index),
      ),
    ));
  }
}
