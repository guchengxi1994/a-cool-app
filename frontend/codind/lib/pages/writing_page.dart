/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-02-02 09:59:42
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-02-02 14:04:14
 */
import 'package:codind/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '_base_page.dart';

class WritingPage extends BasePage {
  WritingPage({Key? key}) : super(key: key);

  @override
  BasePageState<BasePage> getState() {
    return _WritingPageState();
  }
}

class _WritingPageState<T> extends BasePageState<WritingPage> {
  TextEditingController textEditingController = TextEditingController();
  final GlobalKey<__ChangedMdEditorState> _globalKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      FocusScope.of(context).requestFocus(focusNode);
    });

    super.addAction(TextButton(
        onPressed: () {
          if (Responsive.isMobile(context)) {
            _scaffoldKey.currentState!.openEndDrawer();
          }
        },
        child: Text(
          "点击",
          style: TextStyle(color: Color.fromARGB(255, 201, 28, 28)),
        )));
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
    focusNode.dispose();
  }

  Widget getWritingRegion() {
    return TextField(
      focusNode: focusNode,
      key: const ValueKey<String>("md_editor"),
      maxLines: null,
      controller: textEditingController,
      onChanged: (s) {
        if (Responsive.isDesktop(context)) {
          _globalKey.currentState!.changeData(textEditingController.text);
        }
      },
      toolbarOptions: const ToolbarOptions(
          copy: true, paste: true, cut: true, selectAll: true),
      decoration: InputDecoration.collapsed(
          hintText: FlutterI18n.translate(context, "label.typeHere")),
    );
  }

  @override
  Widget baseBuild(BuildContext context) {
    if (Responsive.isMobile(context)) {
      return Scaffold(
        key: _scaffoldKey,
        endDrawer: SizedBox(
          child: Scaffold(
            body: Markdown(data: textEditingController.text),
          ),
          width: 0.8 * MediaQuery.of(context).size.width,
        ),
        body: Column(
          children: [
            getWritingRegion(),
          ],
        ),
      );
    } else {
      return Scaffold(
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: getWritingRegion(),
              flex: 1,
            ),
            const VerticalDivider(
              thickness: 2,
              color: Colors.grey,
            ),
            Expanded(
              child: Scaffold(
                  body: _ChangedMdEditor(
                key: _globalKey,
                mdData: textEditingController.text,
              )),
              flex: 1,
            )
          ],
        ),
      );
    }
  }
}

class _ChangedMdEditor extends StatefulWidget {
  _ChangedMdEditor({Key? key, this.mdData}) : super(key: key);
  String? mdData;

  @override
  State<_ChangedMdEditor> createState() => __ChangedMdEditorState();
}

class __ChangedMdEditorState extends State<_ChangedMdEditor> {
  String data = "";

  @override
  void initState() {
    super.initState();
    data = widget.mdData ?? "";
  }

  changeData(String d) {
    setState(() {
      data = d;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Markdown(
      data: data,
    );
  }
}
