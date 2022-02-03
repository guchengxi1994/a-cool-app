/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-02-02 09:59:42
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-02-03 18:51:14
 */
import 'dart:convert';

import 'package:codind/providers/my_providers.dart';
import 'package:codind/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';

import '_base_page.dart';

class WritingPage extends BasePage {
  WritingPage({Key? key}) : super(key: key);

  @override
  BasePageState<BasePage> getState() {
    return _WritingPageState();
  }
}

class _WritingPageState<T> extends BasePageState<WritingPage>
    with TickerProviderStateMixin {
  TextEditingController textEditingController = TextEditingController();
  final GlobalKey<__ChangedMdEditorState> _globalKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FocusNode focusNode = FocusNode();
  late TabController? _tabcontroller;
  var loadEmojiFuture;
  final ScrollController _scrollController = ScrollController();
  _EmojiFutureEntity emojiEntity = _EmojiFutureEntity();
  int _currentIndex = 0;

  late String markdownStr = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      FocusScope.of(context).requestFocus(focusNode);
    });

    super.addAction(IconButton(
      onPressed: () {
        if (Responsive.isRoughMobile(context)) {
          if (!_scaffoldKey.currentState!.isEndDrawerOpen) {
            setState(() {
              markdownStr = textEditingController.text;
            });

            _scaffoldKey.currentState!.openEndDrawer();
          }
        }
      },
      icon: const Icon(
        Icons.preview,
        color: Colors.white,
      ),
    ));

    loadEmojiFuture = getEmojiInfo();
  }

  Future<void> getEmojiInfo() async {
    emojiEntity.jsonLikeStr =
        await DefaultAssetBundle.of(context).loadString("assets/emoji.json");
    emojiEntity.usedEmoji = await spGetEmojiData();
    await context.read<EmojiController>().setEmojis(emojiEntity.usedEmoji);
    setState(() {});
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
            body: Markdown(
              data: markdownStr,
            ),
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
                // print("我这里重新绘制页面啦");

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
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              List<dynamic> data = json
                                  .decode(emojiEntity.jsonLikeStr.toString());

                              List _lists = splitList(data, 100);
                              // print(_lists.length);

                              List<int> _indexList = List<int>.generate(
                                  _lists.length + 1, (index) => index);

                              _tabcontroller = TabController(
                                  length: _lists.length + 1, vsync: this);

                              _tabcontroller!.index = _currentIndex;

                              List<Widget> _body = _lists.map((e) {
                                return GridView.custom(
                                  // controller: _scrollController,
                                  // physics: ClampingScrollPhysics(),
                                  padding: const EdgeInsets.all(3),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        (MediaQuery.of(context).size.width ~/
                                            80),
                                    mainAxisSpacing: 0.5,
                                    crossAxisSpacing: 6.0,
                                  ),
                                  childrenDelegate: SliverChildBuilderDelegate(
                                      ((context, index) {
                                    return GestureDetector(
                                      onTap: () async {
                                        // print(String.fromCharCode(
                                        //     e[index]["unicode"]));
                                        textEditingController.text +=
                                            String.fromCharCode(
                                                e[index]["unicode"]);
                                        await spAppendColorData(
                                            e[index]["unicode"].toString());

                                        await context
                                            .read<EmojiController>()
                                            .addEmoji(
                                                e[index]["unicode"].toString());
                                        if (Responsive.isRoughDesktop(
                                            context)) {
                                          _globalKey.currentState!.changeData(
                                              textEditingController.text);
                                        }
                                      },
                                      child: Center(
                                        child: Text(
                                          String.fromCharCode(
                                              e[index]["unicode"]),
                                          style: const TextStyle(fontSize: 33),
                                        ),
                                      ),
                                    );
                                  }), childCount: e.length),
                                );
                              }).toList();

                              _body.insert(
                                  0,
                                  context
                                          .watch<EmojiController>()
                                          .useEmojis
                                          .isNotEmpty
                                      ? GridView.custom(
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
                                                textEditingController.text +=
                                                    String.fromCharCode(
                                                        int.parse(Provider.of<
                                                                    EmojiController>(
                                                                context,
                                                                listen: false)
                                                            .useEmojis[index]));

                                                if (Responsive.isRoughDesktop(
                                                    context)) {
                                                  _globalKey.currentState!
                                                      .changeData(
                                                          textEditingController
                                                              .text);
                                                }
                                              },
                                              child: Center(
                                                child: Text(
                                                  String.fromCharCode(int.parse(
                                                      context
                                                          .watch<
                                                              EmojiController>()
                                                          .useEmojis[index])),
                                                  style: const TextStyle(
                                                      fontSize: 33),
                                                ),
                                              ),
                                            );
                                          }),
                                                  childCount: context
                                                      .watch<EmojiController>()
                                                      .useEmojis
                                                      .length),
                                        )
                                      : GridView(
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
                                        ));

                              // print(_body.length);
                              // print(_indexList.length);

                              return Column(children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                TabBar(
                                    // unselectedLabelColor: Colors.grey[300],
                                    // unselectedLabelStyle:
                                    //     const TextStyle(color: Colors.grey),
                                    isScrollable: true,
                                    controller: _tabcontroller,
                                    onTap: (i) {
                                      setState(() {
                                        _tabcontroller!.index = i;
                                        _currentIndex = i;
                                      });
                                    },
                                    tabs: _indexList.map((e) {
                                      if (e == 0) {
                                        return Text(
                                            FlutterI18n.translate(
                                                context, "label.recentlyUsed"),
                                            style: const TextStyle(
                                                color: Colors.blue));
                                      } else {
                                        return Text(
                                          FlutterI18n.translate(
                                              context, "label.nPage",
                                              translationParams: {
                                                'n': (e).toString()
                                              }),
                                          style: const TextStyle(
                                              color: Colors.blue),
                                        );
                                      }
                                    }).toList()),
                                Expanded(
                                  child: TabBarView(
                                      controller: _tabcontroller,
                                      children: _body),
                                ),
                              ]);
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

class _EmojiFutureEntity {
  List<String>? usedEmoji;
  String? jsonLikeStr;

  _EmojiFutureEntity({this.usedEmoji, this.jsonLikeStr});

  // ignore: unused_element
  _EmojiFutureEntity.fromJson(Map<String, dynamic> json) {
    usedEmoji = json['usedEmoji'].cast<String>();
    jsonLikeStr = json['jsonLikeStr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['usedEmoji'] = usedEmoji;
    data['jsonLikeStr'] = jsonLikeStr;
    return data;
  }
}
