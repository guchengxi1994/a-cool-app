import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
// import 'package:loading_overlay/loading_overlay.dart';
import 'package:taichi/taichi.dart';

import '../../_styles.dart';

// ignore: must_be_immutable
abstract class BasePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  BasePage(
      {Key? key,
      required this.routeName,
      this.needLoading,
      this.leadingWidgetClick,
      this.centerTitle,
      this.needWarning})
      : super(key: key);
  String? routeName;
  bool? needLoading;
  bool? centerTitle;
  VoidCallback? leadingWidgetClick;
  bool? needWarning;

  @override
  BasePageState createState() {
    // ignore: no_logic_in_create_state
    return getState();
  }

  BasePageState getState();
}

class BasePageState<T extends BasePage> extends State<T> {
  List<Widget> actions = [];
  bool needLoading = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.needLoading != null) {
      needLoading = widget.needLoading!;
    }
  }

  addAction(Widget w) {
    setState(() {
      actions.add(w);
    });
  }

  addActions(List<Widget> ws) {
    setState(() {
      actions.addAll(ws);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: !needLoading
          ? SafeArea(
              child: baseBuild(context),
            )
          : TaichiOverlay.simple(
              isLoading: isLoading, child: baseBuild(context)),
      appBar: AppBar(
        centerTitle: widget.centerTitle,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: widget.routeName != null
            ? Text(
                widget.routeName!,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              )
            : null,
        leading: IconButton(
            onPressed: () async {
              if (widget.needLoading ?? false) {
                var res = await showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: Text(FlutterI18n.translate(
                            context, "label.exitWarning")),
                        actions: [
                          CupertinoActionSheetAction(
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                              child: Text(FlutterI18n.translate(
                                  context, "button.label.ok"))),
                          CupertinoActionSheetAction(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: Text(FlutterI18n.translate(
                                  context, "button.label.quit"))),
                        ],
                      );
                    });

                if (res) {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                }
              } else {
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(
              Icons.chevron_left,
              size: AppTheme.leftBackIconSize,
              color: Color.fromARGB(255, 78, 63, 63),
            )),
        actions: actions,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void reassemble() {
    super.reassemble();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  void onCreate() {}
  void onDes() {}
  baseBuild(BuildContext context) {}

  @override
  void dispose() {
    super.dispose();
  }
}
