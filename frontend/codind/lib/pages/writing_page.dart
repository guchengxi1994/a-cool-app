/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-02-02 09:59:42
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-02-02 23:00:13
 */
import 'dart:convert';

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

class _WritingPageState<T> extends BasePageState<WritingPage>
    with SingleTickerProviderStateMixin {
  TextEditingController textEditingController = TextEditingController();
  final GlobalKey<__ChangedMdEditorState> _globalKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FocusNode focusNode = FocusNode();
  late TabController? _tabcontroller;
  var loadEmojiFuture;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      FocusScope.of(context).requestFocus(focusNode);
    });

    super.addAction(TextButton(
        onPressed: () {
          if (Responsive.isRoughMobile(context)) {
            _scaffoldKey.currentState!.openEndDrawer();
          }
        },
        child: Text(
          "点击",
          style: TextStyle(color: Color.fromARGB(255, 201, 28, 28)),
        )));
    loadEmojiFuture =
        DefaultAssetBundle.of(context).loadString("assets/emoji.json");
  }

  @override
  void dispose() {
    textEditingController.dispose();
    _scrollController.dispose();
    focusNode.dispose();
    if (_tabcontroller != null) {
      _tabcontroller!.dispose();
    }
    super.dispose();
  }

  Widget getWritingRegion() {
    return TextField(
      focusNode: focusNode,
      key: const ValueKey<String>("md_editor"),
      maxLines: null,
      controller: textEditingController,
      onChanged: (s) {
        if (Responsive.isRoughDesktop(context)) {
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
    Widget w = getWritingRegion();

    if (Responsive.isRoughMobile(context)) {
      return Scaffold(
        key: _scaffoldKey,
        endDrawer: SizedBox(
          child: Scaffold(
            body: Markdown(data: textEditingController.text),
          ),
          width: 0.8 * MediaQuery.of(context).size.width,
        ),
        body: w,
        bottomSheet: bottomSheet(),
      );
    } else {
      return Scaffold(
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Scaffold(
                bottomSheet: bottomSheet(),
                body: w,
              ),
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

  Widget bottomSheet() {
    return Container(
      color: Colors.grey[300],
      child: Row(
        children: [
          IconButton(
              tooltip: FlutterI18n.translate(context, "label.showEmoji"),
              onPressed: () {
                showModalBottomSheet(
                    enableDrag: false,
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    builder: (BuildContext context) {
                      return FutureBuilder(
                          future: loadEmojiFuture,
                          builder: ((context, snapshot) {
                            if (snapshot.hasData) {
                              List<dynamic> data =
                                  json.decode(snapshot.data.toString());

                              List _lists = splitList(data, 100);
                              print(_lists.length);

                              List<int> _indexList = List<int>.generate(
                                  _lists.length, (index) => index);

                              _tabcontroller = TabController(
                                  length: _lists.length, vsync: this);

                              return Column(
                                children: [
                                  TabBar(
                                      controller: _tabcontroller,
                                      onTap: (i) {
                                        setState(() {
                                          _tabcontroller!.index = i;
                                        });
                                      },
                                      tabs: _indexList.map((e) {
                                        return Container(
                                          child: Text(e.toString()),
                                        );
                                      }).toList()),
                                  Expanded(
                                      child: TabBarView(
                                          controller: _tabcontroller,
                                          children: _lists.map((e) {
                                            return GridView.custom(
                                              // controller: _scrollController,
                                              // physics: ClampingScrollPhysics(),
                                              padding: const EdgeInsets.all(3),
                                              shrinkWrap: true,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount:
                                                    (MediaQuery.of(context)
                                                            .size
                                                            .width ~/
                                                        80),
                                                mainAxisSpacing: 0.5,
                                                crossAxisSpacing: 6.0,
                                              ),
                                              childrenDelegate:
                                                  SliverChildBuilderDelegate(
                                                      ((context, index) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    print(String.fromCharCode(
                                                        e[index]["unicode"]));
                                                    textEditingController
                                                            .text +=
                                                        String.fromCharCode(
                                                            e[index]
                                                                ["unicode"]);
                                                  },
                                                  child: Center(
                                                    child: Text(
                                                      String.fromCharCode(
                                                          data[index]
                                                              ["unicode"]),
                                                      style: const TextStyle(
                                                          fontSize: 33),
                                                    ),
                                                  ),
                                                );
                                              }), childCount: e.length),
                                            );
                                          }).toList()))
                                ],
                              );
                            } else {
                              return const CircularProgressIndicator();
                            }
                          }));
                    });
              },
              icon: const Icon(
                Icons.emoji_emotions,
                color: Colors.orangeAccent,
              )),
        ],
      ),
    );
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
