import 'package:codind/bloc/gantt_bloc.dart';
import 'package:codind/entity/schedule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScheduleDetailPage extends StatefulWidget {
  const ScheduleDetailPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ScheduleDetailPage> createState() => _ScheduleDetailPageState();
}

class _ScheduleDetailPageState extends State<ScheduleDetailPage> {
  int currentIndex = 0;
  late GanttBloc _ganttBloc;

  @override
  void initState() {
    super.initState();
    _ganttBloc = context.read<GanttBloc>();
  }

  @override
  Widget build(BuildContext context) {
    Schedule? schedule =
        ModalRoute.of(context)!.settings.arguments as Schedule?;

    List<Widget> widgets = [];
    widgets.add(const Text(
      "任务名称",
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    ));

    widgets.add(const SizedBox(
      height: 40,
    ));
    widgets.addAll([
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
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
            onPressed: () {},
            icon: const Icon(Icons.plus_one),
          ),
          const SizedBox(
            width: 20,
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.delete),
          ),
          const SizedBox(
            width: 20,
          ),
          IconButton(
            onPressed: () {},
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

    widgets.add(const SizedBox(
      height: 40,
    ));

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

    widgets.add(const SizedBox(
      height: 20,
    ));

    if (schedule != null) {
      for (int i = 0; i < schedule.subject!.length; i++) {
        widgets.add(SubRowWidget(
          subject: schedule.subject![i],
          index: i,
        ));
        currentIndex = i;
      }
    }

    return Scaffold(
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
  SubRowWidget({Key? key, required this.subject, required this.index})
      : super(key: key);
  Subject? subject;
  int index;

  @override
  State<SubRowWidget> createState() => _SubRowWidgetState();
}

class _SubRowWidgetState extends State<SubRowWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.subject != null) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: TextField(
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10.0),
                hintText: widget.subject!.subTitle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(3.0),
                )),
          )),
          Expanded(child: Text(widget.subject!.from!.split(" ")[0])),
          Expanded(child: Text(widget.subject!.to!.split(" ")[0])),
          Expanded(child: Text(widget.subject!.subCompletion.toString())),
          Expanded(
              child: Row(
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.done)),
            ],
          ))
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
              child: TextField(
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(3.0),
                )),
          )),
          Expanded(child: Container()),
          Expanded(child: Container()),
          Expanded(child: Container()),
          Expanded(
              child: Row(
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.done)),
            ],
          ))
        ],
      );
    }
  }
}
