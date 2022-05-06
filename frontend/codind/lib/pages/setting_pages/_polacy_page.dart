// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../globals.dart';

class PolacyPage extends StatefulWidget {
  PolacyPage({Key? key, required this.type, this.needBar = false})
      : super(key: key);

  int type;
  bool? needBar;

  @override
  State<PolacyPage> createState() => _PolacyPageState();
}

class _PolacyPageState extends State<PolacyPage> {
  late String mdStr;

  // ignore: prefer_typing_uninitialized_variables
  var loadMdFuture;

  @override
  void initState() {
    super.initState();
    loadMdFuture = loadAsset();
  }

  Future loadAsset() async {
    if (widget.type == 0) {
      mdStr = await rootBundle.loadString("assets/p/xy.md");
    } else {
      mdStr = await rootBundle.loadString("assets/p/zc.md");
    }

    mdStr = mdStr.replaceAll("[APP]", AppName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.needBar ?? false
          ? AppBar(
              title: widget.type == 0
                  ? Text(
                      "用户协议",
                      style: TextStyle(color: Colors.black),
                    )
                  : Text("隐私政策", style: TextStyle(color: Colors.black)),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(
                  Icons.chevron_left,
                  size: leftBackIconSize,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          : null,
      body: FutureBuilder(
        future: loadMdFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Markdown(data: mdStr);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
