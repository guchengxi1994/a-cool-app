import 'package:codind/bloc/gantt_bloc.dart';
import 'package:codind/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
// import 'package:loading_overlay/loading_overlay.dart';
import 'package:taichi/taichi.dart';
import 'package:url_launcher/url_launcher.dart';

import '../entity/entity.dart' show DataFrom, Schedule, Subject;
import '../globals.dart';

// ignore: must_be_immutable
class BaseMarkdownPreviewPage extends StatefulWidget {
  const BaseMarkdownPreviewPage({Key? key}) : super(key: key);

  @override
  State<BaseMarkdownPreviewPage> createState() =>
      _BaseMarkdownPreviewPageState();
}

class _BaseMarkdownPreviewPageState extends State<BaseMarkdownPreviewPage> {
  late String markdownData;
  double offset = 0;
  double mdheight = 0;
  late GanttBloc _ganttBloc;

  ScrollController scrollController = ScrollController();
  final GlobalKey<State<Markdown>> _globalKey = GlobalKey();
  String? mdData;
  var index;
  var id;

  @override
  void initState() {
    super.initState();
    _ganttBloc = context.read<GanttBloc>();
    scrollController.addListener(() {
      // debugPrint("maxScrollExtent:" +
      //     scrollController.position.maxScrollExtent.toString());
      // debugPrint("offset:" + scrollController.offset.toString());
      mdheight = scrollController.position.maxScrollExtent;
      offset = scrollController.offset;
    });

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      // print(scrollController.position.maxScrollExtent);
      debugPrint("[debug md-preview-page]: " + index.toString());
      debugPrint("[debug md-preview-page]: " + id.toString());
      mdheight = scrollController.position.maxScrollExtent;

      double? _com =
          _ganttBloc.state.scheduleList[index].subject![id].subCompletion;
      if (_com != null && _com != 0) {
        scrollController.animateTo(mdheight * _com,
            duration: const Duration(milliseconds: 1000), curve: Curves.ease);
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();

    if (mdheight != 0 && offset != 0) {
      Schedule schedule = _ganttBloc.state.scheduleList[index];
      Subject subject = schedule.subject![id];
      if (offset >= mdheight) {
        subject.subCompletion = 1;
      } else {
        subject.subCompletion = offset / mdheight;
      }
      schedule.subject![id] = subject;

      _ganttBloc.add(ChangeScheduleEvent(schedule: schedule, index: index));
    }

    super.dispose();
  }

  Widget buildView(BuildContext context) {
    // print(_ganttBloc.state.operatingSubject == null);
    // print(_ganttBloc.state.scheduleList.length);
    var result =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (result == null) {
      return const Scaffold(
        body: Center(
          child: Text("Nothing"),
        ),
      );
    }

    index = result['scheduleIndex']!;
    id = result['subjectId']!;

    return Scaffold(
        appBar: PlatformUtils.isWeb
            ? null
            : AppBar(
                leading: IconButton(
                  icon: const Icon(
                    Icons.chevron_left,
                    size: leftBackIconSize,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
        body: (_ganttBloc.state.scheduleList[index].subject![id].subjectJob!
                    .subjectMdFrom !=
                DataFrom.net
            ? Markdown(
                key: _globalKey,
                controller: scrollController,
                data: result['data'] ?? "loading...",
                onTapLink: (text, href, title) async {
                  if (await canLaunch(href!)) {
                    await launch(href);
                  } else {
                    showToastMessage(
                        FlutterI18n.translate(context, "label.cannotLaunch"),
                        context);
                  }
                },
              )
            : TextButton(
                onPressed: () async {
                  if (await canLaunch(_ganttBloc
                      .state
                      .scheduleList[result['scheduleIndex']!]
                      .subject![result['subjectId']!]
                      .subjectJob!
                      .fileLocation!)) {
                    await launch(_ganttBloc
                        .state
                        .scheduleList[result['scheduleIndex']!]
                        .subject![result['subjectId']!]
                        .subjectJob!
                        .fileLocation!);
                  } else {
                    showToastMessage(
                        FlutterI18n.translate(context, "label.cannotLaunch"),
                        context);
                  }
                },
                child: Text(
                    FlutterI18n.translate(context, "label.clickToLaunch")))));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GanttBloc, GanttState>(builder: (context, state) {
      return TaichiOverlay.simple(
          isLoading: _ganttBloc.state.isLoading, child: buildView(context));
    });
  }
}
