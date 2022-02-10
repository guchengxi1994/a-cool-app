// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

/*
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-02-02 09:59:42
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-02-05 11:08:25
 */
import 'dart:convert';

import 'package:codind/providers/my_providers.dart';
import 'package:codind/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';

import '_base_page.dart';

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
  late TabController? _tabcontroller = TabController(length: 0, vsync: this);
  var loadEmojiFuture;
  final ScrollController _scrollController = ScrollController();
  _EmojiFutureEntity emojiEntity = _EmojiFutureEntity();
  int _currentIndex = 0;
  double fontSize = 14;

  late TextEditingController? _controllerRow = TextEditingController();
  late TextEditingController? _controllerColumn = TextEditingController();

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
    // if (null != _tabcontroller) {
    //   _tabcontroller?.dispose();
    // }
    _tabcontroller?.dispose();
    if (_controllerRow != null) {
      _controllerRow!.dispose();
      _controllerColumn!.dispose();
    }
    super.dispose();
  }

  Widget getWritingRegion() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(focusNode);
      },
      child: TextField(
        focusNode: focusNode,
        style: TextStyle(fontSize: fontSize),
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
      ),
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
        bottomSheet: bottomSheet(),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Scaffold(
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
                                    childrenDelegate:
                                        SliverChildBuilderDelegate(
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
                                              .addEmoji(e[index]["unicode"]
                                                  .toString());
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
                                            style:
                                                const TextStyle(fontSize: 33),
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
                                                    String.fromCharCode(
                                                        int.parse(context
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
                                                        .watch<
                                                            EmojiController>()
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

                                return Column(children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TabBar(
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
                                              FlutterI18n.translate(context,
                                                  "label.recentlyUsed"),
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
            IconButton(
                tooltip: FlutterI18n.translate(context, "label.font"),
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
                      builder: (context) {
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Text("字体大小"),
                                  PopupMenuButton(
                                      icon: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: Image.asset(
                                            "assets/icons/details.png"),
                                      ),
                                      itemBuilder: (_) {
                                        List<int> _indexList =
                                            List<int>.generate(
                                                10, (index) => 14 + index);
                                        return _indexList.map((e) {
                                          return PopupMenuItem(
                                              onTap: () {
                                                setState(() {
                                                  fontSize = e * 1.0;
                                                });
                                              },
                                              child: Text(e.toString()));
                                        }).toList();
                                      })
                                ],
                              ),
                            ],
                          ),
                        );
                      });
                },
                icon: const Icon(Icons.font_download)),
            IconButton(
              tooltip: FlutterI18n.translate(context, "label.insert"),
              icon: SizedBox(
                height: 20,
                width: 20,
                child: Image.asset("assets/icons/cursor.png"),
              ),
              onPressed: () async {
                int? result = await showModalBottomSheet(
                    enableDrag: false,
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    builder: (context) {
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text("插入标题"),
                                PopupMenuButton(
                                    tooltip: "",
                                    icon: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child:
                                          Image.asset("assets/icons/head.png"),
                                    ),
                                    itemBuilder: (_) {
                                      return [
                                        PopupMenuItem(
                                            child: TextButton(
                                          onPressed: () {
                                            textEditingController.text +=
                                                "\n# ";
                                          },
                                          child: const Text("插入一级标题"),
                                        )),
                                        PopupMenuItem(
                                            child: TextButton(
                                          onPressed: () {
                                            textEditingController.text +=
                                                "\n## ";
                                          },
                                          child: const Text("插入二级标题"),
                                        )),
                                        PopupMenuItem(
                                            child: TextButton(
                                          onPressed: () {
                                            textEditingController.text +=
                                                "\n### ";
                                          },
                                          child: const Text("插入三级标题"),
                                        )),
                                        PopupMenuItem(
                                            child: TextButton(
                                          onPressed: () {
                                            textEditingController.text +=
                                                "\n#### ";
                                          },
                                          child: const Text("插入四级标题"),
                                        )),
                                        PopupMenuItem(
                                            child: TextButton(
                                          onPressed: () {
                                            textEditingController.text +=
                                                "\n##### ";
                                          },
                                          child: const Text("插入五级标题"),
                                        )),
                                        PopupMenuItem(
                                            child: TextButton(
                                          onPressed: () {
                                            textEditingController.text +=
                                                "\n###### ";
                                          },
                                          child: const Text("插入六级标题"),
                                        )),
                                      ];
                                    })
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text("插入样式"),
                                PopupMenuButton(
                                    tooltip: "",
                                    onSelected: ((value) {
                                      if (value == "\n***\n") {
                                        textEditingController.text +=
                                            value.toString();
                                        Navigator.of(context).pop(null);
                                      } else {
                                        if (value != null) {
                                          textEditingController.text +=
                                              value.toString();
                                          Navigator.of(context).pop(
                                              value.toString().length * 0.5);
                                        } else {
                                          Navigator.of(context).pop(null);
                                        }
                                      }
                                    }),
                                    icon: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: Image.asset("assets/icons/ct.png"),
                                    ),
                                    itemBuilder: (_) {
                                      return [
                                        const PopupMenuItem(
                                          value: "****",
                                          child: Text("插入粗体"),
                                        ),
                                        const PopupMenuItem(
                                          value: "**",
                                          child: Text("插入斜体"),
                                        ),
                                        const PopupMenuItem(
                                          value: "******",
                                          child: Text("插入粗斜体"),
                                        ),
                                        const PopupMenuItem(
                                          value: "~~~~",
                                          child: Text("插入删除线"),
                                        ),
                                        const PopupMenuItem(
                                            value: "\n***\n",
                                            child: Text("插入分割线")),
                                      ];
                                    }),
                              ],
                            ),
                          ],
                        ),
                      );
                    });

                if (result != null) {
                  FocusScope.of(context).requestFocus(focusNode);
                  textEditingController.selection = TextSelection(
                      baseOffset: textEditingController.text.length - result,
                      extentOffset: textEditingController.text.length - result);
                }
              },
            ),
            IconButton(
                tooltip: FlutterI18n.translate(context, "label.link"),
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
                      builder: (context) {
                        return SingleChildScrollView(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("插入图片链接"),
                                  IconButton(
                                      onPressed: () {
                                        textEditingController.text += "![]()";
                                      },
                                      icon: const Icon(Icons.add)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("插入网络链接"),
                                  IconButton(
                                      onPressed: () {
                                        textEditingController.text += "[]()";
                                      },
                                      icon: const Icon(Icons.add)),
                                ],
                              )
                            ]));
                      });
                },
                icon: SizedBox(
                  height: 20,
                  width: 20,
                  child: Image.asset("assets/icons/link.png"),
                )),
            IconButton(
                tooltip: FlutterI18n.translate(context, "label.insertList"),
                onPressed: () {
                  textEditingController.text += "\n* ";
                },
                icon: const Icon(Icons.list)),
            IconButton(
                tooltip: FlutterI18n.translate(context, "label.insertTable"),
                onPressed: () async {
                  // textEditingController.text += "\n* ";
                  _controllerRow = TextEditingController();
                  _controllerColumn = TextEditingController();
                  List? result = await showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: Text("选择表格尺寸"),
                          content: Card(
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text("行"),
                                    SizedBox(
                                      height: 30,
                                      width: 50,
                                      child: TextField(
                                        decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.all(10.0),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(3.0),
                                            )),
                                        controller: _controllerRow,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text("列"),
                                    SizedBox(
                                      height: 30,
                                      width: 50,
                                      child: TextField(
                                        decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.all(10.0),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(3.0),
                                            )),
                                        controller: _controllerColumn,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            CupertinoActionSheetAction(
                                onPressed: () {
                                  int? rowNumber;
                                  int? columnNumber;
                                  try {
                                    rowNumber = int.parse(_controllerRow!.text);
                                    columnNumber =
                                        int.parse(_controllerColumn!.text);
                                  } catch (e) {
                                    rowNumber = null;
                                    columnNumber = null;
                                  }
                                  Navigator.of(context)
                                      .pop([rowNumber, columnNumber]);
                                },
                                child: Text(FlutterI18n.translate(
                                    context, "button.label.ok"))),
                            CupertinoActionSheetAction(
                                onPressed: () {
                                  Navigator.of(context).pop(null);
                                },
                                child: Text(FlutterI18n.translate(
                                    context, "button.label.quit"))),
                          ],
                        );
                      });
                  if (result != null &&
                      result[0] != null &&
                      result[1] != null) {
                    textEditingController.text +=
                        convertTabelScaleToString(result[0], result[1]);
                  } else {
                    showToastMessage("行列数值错误", null);
                  }
                },
                icon: const Icon(Icons.table_chart)),
          ],
        ));
  }
}

String convertTabelScaleToString(int rowNumber, int columnNumber) {
  if (rowNumber <= 0) rowNumber = 1;
  if (columnNumber <= 0) columnNumber = 1;
  String titleStr = "|";
  for (int i = 0; i < columnNumber; i++) {
    titleStr += "表头 |";
  }
  titleStr += "\n";
  String subTitleStr = "|";
  for (int i = 0; i < columnNumber; i++) {
    subTitleStr += "---- |";
  }
  subTitleStr += '\n';

  String contentStr = "";
  for (int i = 0; i < rowNumber; i++) {
    contentStr += '|';
    for (int j = 0; j < columnNumber; j++) {
      contentStr += "单元格 |";
    }
    contentStr += "\n";
  }
  return titleStr + subTitleStr + contentStr;
}

class WritingProviderPage extends StatelessWidget {
  const WritingProviderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeController()),
        ChangeNotifierProvider(
          create: (_) => MenuController(),
        ),
        ChangeNotifierProvider(
          create: (_) => EmojiController(),
        ),
        ChangeNotifierProvider(
          create: (_) => LanguageController(context),
        ),
      ],
      child: WritingPage(),
    );
  }
}
