import 'package:codind/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

enum DataFrom { net, asset, string, file }

// ignore: must_be_immutable
class BaseMarkdownPreviewPage extends StatefulWidget {
  BaseMarkdownPreviewPage({Key? key, this.mdData, required this.from, this.tip})
      : super(key: key);
  final DataFrom from;
  String? mdData;
  String? tip;

  @override
  State<BaseMarkdownPreviewPage> createState() =>
      _BaseMarkdownPreviewPageState();
}

class _BaseMarkdownPreviewPageState extends State<BaseMarkdownPreviewPage> {
  late String markdownData;
  // ignore: prefer_typing_uninitialized_variables
  var _loadDataFuture;

  @override
  void initState() {
    super.initState();
    if (widget.from == DataFrom.string) {
      _loadDataFuture = loadDataFromString();
    } else if (widget.from == DataFrom.asset) {
      _loadDataFuture = loadDataFromAsset();
    } else if (widget.from == DataFrom.net) {
      _loadDataFuture = justAMoment();
    } else {}
  }

  justAMoment() async {
    await Future.delayed(const Duration(milliseconds: 1));
  }

  loadDataFromAsset() async {
    var _data = await rootBundle.loadString(widget.mdData!);
    setState(() {
      markdownData = _data;
    });
  }

  loadDataFromString() async {
    await Future.delayed(const Duration(milliseconds: 1)).then((value) {
      if (widget.mdData != null) {
        setState(() {
          markdownData = widget.mdData!;
        });
      } else {
        setState(() {
          markdownData = FlutterI18n.translate(context, "label.errorMdStr");
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      // ignore: avoid_unnecessary_containers
      body: FutureBuilder(
        future: _loadDataFuture,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.done) {
            if (widget.from != DataFrom.net) {
              return Markdown(
                data: markdownData,
                onTapLink: (text, href, title) async {
                  if (await canLaunch(href!)) {
                    await launch(href);
                  } else {
                    showToastMessage(
                        FlutterI18n.translate(context, "label.cannotLaunch"),
                        context);
                  }
                },
              );
            } else {
              return TextButton(
                  onPressed: () async {
                    if (await canLaunch(widget.mdData!)) {
                      await launch(widget.mdData!);
                    } else {
                      showToastMessage(
                          FlutterI18n.translate(context, "label.cannotLaunch"),
                          context);
                    }
                  },
                  child: Text(
                      FlutterI18n.translate(context, "label.clickToLaunch")));
            }
          } else {
            return Center(
              child: Text(FlutterI18n.translate(context, "label.loadingStr")),
            );
          }
        },
      ),
    );
  }
}
