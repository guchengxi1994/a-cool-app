// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable, prefer_const_constructors

import 'package:codind/entity/schedule.dart';
import 'package:codind/utils/platform_utils.dart';
import 'package:codind/utils/toast_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

const double textButtonHeight = 20;
const double textButtonWidth = 30;

class ScheduleDetailPage extends StatefulWidget {
  ScheduleDetailPage(
      {Key? key,
      required this.schedule,
      this.currentYear,
      this.day,
      this.month})
      : super(key: key);
  int? currentYear;
  int? month;
  int? day;
  Schedule? schedule;

  @override
  State<ScheduleDetailPage> createState() => _ScheduleDetailPageState();
}

class _ScheduleDetailPageState extends State<ScheduleDetailPage> {
  List<Widget> widgets = [];
  late Schedule? schedule;

  int startIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.schedule != null) {
      schedule = Schedule.fromJson(widget.schedule!.toJson());
    } else {
      schedule = Schedule(title: "新的日程", subject: [], editable: true);
      if (widget.currentYear != null) {
        schedule!.subject!.add(
          Subject(
              editable: true,
              from: DateTime(widget.currentYear!, widget.month!, widget.day!)
                  .toString(),
              to: DateTime(widget.currentYear!, widget.month!, widget.day!)
                  .toString(),
              subCompletion: 0,
              subTitle: widget.month.toString() +
                  "月" +
                  (widget.day).toString() +
                  "日的事情"),
        );
      }
    }

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
              enabled: schedule?.editable,
              onChanged: ((value) => schedule!.title = value),
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
            onPressed: !schedule!.editable!
                ? null
                : () {
                    Subject _s = Subject(
                        subTitle: "",
                        from: "未输入",
                        to: "未输入",
                        subCompletion: 0,
                        editable: true);
                    schedule!.subject!.add(_s);
                    widgets.add(SubRowWidget(
                      index: schedule!.subject!.length - 1,
                      subject: _s,
                      removeSelf: (index) => removeOneLine(index),
                      commitSelf: (index, subject) =>
                          commitSubject(index, subject),
                    ));

                    setState(() {});
                  },
            icon: const Icon(Icons.plus_one),
          ),
          const SizedBox(
            width: 20,
          ),
          IconButton(
            onPressed: !schedule!.editable!
                ? null
                : () {
                    Navigator.of(context).pop("deleted");
                  },
            icon: const Icon(Icons.delete),
          ),
          const SizedBox(
            width: 20,
          ),
          IconButton(
            onPressed: () {
              if (schedule!.subject == null || schedule!.subject!.isEmpty) {
                showToastMessage("子项目为空", null);
              } else {
                if (schedule!.title == "") {
                  schedule!.title = "新建日程";
                }

                for (var s in schedule!.subject!) {
                  if (!s.validate()) {
                    showToastMessage("子项目验证失败，请确认提交", null);
                    return;
                  }
                }

                Navigator.of(context).pop(schedule);
              }
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
        debugPrint(
            "[debug schedule-detail-page-2]:  ${schedule!.subject![i].editable}");
        widgets.add(SubRowWidget(
          key: UniqueKey(),
          subject: schedule!.subject![i],
          index: i,
          removeSelf: (index) => removeOneLine(index),
          commitSelf: (index, subject) => commitSubject(index, subject),
        ));
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
      debugPrint("[debug schedule-detail-page]: change subject");
      schedule?.subject?[index] = subject;
    }
    // print(schedule!.subject!.length);
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
      // _subject = widget.subject!;
      _subject = Subject.fromJson(widget.subject!.toJson());
    } else {
      _subject = Subject(
          subTitle: "",
          from: "未输入",
          to: "未输入",
          subCompletion: 0,
          editable: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("[debug schedule-detail-page]: ${_subject.editable}");
    debugPrint("[debug schedule-detail-page]: ${_subject.from}");
    debugPrint("[debug schedule-detail-page]: ${_subject.to}");
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: TextField(
          enabled: _subject.editable,
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
                child: Text(_subject.subCompletion?.toStringAsFixed(2) ?? "0"),
              )),
        ),
        Expanded(
            child: (PlatformUtils.isAndroid || PlatformUtils.isIOS)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                          onPressed: () {
                            widget.removeSelf(widget.index);
                          },
                          child: const SizedBox(
                            height: textButtonHeight,
                            width: textButtonWidth,
                            child: Text("删除"),
                          )),
                      TextButton(
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
                          child: const SizedBox(
                              height: textButtonHeight,
                              width: textButtonWidth,
                              child: Text("确认")))
                    ],
                  )
                : Row(
                    children: [
                      IconButton(
                          onPressed: !_subject.editable!
                              ? null
                              : () {
                                  debugPrint(widget.index.toString());
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
