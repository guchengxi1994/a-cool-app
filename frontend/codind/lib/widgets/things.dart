import 'package:codind/entity/schedule.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

/// i need a https://pub.dev/packages/flutter_datetime_picker

class ThingsWidget extends StatefulWidget {
  ThingsWidget({Key? key}) : super(key: key);

  @override
  State<ThingsWidget> createState() => _ThingsWidgetState();
}

class _ThingsWidgetState extends State<ThingsWidget> {
  Schedule schedule = Schedule(title: "测试");
  @override
  void initState() {
    super.initState();
    schedule.subject = [
      Subject(
          subTitle: "a1",
          from: "2022-01-01 00:00:00",
          to: "2022-01-03 00:00:00",
          subCompletion: 0.25)
    ];
  }

  @override
  Widget build(BuildContext context) {
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

  late Schedule _schedule;
  bool showDetails = false;

  @override
  void initState() {
    super.initState();
    _schedule = widget.schedule;
    if (widget.isFirst) {
      tableRows.add(TableRow(
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

    tableRows.add(renderSchedule());
    if (showDetails) {
      for (int i = 0; i < _schedule.subject!.length; i++) {
        tableRows.add(renderSubTitles(_schedule.subject![i], i));
      }
    }
  }

  TableRow renderSubTitles(Subject subject, int id) {
    return TableRow(children: [
      _TableItemWidget(
        title: widget.index.toString() + "-" + (id + 1).toString(),
      ),
      InkWell(
        child: Container(
          margin: const EdgeInsets.only(left: 5, top: 5),
          alignment: Alignment.centerLeft,
          child: Text(
            "   " + subject.subTitle!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      InkWell(
        child: _TableItemWidget(
          title: subject.from!.split(" ")[0],
        ),
      ),
      InkWell(
        child: _TableItemWidget(
          title: subject.to!.split(" ")[0],
        ),
      ),
      _TableItemWidget(
        title: subject.duation,
      ),
      _TableItemWidget(
        title: (subject.subCompletion! * 100 ~/ 1).toString() + "%",
      ),
    ]);
  }

  TableRow renderSchedule() {
    return TableRow(children: [
      _TableItemWidget(
        title: widget.index.toString(),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: InkWell(
            onTap: () async {
              await showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: const Text("修改内容"),
                      content: Material(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("修改名称"),
                          TextField(
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(10.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(3.0),
                                )),
                          ),
                          const Text("添加子项"),
                        ],
                      )),
                      actions: [
                        CupertinoActionSheetAction(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(FlutterI18n.translate(
                                context, "button.label.ok"))),
                        CupertinoActionSheetAction(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(FlutterI18n.translate(
                                context, "button.label.quit"))),
                      ],
                    );
                  });
            },
            child: Container(
              margin: const EdgeInsets.only(left: 5, top: 5),
              alignment: Alignment.centerLeft,
              child: Text(
                _schedule.title!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          )),
          IconButton(
              onPressed: () {
                showDetails = !showDetails;
                if (showDetails) {
                  for (int i = 0; i < _schedule.subject!.length; i++) {
                    tableRows.add(renderSubTitles(_schedule.subject![i], i));
                  }
                  setState(() {});
                } else {
                  for (int i = 0; i < _schedule.subject!.length; i++) {
                    tableRows.removeLast();
                  }
                  setState(() {});
                }
              },
              icon: const Icon(Icons.details))
        ],
      ),
      InkWell(
        child: _TableItemWidget(
          title: _schedule.getStartTime(),
        ),
      ),
      InkWell(
        child: _TableItemWidget(
          title: _schedule.getEndTime(),
        ),
      ),
      _TableItemWidget(
        title: _schedule.duation,
      ),
      _TableItemWidget(
        title: _schedule.comp,
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
          color: const Color.fromARGB(255, 78, 92, 78),
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
