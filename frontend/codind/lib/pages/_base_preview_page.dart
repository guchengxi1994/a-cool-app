import 'package:codind/bloc/gantt_bloc.dart';
import 'package:codind/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:url_launcher/url_launcher.dart';

import '../entity/entity.dart' show DataFrom, Schedule;

class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    debugPrint("[debug]:  ${bloc.runtimeType}      $change");
    super.onChange(bloc, change);
  }
}

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
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Widget buildView(BuildContext context) {
    // print(_ganttBloc.state.operatingSubject == null);
    print(_ganttBloc.state.scheduleList.length);
    var result =
        ModalRoute.of(context)?.settings.arguments as Map<String, int>?;

    if (result == null) {
      return const Center(
        child: Text("Nothing"),
      );
    }

    return Scaffold(
      appBar: null,
      // body: (_ganttBloc.state.scheduleList[result['scheduleIndex']!]
      //             .subject![result['subjectId']!].subjectJob!.subjectMdFrom !=
      //         DataFrom.net
      //     ? Markdown(
      //         key: _globalKey,
      //         controller: scrollController,
      //         data: _ganttBloc
      //                 .state
      //                 .scheduleList[result['scheduleIndex']!]
      //                 .subject![result['subjectId']!]
      //                 .subjectJob!
      //                 .subjectJobData ??
      //             "loading...",
      //         onTapLink: (text, href, title) async {
      //           if (await canLaunch(href!)) {
      //             await launch(href);
      //           } else {
      //             showToastMessage(
      //                 FlutterI18n.translate(context, "label.cannotLaunch"),
      //                 context);
      //           }
      //         },
      //       )
      //     : TextButton(
      //         onPressed: () async {
      //           if (await canLaunch(_ganttBloc
      //               .state
      //               .scheduleList[result['scheduleIndex']!]
      //               .subject![result['subjectId']!]
      //               .subjectJob!
      //               .fileLocation!)) {
      //             await launch(_ganttBloc
      //                 .state
      //                 .scheduleList[result['scheduleIndex']!]
      //                 .subject![result['subjectId']!]
      //                 .subjectJob!
      //                 .fileLocation!);
      //           } else {
      //             showToastMessage(
      //                 FlutterI18n.translate(context, "label.cannotLaunch"),
      //                 context);
      //           }
      //         },
      //         child: Text(
      //             FlutterI18n.translate(context, "label.clickToLaunch"))))
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GanttBloc, GanttState>(builder: (context, state) {
      return LoadingOverlay(
          isLoading: _ganttBloc.state.isLoading, child: buildView(context));
    });
  }
}

class MdPreviewBlocPage extends StatelessWidget {
  const MdPreviewBlocPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GanttBloc(),
      child: const BaseMarkdownPreviewPage(),
    );
  }
}
