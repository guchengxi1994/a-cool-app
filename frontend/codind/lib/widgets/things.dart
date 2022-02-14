// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:codind/entity/schedule.dart';
import 'package:flutter/material.dart';

class ThingsWidget extends StatefulWidget {
  ThingsWidget({Key? key}) : super(key: key);

  @override
  State<ThingsWidget> createState() => _ThingsWidgetState();
}

class _ThingsWidgetState extends State<ThingsWidget> {
  @override
  Widget build(BuildContext context) {
    Schedule schedule = Schedule(title: "测试");
    schedule.subject = [
      Subject(
          subTitle: "a1",
          from: "2022-01-01 00:00:00",
          to: "2022-01-03 00:00:00",
          subCompletion: 0.25)
    ];
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
          itemCount: 1,
          itemBuilder: ((context, index) {
            if (index == 0) {
              return ThingItem(
                index: index,
                schedule: schedule,
                isFirst: true,
              );
            } else {
              return ThingItem(
                index: index,
                schedule: schedule,
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
    required this.schedule,
    required this.isFirst,
    required this.index,
  }) : super(key: key);
  Schedule schedule;
  bool isFirst;
  int index;

  @override
  State<ThingItem> createState() => _ThingItemState();
}

class _ThingItemState extends State<ThingItem> {
  List<TableRow> tableRows = [];

  @override
  void initState() {
    super.initState();
    if (widget.isFirst) {
      tableRows.add(TableRow(
          //第一行样式 添加背景色
          decoration: BoxDecoration(
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
    tableRows.add(renderSchedule());
  }

  TableRow renderSchedule() {
    return TableRow(children: [
      _TableItemWidget(
        title: widget.index.toString(),
      ),
      InkWell(
        child: Container(
          margin: EdgeInsets.only(left: 5, top: 5),
          alignment: Alignment.centerLeft,
          child: Text(
            widget.schedule.title!,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      InkWell(
        child: _TableItemWidget(
          title: widget.schedule.startTime,
        ),
      ),
      InkWell(
        child: _TableItemWidget(
          title: widget.schedule.endTime,
        ),
      ),
      _TableItemWidget(
        title: widget.schedule.duation,
      ),
      _TableItemWidget(
        title: widget.schedule.comp,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
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
          color: Color.fromARGB(255, 78, 92, 78),
          width: 2.0,
          style: BorderStyle.solid,
        ),
        children: tableRows,
      ),
    ));
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
        style: TextStyle(fontWeight: FontWeight.bold),
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
