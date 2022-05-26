import 'dart:io';

import 'package:codind/pages/base_pages/_mobile_base_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:taichi/taichi.dart';

// ignore: must_be_immutable
class MarkdownReadingPage extends MobileBasePage {
  MarkdownReadingPage({Key? key, required this.filepath})
      : super(key: key, pageName: "预览");
  String filepath;

  @override
  MobileBasePageState<MobileBasePage> getState() {
    return _MarkdownReadingPageState();
  }
}

class _MarkdownReadingPageState
    extends MobileBasePageState<MarkdownReadingPage> {
  String filepath = "";

  String filedata = "";

  // ignore: prefer_typing_uninitialized_variables
  var loadDataFuture;

  @override
  void initState() {
    super.initState();
    filepath = widget.filepath;
    loadDataFuture = loadData();
  }

  loadData() async {
    debugPrint("[file path]:$filepath");
    File file = File(filepath);
    filedata = await file.readAsString();
    // debugPrint("[file path]:$filedata");
  }

  @override
  Widget baseBuild(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(
            child: TaichiAutoRotateGraph.simple(size: 150),
          );
        } else {
          return Markdown(data: filedata);
        }
      },
      future: loadDataFuture,
    );
  }
}
