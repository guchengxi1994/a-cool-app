import 'package:codind/entity/schedule.dart';
import 'package:codind/utils/toast_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class ScheduleDetailPage extends StatefulWidget {
  ScheduleDetailPage({Key? key, required this.schedule}) : super(key: key);

  Schedule? schedule;

  @override
  State<ScheduleDetailPage> createState() => _ScheduleDetailPageState();
}

class _ScheduleDetailPageState extends State<ScheduleDetailPage> {
  int currentIndex = 0;
  List<Widget> widgets = [];
  late Schedule? schedule;

  int startIndex = 0;

  @override
  void initState() {
    super.initState();
    schedule = widget.schedule;

    widgets.add(const Text(
      "任务名称",
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    ));
    startIndex += 1;
    widgets.add(const SizedBox(
      height: 40,
    ));
    startIndex += 1;
    widgets.addAll([
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10.0),
                  hintText: schedule?.title,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3.0),
                  )),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          IconButton(
            onPressed: () {
              widgets.add(SubRowWidget(
                index: currentIndex + 1,
                subject: null,
                removeSelf: (index) => removeOneLine(index),
                commitSelf: (index, subject) => commitSubject(index, subject),
              ));
              setState(() {});
            },
            icon: const Icon(Icons.plus_one),
          ),
          const SizedBox(
            width: 20,
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pop("deleted");
            },
            icon: const Icon(Icons.delete),
          ),
          const SizedBox(
            width: 20,
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pop(schedule);
            },
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      const Divider(
        thickness: 5,
      ),
      const Text("子任务详情",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    ]);
    startIndex += 3;

    widgets.add(const SizedBox(
      height: 40,
    ));
    startIndex += 1;
    widgets.add(Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Expanded(
            child: Text("子任务名称",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
        Expanded(
            child: Text("开始时间",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
        Expanded(
            child: Text("结束时间",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
        Expanded(
            child: Text("完成度",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
        Expanded(
            child: Text("操作",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
      ],
    ));
    startIndex += 1;
    widgets.add(const SizedBox(
      height: 20,
    ));
    startIndex += 1;

    if (schedule != null) {
      for (int i = 0; i < schedule!.subject!.length; i++) {
        widgets.add(SubRowWidget(
          key: UniqueKey(),
          subject: schedule!.subject![i],
          index: i,
          removeSelf: (index) => removeOneLine(index),
          commitSelf: (index, subject) => commitSubject(index, subject),
        ));
        currentIndex = i;
      }
    }
  }

  void removeOneLine(int index) {
    widgets.removeAt(index + startIndex);
    schedule?.subject?.removeAt(index);
    setState(() {});
  }

  void commitSubject(int index, Subject subject) {
    if (index >= schedule!.subject!.length) {
      schedule!.subject!.add(subject);
    } else {
      schedule?.subject?[index] = subject;
    }
    print(schedule!.subject!.length);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.navigate_before))),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widgets,
          )),
    );
  }
}

class SubRowWidget extends StatefulWidget {
  SubRowWidget(
      {Key? key,
      required this.subject,
      required this.index,
      this.removeSelf,
      this.commitSelf})
      : super(key: key);
  Subject? subject;
  int index;
  final removeSelf;
  final commitSelf;

  @override
  State<SubRowWidget> createState() => _SubRowWidgetState();
}

class _SubRowWidgetState extends State<SubRowWidget> {
  late Subject _subject;

  @override
  void initState() {
    super.initState();
    if (widget.subject != null) {
      _subject = widget.subject!;
    } else {
      _subject =
          Subject(subTitle: "", from: "未输入", to: "未输入", subCompletion: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: TextField(
          onChanged: ((value) => _subject.subTitle = value),
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10.0),
              hintText: _subject.subTitle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(3.0),
              )),
        )),
        Expanded(
            child: TextButton(
          onPressed: () {
            var currentDate = DateTime.now();
            showDatePicker(
                    locale: const Locale('zh'),
                    context: context,
                    initialDate: DateTime(
                        currentDate.year, currentDate.month, currentDate.day),
                    firstDate: DateTime(2022, 1, 1),
                    lastDate: DateTime(2022, 12, 31))
                .then((value) {
              // print(value);
              if (value != null) {
                _subject.from = value.toString().split(" ")[0];
                setState(() {});
              }
            });
          },
          child: Container(
            alignment: Alignment.centerLeft,
            child: Text(_subject.from!.split(" ")[0]),
          ),
        )),
        Expanded(
            child: TextButton(
          onPressed: () {
            var currentDate = DateTime.now();
            showDatePicker(
                    locale: const Locale('zh'),
                    context: context,
                    initialDate: DateTime(
                        currentDate.year, currentDate.month, currentDate.day),
                    firstDate: DateTime(2022, 1, 1),
                    lastDate: DateTime(2022, 12, 31))
                .then((value) {
              // print(value);
              if (value != null) {
                _subject.to = value.toString().split(" ")[0];
                setState(() {});
              }
            });
          },
          child: Container(
            alignment: Alignment.centerLeft,
            child: Text(_subject.to!.split(" ")[0]),
          ),
        )),
        Expanded(
          child: TextButton(
              onPressed: () async {
                await showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      var res = "";
                      return CupertinoAlertDialog(
                        title: Text("输入完成度"),
                        content: Material(
                            child: TextField(
                                onChanged: ((value) {
                                  res = value;
                                }),
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(10.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(3.0),
                                    )))),
                        actions: [
                          CupertinoActionSheetAction(
                              onPressed: () {
                                Navigator.of(context).pop(res);
                              },
                              child: Text(FlutterI18n.translate(
                                  context, "button.label.ok"))),
                        ],
                      );
                    }).then((value) {
                  try {
                    var _res = double.parse(value);
                    if (_res >= 0 && _res <= 1) {
                      _subject.subCompletion = _res;
                      setState(() {});
                    } else {
                      showToastMessage("完成度需大于0小于1", null);
                    }
                  } catch (_) {
                    showToastMessage("数值异常", null);
                  }
                });
              },
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(_subject.subCompletion.toString()),
              )),
        ),
        Expanded(
            child: Row(
          children: [
            IconButton(
                onPressed: () {
                  print("点击了这里");
                  widget.removeSelf(widget.index);
                },
                icon: const Icon(Icons.delete)),
            IconButton(
                tooltip: "提交本条记录",
                onPressed: () {
                  setState(() {
                    if (_subject.subTitle == "") {
                      showToastMessage("标题不能为空", null);
                      return;
                    }
                    try {
                      if (int.parse(_subject.duation) < 0) {
                        showToastMessage("开始时间比结束时间晚", null);
                      } else {
                        widget.commitSelf(widget.index, _subject);
                      }
                    } catch (e) {
                      debugPrint(e.toString());
                      showToastMessage("录入失败", null);
                    }
                  });
                },
                icon: const Icon(Icons.done)),
          ],
        ))
      ],
    );
  }
}
